import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param/add_water_param_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/strings.dart';
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
  List<String> paramCollectionsNames = [
    Strings.ammonia,
    Strings.nitrite,
    Strings.nitrate,
    Strings.tds,
    Strings.ph
  ];

  @override
  Widget build(BuildContext context) {
    List<Stream<List<Parameter>>> dataStreams = [
      for (var paramCollectionName in paramCollectionsNames)
        context
            .watch<CloudFirestoreProvider>()
            .readParameters(widget.tank.docId, paramCollectionName)
    ];

    final settingsProvider = Provider.of<SettingsProvider>(context);

    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list(dataStreams),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<Parameter> ammoniaData = snapshot.data![0];
          final List<Parameter> nitriteData = snapshot.data![1];
          final List<Parameter> nitrateData = snapshot.data![2];
          final List<Parameter> tdsData = snapshot.data![3];
          final List<Parameter> phData = snapshot.data![4];

          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).waterParameters),
            ),
            body: ListView(
              children: [
                if (ammoniaData.isNotEmpty &&
                    settingsProvider.getVisibleParameters()[Strings.ammonia])
                  WaterParamChart(
                    title: AppLocalizations.of(context).ammonia,
                    dataSource: ammoniaData,
                  ),
                if (nitriteData.isNotEmpty &&
                    settingsProvider.getVisibleParameters()[Strings.nitrite])
                  WaterParamChart(
                    title: AppLocalizations.of(context).nitrite,
                    dataSource: nitriteData,
                  ),
                if (nitrateData.isNotEmpty &&
                    settingsProvider.getVisibleParameters()[Strings.nitrate])
                  WaterParamChart(
                    title: AppLocalizations.of(context).nitrate,
                    dataSource: nitrateData,
                  ),
                if (tdsData.isNotEmpty &&
                    settingsProvider.getVisibleParameters()[Strings.tds])
                  Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: WaterParamChart(
                      title: AppLocalizations.of(context).tds,
                      dataSource: tdsData,
                    ),
                  ),
                if (phData.isNotEmpty &&
                    settingsProvider.getVisibleParameters()[Strings.ph])
                  WaterParamChart(
                    title: AppLocalizations.of(context).ph,
                    dataSource: phData,
                  ),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => const AddWaterParamPage(),
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
