import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:flutter/material.dart';

class WaterParamChartPage extends StatefulWidget {
  final String tankId;
  final String param;
  final List<Parameter> dataSource;

  const WaterParamChartPage(this.tankId, this.param, this.dataSource,
      {super.key});

  @override
  State<WaterParamChartPage> createState() => _WaterParamChartPageState();
}

class _WaterParamChartPageState extends State<WaterParamChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            WaterParamChart(
              param: widget.param,
              dataSource: widget.dataSource,
            ),
            Column(
              children: widget.dataSource
                  .map((Parameter dataPoint) => ListTile(
                        title: Text(
                          StringUtil.formattedDate(context, dataPoint.date),
                        ),
                        subtitle: Text('time'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(dataPoint.value.toString()),
                            const Icon(Icons.edit),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
