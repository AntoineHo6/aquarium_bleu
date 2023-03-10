import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TuneChartPage extends StatefulWidget {
  final String tankId;
  final Map<String, dynamic>? visibleParams;

  const TuneChartPage(this.tankId, this.visibleParams, {super.key});

  @override
  State<TuneChartPage> createState() => _TuneChartPageState();
}

class _TuneChartPageState extends State<TuneChartPage> {
  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<CloudFirestoreProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text('nitrate'),
          Switch.adaptive(
              value: widget.visibleParams!['nitrate'],
              onChanged: (newValue) async {
                widget.visibleParams!['nitrate'] = newValue;

                await firestoreProvider.updateParamVis(
                    widget.tankId, 'nitrate', newValue);
              }),
        ],
      ),
    );
  }
}
