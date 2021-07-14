import 'dart:math';
import 'package:flutter/material.dart';
import 'package:weather_icons/weather_icons.dart';
import '/widgets/time_series_chart_widget.dart';

TableRow _tableRow(
  String key,
  String value,
) {
  return TableRow(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Text(key),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 2.0),
        child: Text(
          value,
          textAlign: TextAlign.right,
        ),
      ),
    ],
  );
}

String _timeToString(DateTime time) {
  return '${time.day}'.padLeft(2, '0') +
      '/' +
      '${time.month}'.padLeft(2, '0') +
      '/' +
      '${time.year}'.padLeft(4, '0') +
      ' ' +
      '${time.hour}'.padLeft(2, '0') +
      ':' +
      '${time.minute}'.padLeft(2, '0');
}

class SensorReport extends StatelessWidget {
  final String label;
  final String units;
  final List<DateTime>? _datetime;
  final List<double> _sensordata;
  final MaterialColor color;
  final DateTime begin;
  final DateTime end;
  final double maxValue;
  final double minValue;
  final double average;
  final double beginForecast;
  final double endForecast;

  SensorReport(
    this.label,
    this.units,
    this.color,
    this._datetime,
    this._sensordata,
  )   : begin = _datetime![0],
        end = _datetime[_datetime.length - 1],
        maxValue = _sensordata.reduce(max),
        minValue = _sensordata.reduce(min),
        average = _sensordata.reduce((a, b) => a + b) / _sensordata.length,
        beginForecast = (_sensordata.length > 1)
            ? (_sensordata[0] + _sensordata[1]) / 2
            : _sensordata[0],
        endForecast = (_sensordata.length > 1)
            ? (_sensordata[_sensordata.length - 1] +
                    _sensordata[_sensordata.length - 2]) /
                2
            : _sensordata[_sensordata.length - 1];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          accentColor: color,
        ),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: ColoredBox(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    label + ' Report',
                    style: TextStyle(
                      fontSize: 20,
                      color: color[800],
                    ),
                  ),
                  const SizedBox(height: 6),
                  TimeSeriesChart(
                    _datetime,
                    _sensordata,
                    label,
                    color,
                  ),
                  const SizedBox(height: 6),
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _tableRow(
                        'Begin',
                        _timeToString(begin),
                      ),
                      _tableRow(
                        'End',
                        _timeToString(end),
                      ),
                      _tableRow(
                        'Average',
                        average.toStringAsFixed(1) + ' $units',
                      ),
                      _tableRow(
                        'Minimum',
                        minValue.toStringAsFixed(1) + ' $units',
                      ),
                      _tableRow(
                        'Maximum',
                        maxValue.toStringAsFixed(1) + ' $units',
                      ),
                      _tableRow(
                        _timeToString(begin.add(Duration(days: 1))),
                        beginForecast.toStringAsFixed(1) + ' $units',
                      ),
                      _tableRow(
                        _timeToString(end.add(Duration(days: 1))),
                        endForecast.toStringAsFixed(1) + ' $units',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            color: color.withOpacity(0.2),
          ),
        ),
      ),
      elevation: 0,
    );
  }
}

class SensorValue extends StatelessWidget {
  final String label;
  final String units;
  final List<DateTime>? datetime;
  final List<double> sensordata;
  final IconData icon;
  final MaterialColor color;
  final double size;
  final double recentValue;

  SensorValue(
    this.label,
    this.units,
    this.datetime,
    this.sensordata,
    this.color,
    this.icon, {
    this.size: 90,
  }) : recentValue = sensordata[sensordata.length - 1];

