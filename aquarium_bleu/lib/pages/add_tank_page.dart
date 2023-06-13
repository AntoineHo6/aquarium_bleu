import 'dart:io';

import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:aquarium_bleu/firebase_storage_stuff.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/dimensions.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/loading_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AddTankPage extends StatefulWidget {
  const AddTankPage({super.key});

  @override
  State<AddTankPage> createState() => _AddTankPageState();
}

class _AddTankPageState extends State<AddTankPage> {
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
  // String? _widthErrorText;
  // String? _lengthErrorText;
  // String? _heightErrorText;
  UnitOfLength dropdownValue = UnitOfLength.cm;

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
        title: Text(AppLocalizations.of(context).addANewTank),
      ),
      body: Scrollbar(
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
                            text: '${AppLocalizations.of(context).name}: ',
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
                    // labelText: "${AppLocalizations.of(context).name} *",
                    errorText: _isNameValid ? null : _errorText,
                  ),
                ),
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Text(
                  '${AppLocalizations.of(context).displayPicture}:',
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
                            child: picture,
                          ),
                        ),
                ),
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Text(
                  '${AppLocalizations.of(context).tankType}:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Wrap(
                  children: [
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
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Row(
                  children: [
                    Text(
                      "Tank dimensions:",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        controller: _widthFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).width,
                          errorText: _isWidthValid ? null : '',
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
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        controller: _lengthFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).length,
                          errorText: _isLengthValid ? null : '',
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
                        maxLength: 3,
                        keyboardType: TextInputType.number,
                        controller: _heightFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context).height,
                          errorText: _isHeightValid ? null : '',
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    DropdownButton<UnitOfLength>(
                      value: dropdownValue,
                      items: [
                        DropdownMenuItem(
                          value: UnitOfLength.cm,
                          child: Text(AppLocalizations.of(context).cm),
                        ),
                        DropdownMenuItem(
                          value: UnitOfLength.inches,
                          child: Text(AppLocalizations.of(context).inches),
                        ),
                      ],
                      onChanged: (UnitOfLength? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
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
                        child: Text(AppLocalizations.of(context).cancel),
                      ),
                    ),
                    Expanded(
                      flex: 70,
                      child: ElevatedButton(
                        onPressed: () async {
                          _handleAdd();
                        },
                        child: Text(AppLocalizations.of(context).add),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAdd() async {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    String nameModified = _nameFieldController.text.trim().toLowerCase();
    bool hasError = false;
    // Determine the right error message to show for the name.
    // Otherwise, create the tank.
    if (nameModified.isEmpty) {
      hasError = true;
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).emptyName;
      });
    } else if (tankProvider.tankNames.contains(nameModified)) {
      hasError = true;
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context).nameAlreadyExists;
      });
    }

    String width = _widthFieldController.text.trim();
    String length = _lengthFieldController.text.trim();
    String height = _heightFieldController.text.trim();

    if (!StringUtil.isNumeric(width) && width.isNotEmpty) {
      hasError = true;
      _isWidthValid = false;
    } else {
      _isWidthValid = true;
    }
    if (!StringUtil.isNumeric(length) && length.isNotEmpty) {
      hasError = true;
      _isLengthValid = false;
    } else {
      _isLengthValid = true;
    }
    if (!StringUtil.isNumeric(height) && height.isNotEmpty) {
      hasError = true;
      _isHeightValid = false;
    } else {
      _isHeightValid = true;
    }

    if (!hasError) {
      String widthStr = _widthFieldController.text.trim();
      String lengthStr = _lengthFieldController.text.trim();
      String heightStr = _heightFieldController.text.trim();

      Tank tank = Tank(
        const Uuid().v4(),
        name: _nameFieldController.text,
        isFreshwater: _isFreshwater!,
        dimensions: Dimensions(
          unit: dropdownValue,
          width: widthStr.isEmpty ? null : double.parse(_widthFieldController.text.trim()),
          length: lengthStr.isEmpty ? null : double.parse(_lengthFieldController.text.trim()),
          height: heightStr.isEmpty ? null : double.parse(_heightFieldController.text.trim()),
        ),
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
}
