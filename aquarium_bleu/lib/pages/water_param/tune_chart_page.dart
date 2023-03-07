import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:provider/provider.dart';

class TuneChartPage extends StatefulWidget {
  const TuneChartPage({super.key});

  @override
  State<TuneChartPage> createState() => _TuneChartPageState();
}

class _TuneChartPageState extends State<TuneChartPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const Text('nitrate'),
          Switch.adaptive(
              value: settingsProvider.visibleParams['nitrate']! ? true : false,
              onChanged: (newValue) async {
                await settingsProvider.setVisibleParam('nitrate', newValue);
                if (newValue == false &&
                    settingsProvider.lastSelectedParam == Strings.nitrate) {
                  settingsProvider.setLastSelectedParam(Strings.none);
                }
              }),
        ],
      ),
    );
  }
}
