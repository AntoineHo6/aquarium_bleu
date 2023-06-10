import 'package:aquarium_bleu/pages/edit_tank_page.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/horizontal_list_card.dart';
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
                opacity: 0.5,
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
                                      elevation: 3,
                                      child: Padding(
                                        padding: const EdgeInsets.all(Spacing.cardPadding),
                                        child: Stack(
                                          children: [
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Icon(
                                                Icons.water_drop,
                                                color: Colors.lightBlue[700],
                                                size: MediaQuery.of(context).size.width * 0.55,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topLeft,
                                              child: Text(
                                                AppLocalizations.of(context)
                                                    .waterChangesAndParameters,
                                                style: Theme.of(context).textTheme.headlineMedium,
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
                                  child: Card(
                                    clipBehavior: Clip.hardEdge,
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(Spacing.cardPadding),
                                      child: Stack(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerRight,
                                            child: Icon(
                                              Icons.calendar_month,
                                              size: MediaQuery.of(context).size.width * 0.55,
                                              color: Colors.yellow[700],
                                            ),
                                          ),
                                          Text(
                                            AppLocalizations.of(context).tasks,
                                            style: Theme.of(context).textTheme.headlineMedium,
                                          ),
                                        ],
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
