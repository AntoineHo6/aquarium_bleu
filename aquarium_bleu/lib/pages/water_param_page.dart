import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/widgets/water_param_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import '../models/parameter.dart';

class WaterParamPage extends StatefulWidget {
  final Tank tank;

  const WaterParamPage(this.tank, {super.key});

  @override
  State<WaterParamPage> createState() => _WaterParamPageState();
}

class _WaterParamPageState extends State<WaterParamPage> {
  List<String> paramCollectionsNames = [
    Strings.ammoniaCollection,
    Strings.nitriteCollection,
    Strings.nitrateCollection,
    Strings.tdsCollection,
    Strings.phCollection
  ];

  @override
  Widget build(BuildContext context) {
    List<Stream<List<Parameter>>> dataStreams = [
      for (var paramCollection in paramCollectionsNames)
        context
            .watch<CloudFirestoreProvider>()
            .readParameters(widget.tank.docId, paramCollection)
    ];

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
              actions: [
                IconButton(
                  onPressed: () => null,
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            body: ListView(
              children: [
                if (ammoniaData.isNotEmpty)
                  WaterParamChart(
                    title: AppLocalizations.of(context).ammonia,
                    dataSource: ammoniaData,
                  ),
                if (nitriteData.isNotEmpty)
                  WaterParamChart(
                    title: AppLocalizations.of(context).nitrite,
                    dataSource: nitriteData,
                  ),
                if (nitrateData.isNotEmpty)
                  WaterParamChart(
                    title: AppLocalizations.of(context).nitrate,
                    dataSource: nitrateData,
                  ),
                if (tdsData.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 15.0, right: 15.0),
                    child: WaterParamChart(
                      title: AppLocalizations.of(context).tds,
                      dataSource: tdsData,
                    ),
                  ),
                if (phData.isNotEmpty)
                  WaterParamChart(
                    title: AppLocalizations.of(context).ph,
                    dataSource: phData,
                  ),
              ],
            ),
          );
        } else {
          return Container();
        }
      },
    );
  }
}
