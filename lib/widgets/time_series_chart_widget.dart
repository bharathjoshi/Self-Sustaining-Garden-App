import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartSampleData {
  final DateTime time;
  final double value;

  ChartSampleData(
    this.time,
    this.value,
  );
}

class TimeSeriesChart extends StatelessWidget {
  final double size;
  final MaterialColor _color;
  final String _ylabel;
  final List<ChartSampleData> _data;

  TimeSeriesChart(
    _x,
    _y,
    this._ylabel,
    this._color, {
    this.size: 360,
  }) : _data = List.generate(
          _x.length,
          (index) => ChartSampleData(_x[index], _y[index]),
        );

  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      series: [
        LineSeries<ChartSampleData, DateTime>(
          dataSource: _data,
          name: _ylabel,
          color: _color[800],
          dashArray: [5, 5],
          enableTooltip: true,
          animationDuration: 0,
          xValueMapper: (ChartSampleData sales, int index) => sales.time,
          yValueMapper: (ChartSampleData sales, int index) => sales.value,
          trendlines: <Trendline>[
            Trendline(
              color: _color[300]!,
              type: TrendlineType.movingAverage,
              animationDuration: 4000,
            )
          ],
        )
      ],
      primaryXAxis: DateTimeAxis(
        majorGridLines: MajorGridLines(width: 0),
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      primaryYAxis: NumericAxis(
        edgeLabelPlacement: EdgeLabelPlacement.shift,
      ),
      borderWidth: 1,
      borderColor: _color,
      tooltipBehavior: TooltipBehavior(enable: true),
    );
  }
}
