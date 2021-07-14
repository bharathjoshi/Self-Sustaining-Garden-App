import 'dart:collection';
import 'package:flutter/material.dart';
import '../widgets/app_status_widget.dart';
import '../widgets/garden_view_widget.dart';
import '../widgets/garden_stat_widget.dart';
import '../app-css.dart';
import 'package:firebase_database/firebase_database.dart';

class LiveGardenScreen extends StatefulWidget {
  static const String routeName = '/live-_garden-screen';

  final GardenData _garden;
  final DatabaseReference _dbRef = FirebaseDatabase.instance.reference();

  LiveGardenScreen(this._garden);

  @override
  _LiveGardenScreenState createState() => _LiveGardenScreenState();
}

class _LiveGardenScreenState extends State<LiveGardenScreen> {
  final int limit = 60;
  int _initialPage = 0;
  bool _isLoading = true;
  late PageController _pageController;
  late List<DateTime>? _datetime;
  late List<dynamic>? _sensordata;
  late DateTime? _sprinkleTime;

  void addSprinkleData(DateTime time) async {
    await widget._dbRef
        .child(
            widget._garden.dbpath + '/location${_initialPage + 1}/sprinkling')
        .push()
        .set(time.millisecondsSinceEpoch)
        .then(
          (value) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Database update successful.'),
            ),
          ),
        )
        .catchError(
          (onError) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text('Database update unsuccessfu.'),
            ),
          ),
        );
  }

  Future<void> _retrieveData() async {
    var dtsnap = await widget._dbRef
        .child(widget._garden.dbpath + '/location${_initialPage + 1}/datetime')
        .limitToLast(limit)
        .once();
    var sdsnap = await widget._dbRef
        .child(
            widget._garden.dbpath + '/location${_initialPage + 1}/sensordata')
        .limitToLast(limit)
        .once();
    var spsnap = await widget._dbRef
        .child(
            widget._garden.dbpath + '/location${_initialPage + 1}/sprinkling')
        .limitToLast(1)
        .once();
    setState(() {
      _datetime = (dtsnap.value == null)
          ? null
          : SplayTreeMap.from(
              dtsnap.value,
              (a, b) => (a! as String).compareTo(b as String),
            )
              .values
              .map((element) => DateTime.fromMillisecondsSinceEpoch(element))
              .toList();
      _sensordata = (sdsnap.value == null)
          ? null
          : SplayTreeMap.from(
              sdsnap.value,
              (a, b) => (a! as String).compareTo(b as String),
            ).values.toList();
      _sprinkleTime = (spsnap.value == null)
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
              spsnap.value.values.toList()[0]);
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _initialPage);
    _retrieveData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          title: Text(
            widget._garden.name,
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            ),
            splashRadius: 22,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraint) {
            return RefreshIndicator(
              color: Theme.of(context).primaryColorDark,
              onRefresh: () => _retrieveData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 250,
                          child: PageView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              return GardenView(
                                widget._garden.locsurl[index],
                                'Location ${index + 1}',
                                height: 250,
                              );
                            },
                            onPageChanged: (int index) {
                              setState(() {
                                _initialPage = index;
                                _isLoading = true;
                                _retrieveData();
                              });
                            },
                            controller: _pageController,
                            itemCount: widget._garden.locsurl.length,
                          ),
                        ),
                        Expanded(
                          child: IndexedStack(
                            index: _initialPage,
                            children: List.generate(
                              widget._garden.locsurl.length,
                              (int index) {
                                return (_isLoading)
                                    ? LoadingMessage(
                                        'Retreving data from Database ...',
                                      )
                                    : GardenStat(
                                        _datetime,
                                        _sensordata,
                                        _sprinkleTime,
                                        addSprinkleData,
                                      );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
