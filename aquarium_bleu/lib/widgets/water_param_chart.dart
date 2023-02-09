import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:provider/provider.dart';

class WaterParamChart extends StatefulWidget {
  final String title;
  final List<dynamic> dataSource;

  const WaterParamChart({
    required this.title,
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
      title: ChartTitle(text: widget.title),
      primaryXAxis: DateTimeAxis(),
      series: <ChartSeries>[
        LineSeries(
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
