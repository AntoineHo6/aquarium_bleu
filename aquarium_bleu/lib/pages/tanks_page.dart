import 'package:aquarium_bleu/pages/tank_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/tank.dart';
import '../widgets/add_tank_alert_dialog.dart';
import '../widgets/my_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TanksPage extends StatefulWidget {
  const TanksPage({super.key});

  @override
  State<TanksPage> createState() => _TanksPageState();
}

class _TanksPageState extends State<TanksPage> {
  // to avoid duplicate tank names when adding tanks
  final List<String> _tankNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: StreamBuilder<List<Tank>>(
          stream: context.watch<CloudFirestoreProvider>().readTanks(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return CustomScrollView(
                slivers: <Widget>[
                  SliverAppBar(
                    pinned: false,
                    expandedHeight: 150.0,
                    flexibleSpace: FlexibleSpaceBar(
                      title: Text(
                        AppLocalizations.of(context).tanks,
                        style: Theme.of(context).textTheme.headline1,
                        textScaleFactor: 0.3,
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      childCount: snapshot.data?.length,
                      (BuildContext context, int index) {
                        Tank tank = snapshot.data!.elementAt(index);
                        // add tank's name to tankNames list.
                        // Lowercase it for ez comparison
                        _tankNames.add(tank.name.toLowerCase());
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TankPage(snapshot.data!.elementAt(index)),
                              ),
                            );
                          },
                          child: Text(snapshot.data!.elementAt(index).name),
                        );
                      },
                    ),
                  ),
                ],
              );
            } else {
              // add a message that says no data available
              return Container();
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AddTankAlertDialog(_tankNames),
        ),
      ),
    );
  }
}
