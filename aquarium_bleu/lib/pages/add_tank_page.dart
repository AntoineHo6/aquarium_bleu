import 'dart:io';

import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:aquarium_bleu/providers/edit_add_tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddTankPage extends StatefulWidget {
  const AddTankPage({super.key});

  @override
  State<AddTankPage> createState() => _AddTankPageState();
}

class _AddTankPageState extends State<AddTankPage> {
  late TextEditingController _nameFieldController;
  late TextEditingController _widthFieldController;
  late TextEditingController _lengthFieldController;
  late TextEditingController _heightFieldController;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addANewTank),
      ),
      body: Consumer<EditAddTankProvider>(
        builder: (context, addProv, child) {
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
                        errorText: addProv.isNameValid ? null : addProv.nameErrorText,
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
                      onTap: () async => await addProv.handleImagePicker(context),
                      child: addProv.image == null
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.15,
                              width: MediaQuery.of(context).size.width * 0.5,
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
                                child: Image.file(
                                  File(addProv.image!.path),
                                  fit: BoxFit.cover,
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
                            groupValue: addProv.isFreshWater,
                            onChanged: (bool? value) {
                              addProv.updateIsFreshWater(value!);
                            },
                          ),
                        ),
                        ListTile(
                          title: Text(AppLocalizations.of(context)!.saltwater),
                          leading: Radio<bool>(
                            value: false,
                            groupValue: addProv.isFreshWater,
                            onChanged: (bool? value) {
                              setState(() {
                                addProv.updateIsFreshWater(value!);
                              });
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
                              errorText: addProv.isLengthValid ? null : '',
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
                              errorText: addProv.isWidthValid ? null : '',
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
                              errorText: addProv.isHeightValid ? null : '',
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton<UnitOfLength>(
                          value: addProv.dimDropdownValue,
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
                            addProv.updateDimDropdownValue(value!);
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
                          flex: 30,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(AppLocalizations.of(context)!.cancel),
                          ),
                        ),
                        Expanded(
                          flex: 70,
                          child: ElevatedButton(
                            onPressed: () async {
                              addProv.nameField = _nameFieldController.text;
                              addProv.length = _lengthFieldController.text.trim();
                              addProv.width = _widthFieldController.text.trim();
                              addProv.height = _heightFieldController.text.trim();

                              bool isFormValid = addProv.checkIsFormValid(context);

                              if (isFormValid) {
                                await addProv.handleAdd(context);
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.add),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
