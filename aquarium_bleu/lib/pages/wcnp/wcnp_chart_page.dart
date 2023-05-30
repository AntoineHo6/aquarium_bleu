import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/wcnp/edit_param_page.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/water_param/param_chart.dart';
import 'package:flutter/material.dart';

class WcnpChartPage extends StatefulWidget {
  final String tankId;
  final WaterParamType paramType;
  final DateTime start;
  final DateTime end;
  final List<WaterChange> waterChanges;

  const WcnpChartPage(this.tankId, this.paramType, this.start, this.end, this.waterChanges,
      {super.key});

  @override
  State<WcnpChartPage> createState() => _WcnpChartPageState();
}

class _WcnpChartPageState extends State<WcnpChartPage> {
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
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.screenEdgePadding),
                  child: Column(
                    children: [
                      ParamChart(
                        paramType: widget.paramType,
                        dataSource: snapshot.data!,
                        waterChanges: widget.waterChanges,
                      ),
                      Column(
                        children: _dataPointsTiles(snapshot.data!),
                      ),
                    ],
                  ),
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
      dataPointsTiles.add(Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ))),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditParamPage(dataPoint),
              ),
            );
          },
          child: ListTile(
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
                Text(
                  dataPoint.value.toString(),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ],
            ),
          ),
        ),
      ));
    }

    return dataPointsTiles;
  }
}
