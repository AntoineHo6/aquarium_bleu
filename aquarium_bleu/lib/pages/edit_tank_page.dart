import 'dart:io';
import 'package:aquarium_bleu/firebase_storage_stuff.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
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

  Future _handleUpdate(BuildContext context) async {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    String name = _nameFieldController.text.trim().toLowerCase();
    // Determine the right error message to show for the name.
    if (name.isEmpty) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).emptyName;
      });
    } else if (name != tankProvider.tank.name && tankProvider.tankNames.contains(name)) {
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).nameAlreadyExists;
      });
    } else {
      setState(() {
        _isNameValid = true;
      });
      tankProvider.tank.name = name;

      if (image != null) {
        tankProvider.tank.imgName = image!.name;
        tankProvider.image = picture;
        await FirebaseStorageStuff().uploadImg(image!.name, image!.path);
      }
      await FirestoreStuff.updateTank(tankProvider.tank);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).editTank),
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
              '${AppLocalizations.of(context).tankPicture}:',
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
                      _handleUpdate(context);
                      Navigator.pop(context);
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
