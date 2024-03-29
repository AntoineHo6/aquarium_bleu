import 'package:aquarium_bleu/pages/edit_tank_page.dart';
import 'package:aquarium_bleu/pages/tasks/tasks_page.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/providers/tasks_provider.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/tank_page/horizontal_list_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TankPage extends StatefulWidget {
  const TankPage({super.key});

  @override
  State<TankPage> createState() => _TankPageState();
}

class _TankPageState extends State<TankPage> {
  @override
  Widget build(BuildContext context) {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              background: Opacity(
                opacity: 0.4,
                child: tankProvider.image,
              ),
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
                child: FittedBox(
                  child: Text(
                    tankProvider.tank.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EditTankPage(),
                    ),
                  ).then((value) {
                    setState(() {});
                  })
                },
                icon: const Icon(Icons.edit),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(Spacing.screenEdgePadding),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 50,
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    right: _marginBetweenBigButtons,
                                    bottom: _marginBetweenBigButtons,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const WcnpPage(),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      clipBehavior: Clip.hardEdge,
                                      elevation: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(Spacing.cardPadding),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: MediaQuery.of(context).size.height * 0.08,
                                              left: MediaQuery.of(context).size.width * 0.6,
                                              child: Opacity(
                                                opacity: 0.6,
                                                child: Icon(
                                                  Icons.water_drop,
                                                  color: MyTheme.wcColor,
                                                  size: MediaQuery.of(context).size.width * 0.3,
                                                ),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .waterChangesAndParameters,
                                                style: Theme.of(context).textTheme.headlineLarge,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 50,
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  margin: const EdgeInsets.only(
                                    left: _marginBetweenBigButtons,
                                    bottom: _marginBetweenBigButtons,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ChangeNotifierProvider(
                                            create: (context) =>
                                                TasksProvider(tankProvider.tank.docId),
                                            child: const TasksPage(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      clipBehavior: Clip.hardEdge,
                                      elevation: 15,
                                      child: Padding(
                                        padding: const EdgeInsets.all(Spacing.cardPadding),
                                        child: Stack(
                                          children: [
                                            Positioned(
                                              top: MediaQuery.of(context).size.height * 0.08,
                                              left: MediaQuery.of(context).size.width * 0.6,
                                              child: Opacity(
                                                opacity: 0.6,
                                                child: Icon(
                                                  Icons.task,
                                                  size: MediaQuery.of(context).size.width * 0.3,
                                                  color: Colors.yellow[700],
                                                ),
                                              ),
                                            ),
                                            Text(
                                              AppLocalizations.of(context).tasks,
                                              style: Theme.of(context).textTheme.headlineLarge,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: Spacing.betweenSections,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => {},
                          child: Text(AppLocalizations.of(context).viewAll),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            HorizontalListCard(
                              title: AppLocalizations.of(context).animals,
                              iconData: Icons.pets,
                              color: Colors.teal,
                            ),
                            HorizontalListCard(
                              title: AppLocalizations.of(context).plants,
                              iconData: Icons.eco,
                              color: Colors.lightGreen,
                            ),
                            HorizontalListCard(
                              title: AppLocalizations.of(context).equipment,
                              iconData: Icons.token_outlined,
                              color: Colors.brown,
                            ),
                            HorizontalListCard(
                              title: AppLocalizations.of(context).equipment,
                              iconData: Icons.attach_money,
                              color: Colors.green,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const double _marginBetweenBigButtons = 2.5;
