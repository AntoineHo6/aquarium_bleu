import 'dart:ui';

import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/pages/water_param_page.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TankPage extends StatefulWidget {
  final Tank tank;

  const TankPage(this.tank, {super.key});

  @override
  State<TankPage> createState() => _TankPageState();
}

class _TankPageState extends State<TankPage> {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => null,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: FittedBox(
              child: Text(
                widget.tank.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            margin: const EdgeInsets.only(
              left: Spacing.screenEdgeMargin,
              right: Spacing.screenEdgeMargin,
            ),
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
                              right: marginBetweenBigButtons,
                              bottom: marginBetweenBigButtons,
                            ),
                            child: ElevatedButton(
                              style: _bigButtonsStyle,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        WaterParamPage(widget.tank),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  Text(AppLocalizations.of(context)
                                      .waterParameters),
                                  const Icon(Icons.show_chart_rounded),
                                ],
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
                              top: marginBetweenBigButtons,
                              right: marginBetweenBigButtons,
                            ),
                            child: ElevatedButton(
                                style: _bigButtonsStyle,
                                onPressed: () => null,
                                child: Column(
                                  children: [
                                    Text(AppLocalizations.of(context)
                                        .waterChanges),
                                  ],
                                )),
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
                              left: marginBetweenBigButtons,
                              bottom: marginBetweenBigButtons,
                            ),
                            child: ElevatedButton(
                              style: _bigButtonsStyle,
                              onPressed: () => null,
                              child: Text(AppLocalizations.of(context).animals),
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
                              top: marginBetweenBigButtons,
                              left: marginBetweenBigButtons,
                              bottom: marginBetweenBigButtons,
                            ),
                            child: ElevatedButton(
                              style: _bigButtonsStyle,
                              onPressed: () => null,
                              child: Text(AppLocalizations.of(context).plants),
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
                              top: marginBetweenBigButtons,
                              left: marginBetweenBigButtons,
                            ),
                            child: ElevatedButton(
                              style: _bigButtonsStyle,
                              onPressed: () => null,
                              child:
                                  Text(AppLocalizations.of(context).equipment),
                            ),
                          ),
                        ),
                      ),
                    ],
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
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(40),
    ),
  ),
);

const double marginBetweenBigButtons = 5;
