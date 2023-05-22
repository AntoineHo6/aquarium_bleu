import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/wcnp/wcnp_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BigButtonsSection extends StatelessWidget {
  final Tank tank;

  const BigButtonsSection(this.tank, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 65,
            child: Column(
              children: [
                Expanded(
                  flex: 75,
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
                              builder: (context) => WaterParamPage(tank.docId),
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
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: _marginBetweenBigButtons,
                        right: _marginBetweenBigButtons,
                      ),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(_cardPadding),
                          child: Text(
                            AppLocalizations.of(context).waterChanges,
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 35,
            child: Column(
              children: [
                Expanded(
                  flex: 75,
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
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 25,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: _marginBetweenBigButtons,
                        left: _marginBetweenBigButtons,
                      ),
                      child: Card(
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(_cardPadding),
                          child: Text(
                            'pictures',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

const double _marginBetweenBigButtons = 2.5;
const double _cardPadding = 10;
