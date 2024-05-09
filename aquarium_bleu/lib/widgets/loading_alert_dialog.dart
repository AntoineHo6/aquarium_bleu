import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoadingAlertDialog extends StatelessWidget {
  const LoadingAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            '${AppLocalizations.of(context)!.loading}...',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const CircularProgressIndicator.adaptive(),
        ],
      ),
    );
  }
}
