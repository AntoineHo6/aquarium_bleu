import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param/tune_chart_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/widgets/water_param/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class WaterParamPage extends StatefulWidget {
  final Tank tank;

  const WaterParamPage(this.tank, {super.key});

  @override
  State<WaterParamPage> createState() => _WaterParamPageState();
}

class _WaterParamPageState extends State<WaterParamPage> {
  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<CloudFirestoreProvider>(context);

    // First futureBuilder for fetching parameter visibility
    return FutureBuilder(
      future: firestoreProvider.readParamVisPrefs(widget.tank.docId),
      builder: (context, paramVisSnapshot) {
        if (paramVisSnapshot.hasData) {
          List<Future<List<Parameter>>> futures = [];
          List<String> visibleParams = [];

          // indexes of the lists "futures" and "visibleParams" are corresponding
          for (String param in Strings.params) {
            if (paramVisSnapshot.data![param]) {
              futures.add(
                firestoreProvider.newReadParameters(widget.tank.docId, param),
              );
              visibleParams.add(param);
            }
          }

          // Second futureBuilder for fetching data from visible parameters
          return FutureBuilder(
              future: Future.wait(futures),
              builder: (context, snapshots2) {
                if (snapshots2.hasData) {
                  List<WaterParamChart> charts = [];

                  // create and add chart widgets to list
                  for (var i = 0; i < snapshots2.data!.length; i++) {
                    if (snapshots2.data![i].isNotEmpty) {
                      charts.add(
                        WaterParamChart(
                          param: visibleParams[i],
                          dataSource: snapshots2.data![i],
                        ),
                      );
                    }
                  }

                  return Scaffold(
                    appBar: AppBar(
                      title: Text(AppLocalizations.of(context).waterParameters),
                      actions: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TuneChartPage(
                                  widget.tank.docId,
                                  paramVisSnapshot.data!,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.tune_rounded),
                        )
                      ],
                    ),
                    body: ListView(children: charts),
                    floatingActionButton: FloatingActionButton(
                      onPressed: () => showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AddParamValAlertDialog(
                          widget.tank.docId,
                          visibleParams,
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  );
                } else {
                  return Container();
                }
              });
        } else {
          return Container();
        }
      },
    );
  }
}
