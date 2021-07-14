import 'package:flutter/material.dart';
import '/widgets/app_status_widget.dart';
import '/widgets/sensor_info_widget.dart';

class GardenStat extends StatelessWidget {
  final List<DateTime>? _datetime;
  final List<dynamic>? _sensordata;
  final DateTime? _sprinkleTime;
  final Function _addSprinkleData;

  GardenStat(
    this._datetime,
    this._sensordata,
    this._sprinkleTime,
    this._addSprinkleData,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: (_datetime == null || _sensordata == null)
          ? Center(
              child: ErrorMessage(
                'Unable to Retrieve data from Database',
                '\nMake sure the sensors are working properly.',
              ),
            )
          : Column(
              children: [
                const SizedBox(height: 8),
                SensorInfo(
                  _datetime,
                  _sensordata,
                  _sprinkleTime!,
                  _addSprinkleData,
                ),
                const SizedBox(height: 8),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
    );
  }
}
