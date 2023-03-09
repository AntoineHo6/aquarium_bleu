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
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final firestoreProvider = Provider.of<CloudFirestoreProvider>(context);

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

    return FutureBuilder(
      future: firestoreProvider.readParamVisPrefs(widget.tank.docId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Widget> test = [
            for (String param in Strings.params)
              Text('${param}  ${snapshot.data![param].toString()}')
          ];

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
            body: ListView(children: test),
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
          print('shit');
          return Container();
        }
      },
    );
  }
}
