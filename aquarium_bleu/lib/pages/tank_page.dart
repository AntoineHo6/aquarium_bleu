import 'package:aquarium_bleu/pages/edit_tank_page.dart';
import 'package:aquarium_bleu/pages/wc/wc_page.dart';
import 'package:aquarium_bleu/pages/param/param_page.dart';
import 'package:aquarium_bleu/providers/edit_add_tank_provider.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
      appBar: AppBar(
        title: Text(tankProvider.tank.name),
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => EditAddTankProvider(
                      isFreshWater: tankProvider.tank.isFreshwater,
                      oldImageName: tankProvider.tank.imgName,
                      dimDropdownValue: tankProvider.tank.dimensions.unit,
                    ),
                    child: const EditTankPage(),
                  ),
                ),
              ).then((value) {
                setState(() {});
              })
            },
            icon: const Icon(Icons.edit),
          )
        ],
      ),
      body: Padding(
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
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ParamPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image: Theme.of(context).brightness == Brightness.dark
                                  ? AssetImage("assets/images/dark_vivid_angelfish.png")
                                  : AssetImage("assets/images/light_vivid_angelfish.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Spacing.cardPadding),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.chartLine,
                                    color: MyTheme.paramColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    AppLocalizations.of(context)!.waterParameters,
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
                  const SizedBox(
                    height: Spacing.betweenSections,
                  ),
                  Expanded(
                    flex: 50,
                    child: SizedBox(
                      width: double.infinity,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WcPage(),
                            ),
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            image: DecorationImage(
                              image: Theme.of(context).brightness == Brightness.dark
                                  ? AssetImage("assets/images/dark_vivid_betta.png")
                                  : AssetImage("assets/images/light_vivid_betta.png"),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(Spacing.cardPadding),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Row(
                                children: [
                                  Icon(
                                    FontAwesomeIcons.droplet,
                                    color: MyTheme.wcColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    AppLocalizations.of(context)!.waterChanges,
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
                  // Expanded(
                  //   flex: 33,
                  //   child: SizedBox(
                  //     width: double.infinity,
                  //     child: Container(
                  //       margin: const EdgeInsets.only(
                  //         left: _marginBetweenBigButtons,
                  //         bottom: _marginBetweenBigButtons,
                  //       ),
                  //       child: GestureDetector(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => ChangeNotifierProvider(
                  //                 create: (context) =>
                  //                     ScheduleProvider(tankProvider.tank.docId),
                  //                 child: const SchedulePage(),
                  //               ),
                  //             ),
                  //           );
                  //         },
                  //         child: Card(
                  //           clipBehavior: Clip.hardEdge,
                  //           elevation: 15,
                  //           child: Padding(
                  //             padding: const EdgeInsets.all(Spacing.cardPadding),
                  //             child: Stack(
                  //               children: [
                  //                 Positioned(
                  //                   top: MediaQuery.of(context).size.height * 0.08,
                  //                   left: MediaQuery.of(context).size.width * 0.6,
                  //                   child: Opacity(
                  //                     opacity: 0.6,
                  //                     child: Icon(
                  //                       Icons.task,
                  //                       size: MediaQuery.of(context).size.width * 0.3,
                  //                       color: Colors.yellow[700],
                  //                     ),
                  //                   ),
                  //                 ),
                  //                 Text(
                  //                   "Scedule",
                  //                   style: Theme.of(context).textTheme.headlineLarge,
                  //                 ),
                  //               ],
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
            // const SizedBox(
            //   height: Spacing.betweenSections,
            // ),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: TextButton(
            //     onPressed: () => {},
            //     child: Text(AppLocalizations.of(context)!.viewAll),
            //   ),
            // ),
            // SizedBox(
            //   height: MediaQuery.of(context).size.height * 0.2,
            //   child: ListView(
            //     scrollDirection: Axis.horizontal,
            //     children: [
            //       HorizontalListCard(
            //         title: AppLocalizations.of(context)!.animals,
            //         iconData: Icons.pets,
            //         color: Colors.teal,
            //       ),
            //       HorizontalListCard(
            //         title: AppLocalizations.of(context)!.plants,
            //         iconData: Icons.eco,
            //         color: Colors.lightGreen,
            //       ),
            //       HorizontalListCard(
            //         title: AppLocalizations.of(context)!.equipment,
            //         iconData: Icons.token_outlined,
            //         color: Colors.brown,
            //       ),
            //       HorizontalListCard(
            //         title: AppLocalizations.of(context)!.equipment,
            //         iconData: Icons.attach_money,
            //         color: Colors.green,
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}

const double _marginBetweenBigButtons = 2.5;
