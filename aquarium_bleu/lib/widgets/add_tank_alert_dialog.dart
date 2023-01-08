import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'name_text_field.dart';

class AddTankAlertDialog extends StatefulWidget {
  List<String> tankNames;

  AddTankAlertDialog(this.tankNames, {super.key});

  @override
  State<AddTankAlertDialog> createState() => _AddTankAlertDialogState();
}

class _AddTankAlertDialogState extends State<AddTankAlertDialog> {
  late TextEditingController _nameFieldController;
  bool? _isFreshwater = true;
  bool _isNameValid = true;
  bool _nameAlreadyExists = false;
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
    if (_nameAlreadyExists) {
      _errorText = AppLocalizations.of(context).nameAlreadyExists;
    } else {
      _errorText = AppLocalizations.of(context).invalidName;
    }

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
          onPressed: () => handleAdd(),
        ),
      ],
    );
  }

  void handleAdd() {
    String name = _nameFieldController.text.trim().toLowerCase();
    if (name.isEmpty) {
      setState(() {
        _isNameValid = false;
        _nameAlreadyExists = false;
      });
    } else if (widget.tankNames.contains(name)) {
      setState(() {
        _nameAlreadyExists = true;
      });
    } else {
      Navigator.pop(context);
    }
  }
}
