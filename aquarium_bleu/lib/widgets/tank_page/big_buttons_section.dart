import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/tanks/water_param_page.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
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
            flex: 50,
            child: Column(
              children: [
                Expanded(
                  flex: 66,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        right: _marginBetweenBigButtons,
                        bottom: _marginBetweenBigButtons,
                      ),
                      child: ElevatedButton(
                        style: _bigButtonsStyle,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WaterParamPage(tank),
                            ),
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context).waterParameters,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 33,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: _marginBetweenBigButtons,
                        right: _marginBetweenBigButtons,
                      ),
                      child: ElevatedButton(
                        style: _bigButtonsStyle,
                        onPressed: () => null,
                        child: Text(
                          AppLocalizations.of(context).waterChanges,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 50,
            child: Column(
              children: [
                Expanded(
                  flex: 33,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: _marginBetweenBigButtons,
                        bottom: _marginBetweenBigButtons,
                      ),
                      child: ElevatedButton(
                        style: _bigButtonsStyle,
                        onPressed: () => null,
                        child: Text(
                          AppLocalizations.of(context).animals,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 33,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: _marginBetweenBigButtons,
                        left: _marginBetweenBigButtons,
                        bottom: _marginBetweenBigButtons,
                      ),
                      child: ElevatedButton(
                        style: _bigButtonsStyle,
                        onPressed: () => null,
                        child: Text(
                          AppLocalizations.of(context).plants,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 33,
                  child: SizedBox(
                    width: double.infinity,
                    child: Container(
                      margin: const EdgeInsets.only(
                        top: _marginBetweenBigButtons,
                        left: _marginBetweenBigButtons,
                      ),
                      child: ElevatedButton(
                        style: _bigButtonsStyle,
                        onPressed: () => null,
                        child: Text(
                          AppLocalizations.of(context).equipment,
                          style: Theme.of(context).textTheme.titleLarge,
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

ButtonStyle _bigButtonsStyle = ButtonStyle(
  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  ),
);

const double _marginBetweenBigButtons = 5;
