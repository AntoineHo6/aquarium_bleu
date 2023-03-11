import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param/tune_chart_page.dart';
import 'package:aquarium_bleu/pages/water_param/water_param_chart_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/widgets/water_param/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

    // First futureBuilder for fetching prefs
    return FutureBuilder(
      future: Future.wait([
        firestoreProvider.readDateRangePrefs(widget.tank.docId),
        firestoreProvider.readParamVisPrefs(widget.tank.docId),
      ]),
      builder: (context, prefsSnapshot) {
        if (prefsSnapshot.hasData) {
          List<Future<List<Parameter>>> paramDataFutures = [];
          List<String> visibleParams = [];
          DateTime start;
          DateTime end;

          if (prefsSnapshot.data![0][Strings.type] != Strings.all) {
            start = _calculateDateStart(
              prefsSnapshot.data![0][Strings.type],
              prefsSnapshot.data![0][Strings.customDateStart] as Timestamp,
            );
            end = _calculateDateEnd(
              prefsSnapshot.data![0][Strings.type],
              prefsSnapshot.data![0][Strings.customDateEnd] as Timestamp,
            );

            for (String param in Strings.params) {
              if (prefsSnapshot.data![1][param]) {
                paramDataFutures.add(
                  firestoreProvider.readParametersWithRange(widget.tank.docId, param, start, end),
                );
                visibleParams.add(param);
              }
            }
          } else {
            for (String param in Strings.params) {
              if (prefsSnapshot.data![1][param]) {
                paramDataFutures.add(
                  firestoreProvider.readParameters(widget.tank.docId, param),
                );
                visibleParams.add(param);
              }
            }
          }

          print(visibleParams);

          // Second futureBuilder for fetching data from visible parameters
          return FutureBuilder(
              future: Future.wait(paramDataFutures),
              builder: (context, snapshots2) {
                if (snapshots2.hasData) {
                  List<WaterParamChart> charts =
                      _createWaterParamCharts(snapshots2.data!, visibleParams);

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
                                  prefsSnapshot.data![0][Strings.type],
                                  (prefsSnapshot.data![0][Strings.customDateStart] as Timestamp)
                                      .toDate(),
                                  (prefsSnapshot.data![0][Strings.customDateEnd] as Timestamp)
                                      .toDate(),
                                  prefsSnapshot.data![1],
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
                        builder: (BuildContext context) => AddParamValAlertDialog(
                          widget.tank.docId,
                          visibleParams,
                        ),
                      ),
                      child: const Icon(Icons.add),
                    ),
                  );
                } else {
                  return const CircularProgressIndicator.adaptive();
                }
              });
        } else {
          return const CircularProgressIndicator.adaptive();
        }
      },
    );
  }

  DateTime _calculateDateStart(String type, Timestamp customDateStart) {
    switch (type) {
      case Strings.months1:
        return DateTime.now().subtract(const Duration(days: 31));
      case Strings.months2:
        return DateTime.now().subtract(const Duration(days: 62));
      case Strings.months3:
        return DateTime.now().subtract(const Duration(days: 93));
      case Strings.months6:
        return DateTime.now().subtract(const Duration(days: 186));
      case Strings.months9:
        return DateTime.now().subtract(const Duration(days: 279));
      case Strings.custom:
        return customDateStart.toDate();
      default:
        return DateTime.now();
    }
  }

  DateTime _calculateDateEnd(String type, Timestamp customDateEnd) {
    if (type == Strings.custom) {
      return customDateEnd.toDate();
    }

    return DateTime.now();
  }

  List<WaterParamChart> _createWaterParamCharts(
      List<List<Parameter>> allParamData, List<String> visibleParams) {
    List<WaterParamChart> charts = [];
    for (var i = 0; i < allParamData.length; i++) {
      if (allParamData[i].isNotEmpty) {
        charts.add(
          WaterParamChart(
            param: visibleParams[i],
            dataSource: allParamData[i],
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaterParamChartPage(
                        widget.tank.docId,
                        visibleParams[i],
                        allParamData[i],
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.open_in_new_rounded),
              ),
            ],
          ),
        );
      }
    }

    return charts;
  }
}
