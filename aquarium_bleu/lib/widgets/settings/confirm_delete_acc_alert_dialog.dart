import 'dart:io';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/loading_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/msg_alert_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmDeleteAccAlertDialog extends StatefulWidget {
  const ConfirmDeleteAccAlertDialog({super.key});

  @override
  State<ConfirmDeleteAccAlertDialog> createState() => ConfirmDeleteAccAlertDialogState();
}

class ConfirmDeleteAccAlertDialogState extends State<ConfirmDeleteAccAlertDialog> {
  late TextEditingController _confirmFieldController;
  bool _isConfirmValid = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _confirmFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _confirmFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Padding(
        padding: const EdgeInsets.only(bottom: Spacing.betweenSections),
        child: Text(AppLocalizations.of(context)!.deleteAccount),
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            Text(AppLocalizations.of(context)!.deleteAccWarningMsg),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Platform.isIOS
                ? CupertinoTextField(
                    controller: _confirmFieldController,
                    maxLength: 7,
                    placeholder: 'CONFIRM',
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isConfirmValid
                            ? Colors.grey[800]!
                            : Theme.of(context).colorScheme.error,
                      ),
                    ),
                    style: TextStyle(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                  )
                : TextField(
                    controller: _confirmFieldController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: "CONFIRM",
                      errorText: _isConfirmValid ? null : _errorText,
                    ),
                    maxLength: 7,
                  ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(AppLocalizations.of(context)!.cancel),
        ),
        TextButton(
          onPressed: () async => await _handleDelete(),
          child: Text(AppLocalizations.of(context)!.delete),
        ),
      ],
    );
  }

  _handleDelete() async {
    String confirmStr = _confirmFieldController.text.trim();
    if (confirmStr == "CONFIRM") {
      setState(() {
        _isConfirmValid = true;
      });

      await _deleteUser();
    } else {
      setState(() {
        _errorText = AppLocalizations.of(context)!.invalid;
        _isConfirmValid = false;
      });
    }
  }

  Future<void> _deleteUser() async {
    showDialog(
      context: context,
      builder: (BuildContext context) => const LoadingAlertDialog(),
    );

    await FirestoreStuff.deleteUserDoc();

    User? user = FirebaseAuth.instance.currentUser;

    try {
      await user?.delete();
      await Navigator.pushReplacementNamed(context, '/sign-in');
      Navigator.pop(context);
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      if (e.code == 'requires-recent-login') {
        await showDialog(
          context: context,
          builder: (BuildContext context) => MsgAlertDialog(
            content: Text(AppLocalizations.of(context)!.accDeleteErrMsg),
          ),
        );
      }
    }

    Navigator.pop(context);
  }
}
