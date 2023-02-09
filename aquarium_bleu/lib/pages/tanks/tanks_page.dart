import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/tanks/tank_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/date_time_util.dart';
import 'package:aquarium_bleu/widgets/add_tank_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/tank_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        stream: context.watch<CloudFirestoreProvider>().readTanks(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  pinned: false,
                  expandedHeight: MediaQuery.of(context).size.height * 0.2,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    title: Container(
                      margin: const EdgeInsets.only(
                        left: Spacing.screenEdgeMargin,
                        right: Spacing.screenEdgeMargin,
                      ),
                      child: FittedBox(
                        child: Text(
                          DateTimeUtil.formattedDate(context, DateTime.now()),
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
                      return Container(
                        margin: const EdgeInsets.only(
                          left: Spacing.screenEdgeMargin,
                          right: Spacing.screenEdgeMargin,
                        ),
                        child: TankCard(
                          name: tank.name,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    TankPage(snapshot.data!.elementAt(index)),
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
            // add a message that says no data available
            return Container();
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
