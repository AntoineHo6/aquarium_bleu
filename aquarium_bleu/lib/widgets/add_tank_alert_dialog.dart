import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddTankAlertDialog extends StatefulWidget {
  const AddTankAlertDialog({super.key});

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
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    String nameModified = _nameFieldController.text.trim().toLowerCase();

    // Determine the right error message to show for the name.
    // Otherwise, create the tank.
    if (nameModified.isEmpty) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).emptyName;
      });
    } else if (tankProvider.tankNames.contains(nameModified)) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).nameAlreadyExists;
      });
    } else {
      Tank tank = Tank(
        const Uuid().v4(),
        name: _nameFieldController.text,
        isFreshwater: _isFreshwater!,
      );
      FirestoreStuff.addTank(tank).then((docId) {
        FirestoreStuff.addDefaultWcnpPrefs(docId);
      });

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
            TextField(
              controller: _nameFieldController,
              decoration: InputDecoration(
                labelText:
                    "${AppLocalizations.of(context).name} (${AppLocalizations.of(context).required})",
                errorText: _isNameValid ? null : _errorText,
              ),
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
