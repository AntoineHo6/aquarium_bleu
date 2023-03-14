import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/pages/water_param/tune_chart_page.dart';
import 'package:aquarium_bleu/pages/water_param/water_param_chart_page.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/water_param/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rxdart/rxdart.dart';

class WaterParamPage extends StatefulWidget {
  final String tankId;

  const WaterParamPage(this.tankId, {super.key});

  @override
  State<WaterParamPage> createState() => _WaterParamPageState();
}

class _WaterParamPageState extends State<WaterParamPage> {
  @override
  Widget build(BuildContext context) {
    List<Stream<DocumentSnapshot<Map<String, dynamic>>>> prefsStreams = [];

    prefsStreams.add(FirestoreStuff.readParamVisPrefs(widget.tankId));
    prefsStreams.add(FirestoreStuff.readDateRangePrefs(widget.tankId));

    return StreamBuilder(
      stream: CombineLatestStream.list(prefsStreams),
      builder: (context, prefsSnapshots) {
        if (prefsSnapshots.hasData) {
          Map<String, dynamic>? paramVisibility = prefsSnapshots.data![0].data();
          // List<String> visibleParams = [];

          // for (String param in Strings.params) {
          //   if (prefsSnapshots.data![0].data()![param]) {
          //     visibleParams.add(param);
          //   }
          // }

          String dateRangeType = prefsSnapshots.data![1][Strings.type];

          DateTime start = _calculateDateStart(
            dateRangeType,
            (prefsSnapshots.data![1][Strings.customDateStart] as Timestamp),
          );
          DateTime end = _calculateDateEnd(
            dateRangeType,
            (prefsSnapshots.data![1][Strings.customDateEnd] as Timestamp),
          );

          List<Stream<List<Parameter>>> dataStreams = [];
          if (prefsSnapshots.data![1][Strings.type] != Strings.all) {
            for (var type in WaterParamType.values) {
              if (paramVisibility![type.getStr]) {
                dataStreams.add(
                  FirestoreStuff.readParametersWithRange(
                    widget.tankId,
                    type,
                    start,
                    end,
                  ),
                );
              }
            }
          } else {
            for (var type in WaterParamType.values) {
              if (prefsSnapshots.data![0][type.getStr]) {
                dataStreams.add(
                  FirestoreStuff.readParameters(widget.tankId, type),
                );
              }
            }
          }

          // add condition if no param is visible. Return a different body with a message

          return StreamBuilder(
            stream: CombineLatestStream.list(dataStreams),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Widget> charts = _createWaterParamCharts(snapshot.data!);

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
                                widget.tankId,
                                prefsSnapshots.data![1][Strings.type],
                                start,
                                end,
                                paramVisibility,
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
                        widget.tankId,
                        paramVisibility,
                      ),
                    ),
                    child: const Icon(Icons.add),
                  ),
                );
              } else {
                return const CircularProgressIndicator.adaptive();
              }
            },
          );
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

  List<Widget> _createWaterParamCharts(List<List<Parameter>> allParamData) {
    List<Widget> charts = [];
    for (var i = 0; i < allParamData.length; i++) {
      if (allParamData[i].isNotEmpty) {
        charts.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
            child: WaterParamChart(
              param: allParamData[i][0].type.getStr,
              dataSource: allParamData[i],
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WaterParamChartPage(
                          widget.tankId,
                          allParamData[i][0].type,
                          allParamData[i],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                ),
              ],
            ),
          ),
        );
      }
    }

    return charts;
  }
}
