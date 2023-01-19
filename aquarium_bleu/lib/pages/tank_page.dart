import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TankPage extends StatefulWidget {
  final Tank tank;

  const TankPage(this.tank, {super.key});

  @override
  State<TankPage> createState() => _TankPageState();
}

class _TankPageState extends State<TankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => null,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                widget.tank.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2,
              ),
            ),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WaterParamPage(widget.tank),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Text(AppLocalizations.of(context).waterParameters),
                    const Icon(Icons.show_chart_rounded),
                  ],
                ),
              ),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () => null,
                    child: Text(AppLocalizations.of(context).inhabitants),
                  ),
                  ElevatedButton(
                    onPressed: () => null,
                    child: Text(AppLocalizations.of(context).equipment),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
