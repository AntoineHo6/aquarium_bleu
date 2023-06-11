import 'dart:io';
import 'package:aquarium_bleu/firebase_storage_stuff.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/confirm_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/loading_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditTankPage extends StatefulWidget {
  const EditTankPage({super.key});

  @override
  State<EditTankPage> createState() => _EditTankPageState();
}

class _EditTankPageState extends State<EditTankPage> {
  late TextEditingController _nameFieldController;
  bool _isNameValid = true;
  String? _errorText;
  XFile? image;
  late Widget picture;

  @override
  void initState() {
    super.initState();
    _nameFieldController = TextEditingController();
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    _nameFieldController.value = TextEditingValue(text: tankProvider.tank.name);
    picture = tankProvider.image;
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    super.dispose();
  }

  Future _handleUpdate() async {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    String name = _nameFieldController.text.trim();
    String nameLowerCase = name.toLowerCase();
    // Determine the right error message to show for the name.
    if (nameLowerCase.isEmpty) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).emptyName;
      });
    } else if (nameLowerCase != tankProvider.tank.name.toLowerCase() &&
        tankProvider.tankNames.contains(nameLowerCase)) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).nameAlreadyExists;
      });
    } else {
      setState(() {
        _isNameValid = true;
      });

      tankProvider.tankNames.remove(tankProvider.tank.name);
      tankProvider.tank.name = name;

      showDialog(context: context, builder: (BuildContext context) => const LoadingAlertDialog());

      if (image != null) {
        tankProvider.tank.imgName = image!.name;
        tankProvider.image = picture;
        await FirebaseStorageStuff().uploadImg(image!.name, image!.path);
      }

      await FirestoreStuff.updateTank(tankProvider.tank).then((value) {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editTank),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => ConfirmAlertDialog(
                title: Text('${AppLocalizations.of(context).delete} ${tankProvider.tank.name}'),
                content: Text(AppLocalizations.of(context).confirmDeleteX(tankProvider.tank.name)),
                onConfirm: () async {
                  tankProvider.tankNames.remove(tankProvider.tank.name);
                  await FirestoreStuff.deleteTank(tankProvider.tank).then((value) {
                    Navigator.pop(context);
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.screenEdgePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameFieldController,
              decoration: InputDecoration(
                labelText:
                    "${AppLocalizations.of(context).name} (${AppLocalizations.of(context).required})",
                errorText: _isNameValid ? null : _errorText,
              ),
              maxLength: 50,
            ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Text(
              '${AppLocalizations.of(context).displayPicture}:',
              style: Theme.of(context).textTheme.titleLarge,
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
              child: Card(
                elevation: 5,
                child: Container(
                  constraints: BoxConstraints(
                    minWidth: MediaQuery.of(context).size.width * 0.3,
                    maxWidth: MediaQuery.of(context).size.width * 0.4,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: picture,
                      ),
                      const Icon(Icons.edit),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Row(
              children: [
                Expanded(
                  flex: 30,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppLocalizations.of(context).cancel),
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: ElevatedButton(
                    onPressed: () {
                      _handleUpdate();
                    },
                    child: Text(AppLocalizations.of(context).update),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
