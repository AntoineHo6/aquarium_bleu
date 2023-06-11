import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParamChart extends StatefulWidget {
  final WaterParamType paramType;
  final List<dynamic> dataSource;
  final List<Widget> actions;
  final List<WaterChange> waterChanges;

  const ParamChart({
    required this.paramType,
    this.dataSource = const [],
    this.actions = const [],
    this.waterChanges = const [],
    super.key,
  });

  @override
  State<ParamChart> createState() => _ParamChartState();
}

class _ParamChartState extends State<ParamChart> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  StringUtil.paramTypeToString(context, widget.paramType),
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: widget.actions,
                ),
              ),
            ],
          ),
        ),
        SfCartesianChart(
          tooltipBehavior: TooltipBehavior(
              enable: true, header: AppLocalizations.of(context).date, format: 'point.x'),
          primaryXAxis: DateTimeAxis(
            plotBands: widget.waterChanges
                .map(
                  (wc) => PlotBand(
                    start: wc.date,
                    end: wc.date,
                    shouldRenderAboveSeries: true,
                    borderWidth: 1.5,
                    borderColor: MyTheme.wcColor,
                  ),
                )
                .toList(),
          ),
          series: <ChartSeries>[
            LineSeries(
              color: MyTheme.paramColor,
              animationDuration: 800,
              dataSource: widget.dataSource,
              xValueMapper: (dataPoint, _) => dataPoint.date,
              yValueMapper: (dataPoint, _) => dataPoint.value,
              dataLabelSettings: const DataLabelSettings(isVisible: true),
              markerSettings: const MarkerSettings(isVisible: true),
            )
          ],
        ),
      ],
    );
  }
}
