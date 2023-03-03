import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'my_text_field.dart';

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

  void _handleAdd(BuildContext context) {
    String nameModified = _nameFieldController.text.trim().toLowerCase();

    // Determine the right error message to show for the name.
    // Otherwise, create the tank.
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

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).addANewTank,
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            MyTextField(
              controller: _nameFieldController,
              isFieldValid: _isNameValid,
              hintText:
                  "${AppLocalizations.of(context).name} (${AppLocalizations.of(context).required})",
              errorText: _errorText,
              maxLength: 50,
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
          child: Text(AppLocalizations.of(context).cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context).add),
          onPressed: () => _handleAdd(context),
        ),
      ],
    );
  }
}