  void _showMaterialDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => SensorReport(
        label,
        units,
        color,
        datetime,
        sensordata,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(5),
      color: color.withOpacity(0.1),
      child: InkWell(
        splashFactory: InkRipple.splashFactory,
        onTap: () => _showMaterialDialog(context),
        child: SizedBox(
          child: Column(
            children: [
              BoxedIcon(
                icon,
                color: color,
                size: 24,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color[700],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${recentValue.toStringAsFixed(1)} $units',
                style: TextStyle(
                  color: color[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
          width: size,
          height: size,
        ),
      ),
    );
  }
}

List<String> locationReport(
  DateTime sprinkle,
  double moisture,
  double temperature,
  double humidity,
) {
  String _sprinkle =
      '${sprinkle.day}/${sprinkle.month}/${sprinkle.year} ${sprinkle.hour}:${sprinkle.minute}';
  List<String> _report = [
    'Last sprinkling was on $_sprinkle.',
  ];
  if (moisture >= 80) {
    _report.addAll([
      'The soil is extremely wet at the moment.',
      'This location dries up in two days at this rate.'
    ]);
  } else if (moisture >= 50) {
    _report.addAll([
      'The soil is pretty wet at the moment.',
      'This location dries up in one day at this rate.'
    ]);
  } else if (moisture >= 20) {
    _report.addAll([
      'The soil is pretty dry at the moment.',
      'This location needs moisture retention.'
    ]);
  } else {
    _report.addAll([
      'The soil is extremely dry at the moment.',
      'This location needs immediate moisture retention.'
    ]);
  }
  if (humidity >= 80 && temperature <= 28) {
    _report.add('It looks like it might rain in the near future.');
  } else {
    _report.add('It does not look like it might rain in the near future.');
  }
  return _report;
}

class SensorInfo extends StatelessWidget {
  final List<DateTime>? _datetime;
  final List<dynamic>? _sensordata;
  final DateTime _sprinkletime;
  final Function _addSprinkleData;

  SensorInfo(
    this._datetime,
    this._sensordata,
    this._sprinkletime,
    this._addSprinkleData,
  );

  @override
  Widget build(BuildContext context) {
    List<double> humidityValues = [];
    List<double> temperatureValues = [];
    List<double> moistureValues = [];

    _sensordata!.forEach((element) {
      humidityValues.add(element["humidity"].toDouble());
      temperatureValues.add(element["temperature"].toDouble());
      moistureValues
          .add((100 - element["moisture"].toDouble() * 0.097).toDouble());
    });

    List<String> report = locationReport(
      _sprinkletime,
      moistureValues[moistureValues.length - 1],
      temperatureValues[temperatureValues.length - 1],
      humidityValues[humidityValues.length - 1],
    );
    List<Widget> _reportTitles = List.generate(report.length, (int index) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        color: Colors.brown.withOpacity(0.2),
        child: Text(
          report[index],
          style: TextStyle(fontSize: 16),
        ),
      );
    });

    return Flexible(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sensor Outputs',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    SensorValue(
                      'Humdity',
                      'RH',
                      _datetime,
                      humidityValues,
                      Colors.green,
                      WeatherIcons.strong_wind,
                    ),
                    SensorValue(
                      'Temperature',
                      '°C',
                      _datetime,
                      temperatureValues,
                      Colors.orange,
                      WeatherIcons.thermometer,
                    ),
                    SensorValue(
                      'Moisture',
                      '%',
                      _datetime,
                      moistureValues,
                      Colors.indigo,
                      WeatherIcons.sprinkle,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Location Report',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    const SizedBox(height: 8),
                    _reportTitles[0],
                    const SizedBox(height: 8),
                    _reportTitles[1],
                    const SizedBox(height: 8),
                    _reportTitles[2],
                    const SizedBox(height: 8),
                    _reportTitles[3],
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 6.0,
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Action Dashboard',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      _showMyDialog(
                          context, () => _addSprinkleData(DateTime.now()));
                    },
                    child: Text('SPRINKLE'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void _showMyDialog(BuildContext context, Function onpress) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Confirm"),
        content: Text(
          'Would you like to activate the sprinklers and update the database?',
        ),
        actions: [
          TextButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: Text('Yes'),
            onPressed: () {
              onpress();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
