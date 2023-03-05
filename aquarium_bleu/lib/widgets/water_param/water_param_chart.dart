import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class WaterParamChart extends StatefulWidget {
  final List<dynamic> dataSource;

  const WaterParamChart({
    required this.dataSource,
    super.key,
  });

  @override
  State<WaterParamChart> createState() => _WaterParamChartState();
}

class _WaterParamChartState extends State<WaterParamChart> {
  @override
  Widget build(BuildContext context) {
    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries>[
        LineSeries(
          color: ColorScheme.fromSwatch().primary,
          animationDuration: 800,
          dataSource: widget.dataSource,
          xValueMapper: (dataPoint, _) => dataPoint.date,
          yValueMapper: (dataPoint, _) => dataPoint.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
          markerSettings: const MarkerSettings(isVisible: true),
        )
      ],
    );
  }
}
