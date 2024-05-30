import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:aquarium_bleu/firebase_storage_stuff.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/dimensions.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/loading_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class EditAddTankProvider with ChangeNotifier {
  bool isFreshWater;

  String nameField;
  bool isNameValid;
  String? nameErrorText;

  String? oldImageName;
  XFile? image;
  Widget? picture;

  String length;
  String width;
  String height;

  bool isWidthValid;
  bool isLengthValid;
  bool isHeightValid;
  UnitOfLength dimDropdownValue;

  EditAddTankProvider({
    this.nameField = '',
    this.oldImageName,
    this.isFreshWater = true,
    this.length = '',
    this.width = '',
    this.height = '',
    this.isNameValid = true,
    this.isLengthValid = true,
    this.isWidthValid = true,
    this.isHeightValid = true,
    this.dimDropdownValue = UnitOfLength.cm,
  }) {}

  void updateIsFreshWater(bool value) {
    isFreshWater = value;
    notifyListeners();
  }

  void updateDimDropdownValue(UnitOfLength value) {
    dimDropdownValue = value;
    notifyListeners();
  }

  Future<XFile?> handleImagePicker(BuildContext context) async {
    final ImagePicker picker = ImagePicker();

    XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      image = pickedImage;
    } else {
      SnackBar snackBar = SnackBar(
        content: Text(AppLocalizations.of(context)!.noImageSelected),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    notifyListeners();
    return pickedImage;
  }

  bool checkIsFormValid(BuildContext context) {
    bool isFormValid = true;
    String name = nameField.trim().toLowerCase();

    if (name.isEmpty) {
      isFormValid = false;
      isNameValid = false;
      nameErrorText = AppLocalizations.of(context)!.emptyField;
    }

    if (!StringUtil.isNumeric(length) && length.isNotEmpty) {
      isFormValid = false;
      isLengthValid = false;
    } else {
      isLengthValid = true;
    }

    if (!StringUtil.isNumeric(width) && width.isNotEmpty) {
      isFormValid = false;
      isWidthValid = false;
    } else {
      isWidthValid = true;
    }

    if (!StringUtil.isNumeric(height) && height.isNotEmpty) {
      isFormValid = false;
      isHeightValid = false;
    } else {
      isHeightValid = true;
    }

    notifyListeners();
    return isFormValid;
  }

  Future<Tank> handleAdd(BuildContext context) async {
    Tank tank = Tank(
      Uuid().v4(),
      name: nameField,
      isFreshwater: isFreshWater,
      dimensions: Dimensions(
        unit: dimDropdownValue,
        width: width.isEmpty ? null : double.parse(width),
        length: length.isEmpty ? null : double.parse(length),
        height: height.isEmpty ? null : double.parse(height),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => const LoadingAlertDialog());

    if (image != null) {
      tank.imgName = const Uuid().v4();
      await FirebaseStorageStuff.uploadImg(tank.imgName!, image!.path);
    }

    await FirestoreStuff.addTank(tank);

    Navigator.pop(context);
    Navigator.pop(context, true);

    return tank;
  }

  Future<Tank> handleEdit(BuildContext context, String docId) async {
    Tank tank = Tank(
      docId,
      name: nameField,
      isFreshwater: isFreshWater,
      dimensions: Dimensions(
        unit: dimDropdownValue,
        width: width.isEmpty ? null : double.parse(width),
        length: length.isEmpty ? null : double.parse(length),
        height: height.isEmpty ? null : double.parse(height),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => const LoadingAlertDialog());

    if (image != null) {
      // delete old image
      if (oldImageName != null) {
        await FirebaseStorageStuff.deleteImg(oldImageName!);
      }

      tank.imgName = const Uuid().v4();
      await FirebaseStorageStuff.uploadImg(tank.imgName!, image!.path);
    }

    await FirestoreStuff.updateTank(tank);

    Navigator.pop(context);
    Navigator.pop(context, true);

    return tank;
  }
}
