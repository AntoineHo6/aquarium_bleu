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
                        builder: (context) => WcnpPage(tank.docId),
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
    );
  }
}

const double _marginBetweenBigButtons = 2.5;
const double _cardPadding = 10;
