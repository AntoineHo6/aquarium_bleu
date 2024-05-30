import 'dart:io';
import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:aquarium_bleu/firebase_storage_stuff.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/edit_add_tank_provider.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/confirm_alert_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  late Widget picture;
  late TextEditingController _widthFieldController;
  late TextEditingController _lengthFieldController;
  late TextEditingController _heightFieldController;

  @override
  void initState() {
    super.initState();
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    _nameFieldController = TextEditingController();
    _nameFieldController.value = TextEditingValue(text: tankProvider.tank.name);

    picture = tankProvider.image;

    _widthFieldController = TextEditingController();
    if (tankProvider.tank.dimensions.width != null) {
      _widthFieldController.value =
          TextEditingValue(text: tankProvider.tank.dimensions.width.toString());
    }

    _lengthFieldController = TextEditingController();
    if (tankProvider.tank.dimensions.length != null) {
      _lengthFieldController.value =
          TextEditingValue(text: tankProvider.tank.dimensions.length.toString());
    }

    _heightFieldController = TextEditingController();
    if (tankProvider.tank.dimensions.height != null) {
      _heightFieldController.value =
          TextEditingValue(text: tankProvider.tank.dimensions.height.toString());
    }

    // dropdownValue = tankProvider.tank.dimensions.unit;
  }

  @override
  void dispose() {
    _nameFieldController.dispose();
    _widthFieldController.dispose();
    _lengthFieldController.dispose();
    _heightFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.editTank),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => ConfirmAlertDialog(
                title: Text('${AppLocalizations.of(context)!.delete} ${tankProvider.tank.name}'),
                content: Text(AppLocalizations.of(context)!.confirmDeleteX(tankProvider.tank.name)),
                onConfirm: () async {
                  await FirestoreStuff.deleteTank(tankProvider.tank);

                  if (tankProvider.tank.imgName != null) {
                    await FirebaseStorageStuff.deleteImg(tankProvider.tank.imgName!);
                  }

                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ),
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Consumer<EditAddTankProvider>(
        builder: ((context, editProv, child) {
          return Scrollbar(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(Spacing.screenEdgePadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    TextField(
                      maxLength: 50,
                      controller: _nameFieldController,
                      decoration: InputDecoration(
                        label: RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleMedium,
                            children: <TextSpan>[
                              TextSpan(
                                text: '${AppLocalizations.of(context)!.name}: ',
                              ),
                              const TextSpan(
                                text: '*',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        errorText: editProv.isNameValid ? null : editProv.nameErrorText,
                      ),
                    ),
                    const SizedBox(
                      height: Spacing.betweenSections,
                    ),
                    Text(
                      '${AppLocalizations.of(context)!.displayPicture}:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    GestureDetector(
                      onTap: () async {
                        XFile? pickedImage = await editProv.handleImagePicker(context);

                        picture = Image.file(
                          File(pickedImage!.path),
                          fit: BoxFit.cover,
                        );
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
                    Text(
                      '${AppLocalizations.of(context)!.tankType}:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Wrap(
                      children: [
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.freshwater),
                          leading: Radio<bool>(
                            value: true,
                            groupValue: editProv.isFreshWater,
                            onChanged: (bool? value) {
                              editProv.updateIsFreshWater(value!);
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.saltwater),
                          leading: Radio<bool>(
                            value: false,
                            groupValue: editProv.isFreshWater,
                            onChanged: (bool? value) {
                              editProv.updateIsFreshWater(value!);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Spacing.betweenSections,
                    ),
                    Row(
                      children: [
                        Text(
                          '${AppLocalizations.of(context)!.dimensions}:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        // IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _lengthFieldController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.length,
                              errorText: editProv.isLengthValid ? null : '',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.close,
                            size: 15,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _widthFieldController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.width,
                              errorText: editProv.isWidthValid ? null : '',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(
                            Icons.close,
                            size: 15,
                          ),
                        ),
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _heightFieldController,
                            decoration: InputDecoration(
                              labelText: AppLocalizations.of(context)!.height,
                              errorText: editProv.isHeightValid ? null : '',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton<UnitOfLength>(
                          value: editProv.dimDropdownValue,
                          items: [
                            DropdownMenuItem(
                              value: UnitOfLength.cm,
                              child: Text(AppLocalizations.of(context)!.cm),
                            ),
                            DropdownMenuItem(
                              value: UnitOfLength.inch,
                              child: Text(AppLocalizations.of(context)!.inches),
                            ),
                          ],
                          onChanged: (UnitOfLength? value) {
                            editProv.updateDimDropdownValue(value!);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: Spacing.betweenSections,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: FilledButton(
                            onPressed: () async {
                              editProv.nameField = _nameFieldController.text;
                              editProv.length = _lengthFieldController.text.trim();
                              editProv.width = _widthFieldController.text.trim();
                              editProv.height = _heightFieldController.text.trim();
                              editProv.oldImageName = tankProvider.tank.imgName;

                              bool isFormValid = editProv.checkIsFormValid(context);

                              if (isFormValid) {
                                Tank tank =
                                    await editProv.handleEdit(context, tankProvider.tank.docId);

                                tankProvider.tank = tank;
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.update),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
