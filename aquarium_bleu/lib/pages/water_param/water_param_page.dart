import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param/tune_chart_page.dart';
import 'package:aquarium_bleu/pages/water_param/water_param_chart_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/widgets/water_param/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param/water_param_chart.dart';
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
    final settingsProvider = Provider.of<SettingsProvider>(context);

    List<String> params = [];
    // List of param data streams
    List<Stream<List<Parameter>>> dataStreams = [];
    settingsProvider.visibleParams.forEach((param, isVisible) {
      if (isVisible) {
        params.add(param);
        dataStreams.add(
          context
              .watch<CloudFirestoreProvider>()
              .readParameters(widget.tank.docId, param),
        );
      }
    });

    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list(dataStreams),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<Widget> charts = [];

          // create all charts
          for (var i = 0; i < snapshot.data!.length; i++) {
            if (snapshot.data![i].isNotEmpty) {
              charts.add(
                WaterParamChart(
                  param: params[i],
                  dataSource: snapshot.data![i],
                  actions: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WaterParamChartPage(
                              widget.tank.docId,
                              params[i],
                              snapshot.data![i],
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
          return Container();
        }
      },
    );
  }
}
