import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TankCard extends StatefulWidget {
  final Tank tank;
  final Function onPressed;
  final Widget image;

  const TankCard({required this.tank, required this.onPressed, required this.image, super.key});

  @override
  State<TankCard> createState() => _TankCardState();
}

class _TankCardState extends State<TankCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onPressed(),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              child: widget.image,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tank.name,
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  StreamBuilder<WaterChange>(
                    stream: FirestoreStuff.readLatestWc(widget.tank.docId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final difference = DateTime.now().difference(snapshot.data!.date).inDays;

                        return RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleMedium,
                            children: <TextSpan>[
                              TextSpan(
                                text: '${AppLocalizations.of(context)!.lastWaterChange}: ',
                              ),
                              TextSpan(
                                text: AppLocalizations.of(context)!.xDaysAgo(difference.toString()),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent,
                                ),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
