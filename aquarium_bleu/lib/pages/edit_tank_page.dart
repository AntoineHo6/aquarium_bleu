import 'dart:io';
import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:aquarium_bleu/firebase_storage_stuff.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
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
  late bool? _isFreshwater;
  String? _errorText;
  XFile? image;
  late Widget picture;
  late TextEditingController _widthFieldController;
  late TextEditingController _lengthFieldController;
  late TextEditingController _heightFieldController;
  bool _isWidthValid = true;
  bool _isLengthValid = true;
  bool _isHeightValid = true;
  late UnitOfLength dropdownValue;

  @override
  void initState() {
    super.initState();
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    _nameFieldController = TextEditingController();
    _nameFieldController.value = TextEditingValue(text: tankProvider.tank.name);

    picture = tankProvider.image;

    _isFreshwater = tankProvider.tank.isFreshwater;

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

    dropdownValue = tankProvider.tank.dimensions.unit;
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
                    errorText: _isNameValid ? null : _errorText,
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
                        groupValue: _isFreshwater,
                        onChanged: (bool? value) {
                          setState(() {
                            _isFreshwater = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: Text(AppLocalizations.of(context)!.saltwater),
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
                      '${AppLocalizations.of(context)!.dimensions}:',
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
                        keyboardType: TextInputType.number,
                        controller: _widthFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.width,
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
                        keyboardType: TextInputType.number,
                        controller: _lengthFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.length,
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
                        keyboardType: TextInputType.number,
                        controller: _heightFieldController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)!.height,
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
                          child: Text(AppLocalizations.of(context)!.cm),
                        ),
                        DropdownMenuItem(
                          value: UnitOfLength.inch,
                          child: Text(AppLocalizations.of(context)!.inches),
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
                        child: Text(AppLocalizations.of(context)!.cancel),
                      ),
                    ),
                    Expanded(
                      flex: 70,
                      child: ElevatedButton(
                        onPressed: () {
                          _handleUpdate();
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
      ),
    );
  }

  Future _handleUpdate() async {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    bool hasError = false;
    String name = _nameFieldController.text.trim();
    String nameLowerCase = name.toLowerCase();
    // Determine the right error message to show for the name.
    if (nameLowerCase.isEmpty) {
      hasError = true;
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context)!.emptyField;
      });
    } else if (nameLowerCase != tankProvider.tank.name.toLowerCase() &&
        tankProvider.tankNames.contains(nameLowerCase)) {
      hasError = true;
      setState(() {
        _isNameValid = false;
        _errorText = AppLocalizations.of(context)!.nameAlreadyExists;
      });
    }

    // PROCESS DIMENSIONS
    String widthStr = _widthFieldController.text.trim();
    String lengthStr = _lengthFieldController.text.trim();
    String heightStr = _heightFieldController.text.trim();

    if (!StringUtil.isNumeric(widthStr) && widthStr.isNotEmpty) {
      hasError = true;
      setState(() {
        _isWidthValid = false;
      });
    } else {
      setState(() {
        _isWidthValid = true;
      });
    }
    if (!StringUtil.isNumeric(lengthStr) && lengthStr.isNotEmpty) {
      hasError = true;
      setState(() {
        _isLengthValid = false;
      });
    } else {
      setState(() {
        _isLengthValid = true;
      });
    }
    if (!StringUtil.isNumeric(heightStr) && heightStr.isNotEmpty) {
      hasError = true;
      setState(() {
        _isHeightValid = false;
      });
    } else {
      setState(() {
        _isHeightValid = true;
      });
    }

    if (!hasError) {
      setState(() {
        _isNameValid = true;
      });

      // 1. Overwrite name
      tankProvider.tankNames.remove(tankProvider.tank.name);
      tankProvider.tank.name = name;
      // 2. Overwrite tank type
      tankProvider.tank.isFreshwater = _isFreshwater!;
      // 3. Overwrite dimensions
      tankProvider.tank.dimensions.unit = dropdownValue;
      tankProvider.tank.dimensions.width =
          widthStr.isEmpty ? null : double.parse(_widthFieldController.text.trim());
      tankProvider.tank.dimensions.length =
          lengthStr.isEmpty ? null : double.parse(_lengthFieldController.text.trim());
      tankProvider.tank.dimensions.height =
          heightStr.isEmpty ? null : double.parse(_heightFieldController.text.trim());
      // 4. Overwrite image
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
}
