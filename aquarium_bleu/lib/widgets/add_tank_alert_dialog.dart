import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import 'name_text_field.dart';

class AddTankAlertDialog extends StatefulWidget {
  final List<String> tankNames;

  const AddTankAlertDialog(this.tankNames, {super.key});

  @override
  State<AddTankAlertDialog> createState() => _AddTankAlertDialogState();
}

class _AddTankAlertDialogState extends State<AddTankAlertDialog> {
  late TextEditingController _nameFieldController;
  bool? _isFreshwater = true;
  bool _isNameValid = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).addANewTank,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            NameTextField(
              controller: _nameFieldController,
              isNameValid: _isNameValid,
              errorText: _errorText,
            ),
            Text("${AppLocalizations.of(context).tankType}:"),
            ListTile(
              title: Text(AppLocalizations.of(context).freshwater),
              leading: Radio<bool>(
                value: true,
                groupValue: _isFreshwater,
                onChanged: (bool? value) {
                  setState(() {
                    _isFreshwater = value;
                  });
                },
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context).saltwater),
              leading: Radio<bool>(
                value: false,
                groupValue: _isFreshwater,
                onChanged: (bool? value) {
                  setState(() {
                    _isFreshwater = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context).add),
          onPressed: () => handleAdd(context),
        ),
      ],
    );
  }

  void handleAdd(BuildContext context) {
    String nameModified = _nameFieldController.text.trim().toLowerCase();
    if (nameModified.isEmpty) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).emptyName;
      });
    } else if (widget.tankNames.contains(nameModified)) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).nameAlreadyExists;
      });
    } else {
      Provider.of<CloudFirestoreProvider>(context, listen: false)
          .createTank(_nameFieldController.text, _isFreshwater!);
      Navigator.pop(context);
    }
  }
}
