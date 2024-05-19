import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/param/param_tune_page.dart';
import 'package:aquarium_bleu/pages/param/param_chart_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/wcnp_page/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/wcnp_page/param_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class ParamPage extends StatefulWidget {
  const ParamPage({super.key});

  @override
  State<ParamPage> createState() => ParamPageState();
}

class ParamPageState extends State<ParamPage> {
  @override
  Widget build(BuildContext context) {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    DateTime dateStart = _calculateDateStart(
      tankProvider.tank.dateRangeType,
      tankProvider.tank.customDateStart,
    );
    DateTime dateEnd = _calculateDateEnd(
      tankProvider.tank.dateRangeType,
      tankProvider.tank.customDateEnd,
    );

    List<Stream<List<Parameter>>> dataStreams = [];

    for (var paramType in WaterParamType.values) {
      if (tankProvider.tank.visibleParams[paramType.getStr]) {
        dataStreams.add(
          FirestoreStuff.readParamWithRange(tankProvider.tank.docId, paramType, dateStart, dateEnd),
        );
      }
    }

    return StreamBuilder(
        stream: FirestoreStuff.readWcWithRange(tankProvider.tank.docId, dateStart, dateEnd),
        builder: (context, wcSnapshot) {
          if (wcSnapshot.hasData) {
            return StreamBuilder(
              stream: CombineLatestStream.list(dataStreams),
              builder: (context, paramSnapshot) {
                if (paramSnapshot.hasData) {
                  List<Widget> charts = _createParamCharts(
                    paramSnapshot.data!,
                    wcSnapshot.data!,
                    dateStart,
                    dateEnd,
                  );

                  return Scaffold(
                      appBar: AppBar(
                        title: Text(
                          AppLocalizations.of(context)!.waterParameters,
                        ),
                        actions: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ParamTunePage(),
                                ),
                              ).then((value) => setState(() {}));
                            },
                            icon: const Icon(Icons.tune_rounded),
                          )
                        ],
                      ),
                      body: ListView(children: [
                        Column(
                          children: charts,
                        ),
                      ]),
                      floatingActionButton: FloatingActionButton(
                        child: const Icon(Icons.add),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (BuildContext context) => AddParamValAlertDialog(
                            tankProvider.tank.visibleParams,
                          ),
                        ),
                      ));
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

  List<Widget> _createParamCharts(List<List<Parameter>> allParamData,
      List<WaterChange> waterChanges, DateTime dateStart, DateTime dateEnd) {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);
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
                        builder: (context) => ParamChartPage(
                          allParamData[i][0].type,
                          dateStart,
                          dateEnd,
                          tankProvider.tank.showWcInCharts ? waterChanges : [],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                ),
              ],
              waterChanges: tankProvider.tank.showWcInCharts ? waterChanges : [],
            ),
          ),
        );
      }
    }

    return charts;
  }
}
