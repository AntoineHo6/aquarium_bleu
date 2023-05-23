import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/wcnp/edit_param_page.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:flutter/material.dart';

class WaterParamChartPage extends StatefulWidget {
  final String tankId;
  final WaterParamType paramType;
  final DateTime start;
  final DateTime end;
  final List<WaterChange> waterChanges;

  const WaterParamChartPage(this.tankId, this.paramType, this.start, this.end, this.waterChanges,
      {super.key});

  @override
  State<WaterParamChartPage> createState() => _WaterParamChartPageState();
}

class _WaterParamChartPageState extends State<WaterParamChartPage> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Parameter>>(
        stream: FirestoreStuff.readParamWithRange(
            widget.tankId, widget.paramType, widget.start, widget.end),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    WaterParamChart(
                      paramType: widget.paramType,
                      dataSource: snapshot.data!,
                      waterChanges: widget.waterChanges,
                    ),
                    Column(
                      children: _dataPointsTiles(snapshot.data!),
                    ),
                    // Column(
                    //   children: _waterChangeTiles(),
                    // ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }

  List<Widget> _dataPointsTiles(List<Parameter> data) {
    List<Widget> dataPointsTiles = [];

    for (Parameter dataPoint in data) {
      dataPointsTiles.add(ListTile(
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
                    builder: (context) => EditWaterParamPage(widget.tankId, dataPoint),
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ],
        ),
      ));
    }

    return dataPointsTiles;
  }
}
