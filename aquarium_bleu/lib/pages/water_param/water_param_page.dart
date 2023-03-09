import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param/tune_chart_page.dart';
import 'package:aquarium_bleu/pages/water_param/water_param_chart_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/widgets/water_param/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

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

    return FutureBuilder(
      future: firestoreProvider.readParamVisPrefs(widget.tank.docId),
      builder: (context, snapshot1) {
        if (snapshot1.hasData) {
          List<Future<List<dynamic>>> futures = [];
          List<String> visibleParams = [];

          for (String param in Strings.params) {
            if (snapshot1.data![param]) {
              futures.add(
                firestoreProvider.newReadParameters(widget.tank.docId, param),
              );
              visibleParams.add(param);
            }
          }

          return FutureBuilder(
              future: Future.wait(futures),
              builder: (context, snapshots2) {
                if (snapshots2.hasData) {
                  List<WaterParamChart> charts = [];
                  for (var i = 0; i < snapshots2.data!.length; i++) {
                    List<Parameter> dataPoints = [];
                    for (var j = 0; j < snapshots2.data![i].length; j++) {
                      dataPoints.add(
                          Parameter.fromJson(snapshots2.data![i][j].data()));
                    }
                    if (dataPoints.isNotEmpty) {
                      charts.add(
                        WaterParamChart(
                            param: visibleParams[i], dataSource: dataPoints),
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
                                builder: (context) => const TuneChartPage(),
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
                            AddParamValAlertDialog(widget.tank.docId),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  );
                } else {
                  print('crap');
                  return Container();
                }
              });
        } else {
          print('shit');
          return Container();
        }
      },
    );
  }
}
