import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/param/edit_param_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/param/param_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ParamChartPage extends StatefulWidget {
  final WaterParamType paramType;
  final DateTime start;
  final DateTime end;
  final List<WaterChange> waterChanges;

  const ParamChartPage(this.paramType, this.start, this.end, this.waterChanges, {super.key});

  @override
  State<ParamChartPage> createState() => _ParamChartPageState();
}

class _ParamChartPageState extends State<ParamChartPage> {
  @override
  Widget build(BuildContext context) {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    return StreamBuilder<List<Parameter>>(
        stream: FirestoreStuff.readParamWithRange(
            tankProvider.tank.docId, widget.paramType, widget.start, widget.end),
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
                      const SizedBox(
                        height: Spacing.betweenSections,
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
      dataPointsTiles.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: FilledButton.tonal(
            style: ButtonStyle(
              shape: WidgetStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
            ),
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
                  RichText(
                    text: TextSpan(
                      text: dataPoint.value.toString(),
                      style: const TextStyle(
                        color: MyTheme.paramColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return dataPointsTiles;
  }
}
