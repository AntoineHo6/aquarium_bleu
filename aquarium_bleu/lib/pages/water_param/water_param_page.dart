import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param/add_water_param_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/widgets/add_param_val_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/water_param_chart.dart';
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
  List<String> paramCollNames = [
    Strings.ammonia,
    Strings.nitrite,
    Strings.nitrate,
    Strings.tds,
    Strings.ph,
    Strings.kh,
    Strings.gh,
    Strings.temp
  ];

  @override
  Widget build(BuildContext context) {
    // List of param data streams
    List<Stream<List<Parameter>>> dataStreams = [
      for (var paramCollectionName in paramCollNames)
        context
            .watch<CloudFirestoreProvider>()
            .readParameters(widget.tank.docId, paramCollectionName)
    ];

    final settingsProvider = Provider.of<SettingsProvider>(context);

    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list(dataStreams),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<WaterParamChart> charts = [];
          final Map visibleParams = settingsProvider.getVisibleParams();

          for (var i = 0; i < paramCollNames.length; i++) {
            String param = paramCollNames[i];
            if (snapshot.data![i].isNotEmpty && visibleParams[param]) {
              charts.add(
                WaterParamChart(title: param, dataSource: snapshot.data![i]),
              );
            }
          }

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).waterParameters),
            ),
            body: ListView(children: charts),
            floatingActionButton: FloatingActionButton(
              // onPressed: () => showDialog(
              //   context: context,
              //   builder: (BuildContext context) => const AddWaterParamPage(),
              // ),
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) =>
                    const AddParamValAlertDialog(),
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
