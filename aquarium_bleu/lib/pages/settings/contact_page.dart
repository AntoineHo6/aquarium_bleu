import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.contact),
      ),
      body: Padding(
        padding: const EdgeInsets.all(
          Spacing.screenEdgePadding,
        ),
        child: Text(
          AppLocalizations.of(context)!.contactMsg,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
