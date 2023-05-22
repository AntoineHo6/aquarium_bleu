import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/tank_page.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/add_tank_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/tank_card.dart';
import 'package:flutter/material.dart';

class TanksPage extends StatefulWidget {
  const TanksPage({super.key});

  @override
  State<TanksPage> createState() => _TanksPageState();
}

class _TanksPageState extends State<TanksPage> {
  // used to avoid duplicate tank names when adding tanks
  final List<String> _tankNames = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List<Tank>>(
        stream: FirestoreStuff.readTanks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: false,
                  expandedHeight: MediaQuery.of(context).size.height * 0.2,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
                      child: FittedBox(
                        child: Text(
                          StringUtil.formattedDate(context, DateTime.now()),
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
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
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.screenEdgePadding,
                        ),
                        child: TankCard(
                          name: tank.name,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TankPage(snapshot.data!.elementAt(index)),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) => AddTankAlertDialog(_tankNames),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
