import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import '../app-css.dart';
import 'live_garden_screen.dart';
import '../widgets/app_status_widget.dart';
import '../widgets/garden_view_widget.dart';

class HomeScreen extends StatelessWidget {
  static const String routeName = '/home-screen';

  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();

  void navigateTo(
    BuildContext context,
    GardenData garden,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LiveGardenScreen(garden),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColorLight,
        appBar: AppBar(
          title: Text(
            'List of Gardens',
          ),
          backgroundColor: Theme.of(context).primaryColorDark,
          elevation: 0,
        ),
        body: FutureBuilder<FirebaseApp>(
          future: _fbApp,
          builder: (BuildContext context, AsyncSnapshot<FirebaseApp> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                  physics: BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: GardenView(
                            gardenList[index].picurl,
                            gardenList[index].name,
                          ),
                        ),
                        onTap: () => navigateTo(context, gardenList[index]),
                      ),
                    );
                  },
                  itemCount: gardenList.length,
                );
              } else {
                return Center(
                  child: ErrorMessage(
                    'Error Establishing Connection to Backend.',
                    '\nPlease try again later ...',
                  ),
                );
              }
            } else {
              return Align(
                alignment: Alignment.center,
                child: LoadingMessage(
                  'Connecting to a Backend ...',
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
