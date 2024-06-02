import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignedInAsToast extends StatelessWidget {
  final String email;
  const SignedInAsToast(this.email, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: MyTheme.seedColor,
      ),
      child: FittedBox(
        child: Text('${AppLocalizations.of(context)!.signedInAs} $email'),
      ),
    );
  }
}
