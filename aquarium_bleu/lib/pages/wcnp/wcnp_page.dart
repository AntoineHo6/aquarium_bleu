import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_tune_page.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_chart_page.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/water_param/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param/add_water_change_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:rxdart/rxdart.dart';

class WcnpPage extends StatefulWidget {
  final String tankId;

  const WcnpPage(this.tankId, {super.key});

  @override
  State<WcnpPage> createState() => _WcnpPageState();
}

class _WcnpPageState extends State<WcnpPage> {
  @override
  Widget build(BuildContext context) {
    List<Stream<DocumentSnapshot<Map<String, dynamic>>>> prefsStreams = [];

    prefsStreams.add(FirestoreStuff.readParamVis(widget.tankId));
    prefsStreams.add(FirestoreStuff.readDateRangeWcnpPrefs(widget.tankId));
    prefsStreams.add(FirestoreStuff.readShowWaterChanges(widget.tankId));

    return StreamBuilder(
      stream: CombineLatestStream.list(prefsStreams),
      builder: (context, prefsSnapshots) {
        if (prefsSnapshots.hasData) {
          Map<String, dynamic>? paramVisibility = prefsSnapshots.data![0].data();

          DateRangeType dateRangeType =
              DateRangeType.values.byName(prefsSnapshots.data![1][Strings.type]);

          // should only convert to date if actually in custom date range type
          DateTime customDateStart =
              (prefsSnapshots.data![1][Strings.customDateStart] as Timestamp).toDate();
          DateTime customDateEnd =
              (prefsSnapshots.data![1][Strings.customDateEnd] as Timestamp).toDate();

          List<Stream<List<Parameter>>> dataStreams = [];

          DateTime start = _calculateDateStart(
            dateRangeType,
            customDateStart,
          );
          DateTime end = _calculateDateEnd(
            dateRangeType,
            customDateEnd,
          );

          for (var type in WaterParamType.values) {
            if (paramVisibility![type.getStr]) {
              dataStreams.add(
                FirestoreStuff.readParamWithRange(widget.tankId, type, start, end),
              );
            }
          }

          bool showWaterChanges = (prefsSnapshots.data![2]['value']);

          return StreamBuilder(
              stream: FirestoreStuff.readWaterChangesWithRange(widget.tankId, start, end),
              builder: (context, waterChangeSnapshot) {
                if (waterChangeSnapshot.hasData) {
                  return StreamBuilder(
                    stream: CombineLatestStream.list(dataStreams),
                    builder: (context, paramSnapshot) {
                      if (paramSnapshot.hasData) {
                        List<Widget> charts = _createWaterParamCharts(
                          paramSnapshot.data!,
                          waterChangeSnapshot.data!,
                          showWaterChanges,
                          start,
                          end,
                        );

                        List<Widget> wcListTiles = _createWcListTiles(waterChangeSnapshot.data!);

                        if (charts.isEmpty && waterChangeSnapshot.data!.isNotEmpty) {}

                        return DefaultTabController(
                          length: 2,
                          child: Scaffold(
                              appBar: AppBar(
                                // title: Text(AppLocalizations.of(context).waterChangesAndParameters),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WcnpTunePage(
                                            widget.tankId,
                                            DateRangeType.values
                                                .byName(prefsSnapshots.data![1][Strings.type]),
                                            customDateStart,
                                            customDateEnd,
                                            paramVisibility,
                                            showWaterChanges,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.tune_rounded),
                                  )
                                ],
                                bottom: TabBar(
                                  tabs: [
                                    Tab(
                                      icon: const Icon(Icons.show_chart),
                                      text: AppLocalizations.of(context).waterParameters,
                                    ),
                                    Tab(
                                      icon: const Icon(Icons.water_drop),
                                      text: AppLocalizations.of(context).waterChanges,
                                    ),
                                  ],
                                ),
                              ),
                              body: TabBarView(
                                children: [
                                  ListView(children: charts),
                                  ListView(children: wcListTiles),
                                ],
                              ),
                              floatingActionButton: SpeedDial(
                                icon: Icons.add,
                                children: [
                                  SpeedDialChild(
                                    child: const Icon(Icons.show_chart_outlined),
                                    label: AppLocalizations.of(context).addParameterValue,
                                    backgroundColor: Colors.orange,
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AddParamValAlertDialog(
                                        widget.tankId,
                                        paramVisibility,
                                      ),
                                    ),
                                  ),
                                  SpeedDialChild(
                                    child: const Icon(Icons.water_drop),
                                    label: AppLocalizations.of(context).addWaterChange,
                                    backgroundColor: Colors.lightBlue,
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AddWaterChangeAlertDialog(widget.tankId),
                                    ),
                                  ),
                                ],
                              )),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
              });
        } else {
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        }
      },
    );
  }

  DateTime _calculateDateStart(DateRangeType type, DateTime customDateStart) {
    switch (type) {
      case DateRangeType.months1:
        return DateTime.now().subtract(const Duration(days: 31));
      case DateRangeType.months2:
        return DateTime.now().subtract(const Duration(days: 62));
      case DateRangeType.months3:
        return DateTime.now().subtract(const Duration(days: 93));
      case DateRangeType.months6:
        return DateTime.now().subtract(const Duration(days: 186));
      case DateRangeType.months9:
        return DateTime.now().subtract(const Duration(days: 279));
      case DateRangeType.all:
        return DateTime(2000);
      case DateRangeType.custom:
        return customDateStart;
      default:
        return DateTime.now();
    }
  }

  DateTime _calculateDateEnd(DateRangeType type, DateTime customDateEnd) {
    switch (type) {
      case DateRangeType.all:
        return DateTime(2100);
      case DateRangeType.custom:
        return customDateEnd;
      default:
        return DateTime.now();
    }
  }

  List<Widget> _createWaterParamCharts(List<List<Parameter>> allParamData,
      List<WaterChange> waterChanges, bool showWaterChanges, DateTime start, DateTime end) {
    List<Widget> charts = [];
    for (var i = 0; i < allParamData.length; i++) {
      if (allParamData[i].isNotEmpty) {
        charts.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
            child: WaterParamChart(
              paramType: allParamData[i][0].type,
              dataSource: allParamData[i],
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WcnpChartPage(
                          widget.tankId,
                          allParamData[i][0].type,
                          start,
                          end,
                          showWaterChanges ? waterChanges : [],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                ),
              ],
              waterChanges: showWaterChanges ? waterChanges : [],
            ),
          ),
        );
      }
    }

    return charts;
  }

  List<Widget> _createWcListTiles(List<WaterChange> waterChanges) {
    return waterChanges
        .map((wc) => ListTile(
              title: Text(
                StringUtil.formattedDate(context, wc.date),
              ),
              subtitle: Text(
                StringUtil.formattedTime(
                  context,
                  TimeOfDay.fromDateTime(wc.date),
                ),
              ),
            ))
        .toList();
  }
}

// TODO: make sure charts also show water change bars in range