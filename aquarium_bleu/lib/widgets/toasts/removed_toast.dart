import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RemovedToast extends StatelessWidget {
  const RemovedToast({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: MyTheme.seedColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.delete),
          SizedBox(
            width: 12.0,
          ),
          Text(AppLocalizations.of(context)!.removed),
        ],
      ),
    );
  }
}
