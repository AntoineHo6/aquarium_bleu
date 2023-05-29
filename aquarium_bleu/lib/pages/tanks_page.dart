import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/my_cache_manager.dart';
import 'package:aquarium_bleu/pages/tank_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/add_tank_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/tank_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TanksPage extends StatefulWidget {
  const TanksPage({super.key});

  @override
  State<TanksPage> createState() => _TanksPageState();
}

class _TanksPageState extends State<TanksPage> {
  @override
  Widget build(BuildContext context) {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

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
                      tankProvider.tankNames.add(tank.name.toLowerCase());

                      if (tank.imgName != null) {
                        return FutureBuilder(
                          future: MyCacheManager().getCacheImage(
                              '${FirebaseAuth.instance.currentUser!.uid}/${tank.imgName}'),
                          builder: ((context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: Spacing.screenEdgePadding,
                                ),
                                child: TankCard(
                                  tank: tank,
                                  imgUrl: snapshot.data!,
                                  onPressed: () {
                                    tankProvider.tank = tank;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const TankPage(),
                                      ),
                                    );
                                  },
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator.adaptive();
                            }
                          }),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.screenEdgePadding,
                          ),
                          child: TankCard(
                            tank: tank,
                            onPressed: () {
                              tankProvider.tank = tank;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TankPage(),
                                ),
                              );
                            },
                          ),
                        );
                      }
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
          builder: (BuildContext context) => const AddTankAlertDialog(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
