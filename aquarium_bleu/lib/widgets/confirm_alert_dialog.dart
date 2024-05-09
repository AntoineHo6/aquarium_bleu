import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final Function() onConfirm;

  const ConfirmAlertDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: onConfirm,
          child: Text(AppLocalizations.of(context)!.confirm),
        ),
      ],
    );
  }
}
