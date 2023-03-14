import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/pages/water_param/edit_water_param_page.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:flutter/material.dart';

class WaterParamChartPage extends StatefulWidget {
  final String tankId;
  final WaterParamType param;
  final List<Parameter> dataSource;

  const WaterParamChartPage(this.tankId, this.param, this.dataSource, {super.key});

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
              param: widget.param.getStr,
              dataSource: widget.dataSource,
            ),
            Column(
              children: widget.dataSource
                  .map((Parameter dataPoint) => ListTile(
                        title: Text(
                          StringUtil.formattedDate(context, dataPoint.date),
                        ),
                        subtitle: Text(
                          StringUtil.formattedTime(
                            context,
                            TimeOfDay.fromDateTime(dataPoint.date),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(dataPoint.value.toString()),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditWaterParamPage(dataPoint),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.edit),
                            ),
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
