import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/wcnp/edit_wc_page.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_tune_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/wcnp_page/add_water_change_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class WaterChangePage extends StatefulWidget {
  const WaterChangePage({super.key});

  @override
  State<WaterChangePage> createState() => _WaterChangePageState();
}

class _WaterChangePageState extends State<WaterChangePage> {
  @override
  Widget build(BuildContext context) {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    return StreamBuilder(
        stream: FirestoreStuff.readAllWaterChanges(tankProvider.tank.docId),
        builder: (context, wcSnapshot) {
          if (wcSnapshot.hasData) {
            List<Widget> wcListTiles = _createWcListTiles(wcSnapshot.data!);

            return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.waterChanges),
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.screenEdgePadding),
                child: ListView(children: wcListTiles),
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AddWaterChangeAlertDialog(tankProvider.tank.docId),
                ),
                child: const Icon(Icons.add),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }

  List<Widget> _createWcListTiles(List<WaterChange> waterChanges) {
    return waterChanges
        .map((wc) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditWcPage(wc),
                  ),
                ),
                child: ListTile(
                  title: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: StringUtil.formattedDate(context, wc.date),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyTheme.wcColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  subtitle: Text(
                    StringUtil.formattedTime(
                      context,
                      TimeOfDay.fromDateTime(wc.date),
                    ),
                  ),
                ),
              ),
            ))
        .toList();
  }
}
