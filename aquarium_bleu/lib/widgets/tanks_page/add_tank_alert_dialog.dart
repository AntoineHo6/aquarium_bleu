import 'dart:io';

import 'package:aquarium_bleu/firebase_storage_stuff.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/loading_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
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
  XFile? image;
  Widget? picture;
  late TextEditingController _widthFieldController;
  late TextEditingController _lengthFieldController;
  late TextEditingController _heightFieldController;
  bool _isWidthValid = true;
  bool _isLengthValid = true;
  bool _isHeightValid = true;
  String? _dimensionErrorText;

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController();
    _widthFieldController = TextEditingController();
    _lengthFieldController = TextEditingController();
    _heightFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _widthFieldController.dispose();
    _lengthFieldController.dispose();
    _heightFieldController.dispose();
    super.dispose();
  }

  void _handleAdd(BuildContext context) async {
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

      showDialog(context: context, builder: (BuildContext context) => const LoadingAlertDialog());

      if (image != null) {
        tank.imgName = image!.name;
        await FirebaseStorageStuff().uploadImg(image!.name, image!.path);
      }

      FirestoreStuff.addTank(tank).then((docId) {
        FirestoreStuff.addDefaultWcnpPrefs(docId).then((value) {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      });
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
              maxLength: 50,
              controller: _nameFieldController,
              decoration: InputDecoration(
                labelText:
                    "${AppLocalizations.of(context).name} (${AppLocalizations.of(context).required})",
                errorText: _isNameValid ? null : _errorText,
              ),
            ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Text(
              "${AppLocalizations.of(context).displayPicture}:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                // Pick an image.
                await picker
                    .pickImage(source: ImageSource.gallery, imageQuality: 50)
                    .then((pickedImage) {
                  image = pickedImage;

                  if (image == null) {
                    const SnackBar snackBar = SnackBar(
                      content: Text('no image selected'),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    setState(() {
                      picture = Image.file(
                        File(image!.path),
                        fit: BoxFit.cover,
                      );
                    });
                  }
                });
              },
              child: picture == null
                  ? SizedBox(
                      height: MediaQuery.of(context).size.height * 0.15,
                      child: Card(
                        child: Icon(
                          Icons.add_circle,
                          size: MediaQuery.of(context).size.height * 0.05,
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: picture,
                      ),
                    ),
            ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Text(
              "${AppLocalizations.of(context).tankType}:",
              style: Theme.of(context).textTheme.titleMedium,
            ),
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
            TextField(
              maxLength: 3,
              keyboardType: TextInputType.number,
              controller: _widthFieldController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).width,
                errorText: _isWidthValid ? null : _errorText,
              ),
            ),
            TextField(
              maxLength: 3,
              keyboardType: TextInputType.number,
              controller: _lengthFieldController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).length,
                errorText: _isWidthValid ? null : _errorText,
              ),
            ),
            TextField(
              maxLength: 3,
              keyboardType: TextInputType.number,
              controller: _heightFieldController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context).height,
                errorText: _isWidthValid ? null : _errorText,
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
