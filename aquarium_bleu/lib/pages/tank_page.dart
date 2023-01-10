import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/widgets/add_param_val_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TankPage extends StatefulWidget {
  final Tank tank;

  const TankPage(this.tank, {super.key});

  @override
  State<TankPage> createState() => _TankPageState();
}

enum MenuItem {
  addMeasurement,
}

class _TankPageState extends State<TankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tank.name),
        actions: [
          PopupMenuButton(
            onSelected: (MenuItem item) {
              switch (item) {
                case MenuItem.addMeasurement:
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        const AddParamValAlertDialog(),
                  );
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              PopupMenuItem<MenuItem>(
                value: MenuItem.addMeasurement,
                child: Text(AppLocalizations.of(context).addParameterValue),
              ),
              PopupMenuItem<MenuItem>(
                value: null,
                child: Text(AppLocalizations.of(context).editTank),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
          stream: context
              .watch<CloudFirestoreProvider>()
              .readNitrates(widget.tank.docId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data!
                    .map(
                      (nitrate) => ElevatedButton(
                        onPressed: () => null,
                        child: Text(
                          "${nitrate.amount.toString()} ${nitrate.unit.toString()}",
                        ),
                      ),
                    )
                    .toList(),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
