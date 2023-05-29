import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TankCard extends StatefulWidget {
  final Tank tank;
  final Function onPressed;
  final String? imgUrl;

  const TankCard({required this.tank, required this.onPressed, this.imgUrl, super.key});

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
              child: widget.imgUrl != null
                  ? CachedNetworkImage(
                      imageUrl: widget.imgUrl!,
                      placeholder: (context, url) => const CircularProgressIndicator(),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    )
                  : const Text("no image"),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.tank.name,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  StreamBuilder<Parameter>(
                      // TODO: shouldn't be hardcoded to nitrate
                      stream: FirestoreStuff.readLatestParameter(
                          widget.tank.docId, WaterParamType.nitrate),
                      builder: (context, latestParamSnapshot) {
                        if (latestParamSnapshot.hasData) {
                          return RichText(
                            text: TextSpan(
                              // Note: Styles for TextSpans must be explicitly defined.
                              // Child text spans will inherit styles from parent
                              style: Theme.of(context).textTheme.titleMedium,
                              children: <TextSpan>[
                                // TODO: shouldn't be hardcoded to nitrate
                                TextSpan(text: '${AppLocalizations.of(context).lastNitrateLevel}:'),
                                TextSpan(
                                  text: ' ${latestParamSnapshot.data!.value.toString()}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orangeAccent,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return const SizedBox();
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
