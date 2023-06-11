import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/wcnp/edit_wc_page.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_tune_page.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_chart_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/wcnp_page/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/wcnp_page/add_water_change_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/wcnp_page/param_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class WcnpPage extends StatefulWidget {
  const WcnpPage({super.key});

  @override
  State<WcnpPage> createState() => _WcnpPageState();
}

class _WcnpPageState extends State<WcnpPage> {
  @override
  Widget build(BuildContext context) {
    List<Stream<DocumentSnapshot<Map<String, dynamic>>>> prefsStreams = [];

    String tankId = Provider.of<TankProvider>(context, listen: false).tank.docId;
    prefsStreams.add(FirestoreStuff.readParamVis(tankId));
    prefsStreams.add(FirestoreStuff.readDateRangeWcnpPrefs(tankId));
    prefsStreams.add(FirestoreStuff.readShowWaterChanges(tankId));

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

          DateTime dateStart = _calculateDateStart(
            dateRangeType,
            customDateStart,
          );
          DateTime dateEnd = _calculateDateEnd(
            dateRangeType,
            customDateEnd,
          );

          for (var type in WaterParamType.values) {
            if (paramVisibility![type.getStr]) {
              dataStreams.add(
                FirestoreStuff.readParamWithRange(tankId, type, dateStart, dateEnd),
              );
            }
          }

          bool showWaterChanges = (prefsSnapshots.data![2]['value']);

          return StreamBuilder(
              stream: FirestoreStuff.readWcWithRange(tankId, dateStart, dateEnd),
              builder: (context, wcSnapshot) {
                if (wcSnapshot.hasData) {
                  return StreamBuilder(
                    stream: CombineLatestStream.list(dataStreams),
                    builder: (context, paramSnapshot) {
                      if (paramSnapshot.hasData) {
                        String dateRangeTypeStr =
                            StringUtil.dateRangeTypeToString(context, dateRangeType);

                        List<Widget> charts = _createParamCharts(
                          paramSnapshot.data!,
                          wcSnapshot.data!,
                          showWaterChanges,
                          dateStart,
                          dateEnd,
                          tankId,
                        );

                        List<Widget> wcListTiles = _createWcListTiles(wcSnapshot.data!);

                        return DefaultTabController(
                          length: 2,
                          child: Scaffold(
                              appBar: AppBar(
                                title: Text(
                                    '${AppLocalizations.of(context).dateRange}: $dateRangeTypeStr'),
                                actions: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => WcnpTunePage(
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
                                  ListView(children: [
                                    Column(
                                      children: charts,
                                    ),
                                  ]),
                                  Padding(
                                    padding: const EdgeInsets.all(Spacing.screenEdgePadding),
                                    child: ListView(children: wcListTiles),
                                  ),
                                ],
                              ),
                              floatingActionButton: SpeedDial(
                                icon: Icons.add,
                                children: [
                                  SpeedDialChild(
                                    child: const Icon(Icons.show_chart_outlined),
                                    label: AppLocalizations.of(context).addParameterValue,
                                    backgroundColor: MyTheme.paramColor,
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) => AddParamValAlertDialog(
                                        paramVisibility,
                                      ),
                                    ),
                                  ),
                                  SpeedDialChild(
                                    child: const Icon(Icons.water_drop),
                                    label: AppLocalizations.of(context).addWaterChange,
                                    backgroundColor: MyTheme.wcColor,
                                    onTap: () => showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AddWaterChangeAlertDialog(tankId),
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

  List<Widget> _createParamCharts(
      List<List<Parameter>> allParamData,
      List<WaterChange> waterChanges,
      bool showWaterChanges,
      DateTime dateStart,
      DateTime dateEnd,
      String tankId) {
    List<Widget> charts = [];
    for (var i = 0; i < allParamData.length; i++) {
      if (allParamData[i].isNotEmpty) {
        charts.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
            child: ParamChart(
              paramType: allParamData[i][0].type,
              dataSource: allParamData[i],
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WcnpChartPage(
                          tankId,
                          allParamData[i][0].type,
                          dateStart,
                          dateEnd,
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
        .map((wc) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditWcPage(wc),
                  ),
                ),
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: StringUtil.formattedDate(context, wc.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyTheme.wcColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // title: Text(
                  //   StringUtil.formattedDate(context, wc.date),
                  // ),
                  subtitle: Text(
                    StringUtil.formattedTime(
                      context,
                      TimeOfDay.fromDateTime(wc.date),
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }
}

// TODO: make sure charts also show water change bars in range
