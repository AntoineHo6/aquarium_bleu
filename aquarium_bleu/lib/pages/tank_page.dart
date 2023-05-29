import 'package:aquarium_bleu/pages/edit_tank_page.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
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
              background: Image.asset(
                "assets/images/koi_pixel.png",
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.15),
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
                  )
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenEdgePadding,
                    vertical: Spacing.betweenSections,
                  ),
                  child: SizedBox(
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
                                  elevation: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(_cardPadding),
                                    child: Align(
                                      alignment: Alignment.topLeft,
                                      child: Text(
                                        AppLocalizations.of(context).waterChangesAndParameters,
                                        style: Theme.of(context).textTheme.headlineSmall,
                                      ),
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
                                elevation: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(_cardPadding),
                                  child: Text(
                                    AppLocalizations.of(context).tasks,
                                    style: Theme.of(context).textTheme.headlineSmall,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
const double _cardPadding = 10;
