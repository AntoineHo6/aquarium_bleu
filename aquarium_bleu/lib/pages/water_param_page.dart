import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:async/async.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../models/nitrate.dart';

class WaterParamPage extends StatefulWidget {
  final Tank tank;

  const WaterParamPage(this.tank, {super.key});

  @override
  State<WaterParamPage> createState() => _WaterParamPageState();
}

class _WaterParamPageState extends State<WaterParamPage> {
  late Stream<List<Nitrate>> _nitrateStream;

  @override
  Widget build(BuildContext context) {
    _nitrateStream = context
        .watch<CloudFirestoreProvider>()
        .readParameters(widget.tank.docId, 'nitrates');

    return StreamBuilder<List<dynamic>>(
      stream: CombineLatestStream.list([
        _nitrateStream,
      ]),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final nitrates = snapshot.data![0];
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
            body: Column(
              children: [
                SfCartesianChart(
                  primaryXAxis: DateTimeAxis(),
                  series: <ChartSeries>[
                    LineSeries(
                      dataSource: nitrates,
                      xValueMapper: (nitrate, _) => nitrate.date,
                      yValueMapper: (nitrate, _) => nitrate.value,
                    )
                  ],
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

// class Data {
//   Data(this.date, this.value);
//   final DateTime date;
//   final double value;
// }
