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

  bool isNameValid;
  String? nameErrorText;

  XFile? image;

  bool isWidthValid;
  bool isLengthValid;
  bool isHeightValid;
  UnitOfLength dimDropdownValue;

  EditAddTankProvider({
    this.isFreshWater = true,
    this.isNameValid = true,
    this.isWidthValid = true,
    this.isLengthValid = true,
    this.isHeightValid = true,
    this.dimDropdownValue = UnitOfLength.cm,
  }) {}

  void updateIsFreshWater(bool value) {
    isFreshWater = value;
    notifyListeners();
  }

  void updateImage(XFile? pickedImage) {
    image = pickedImage;
    notifyListeners();
  }

  void updateDimDropdownValue(UnitOfLength value) {
    dimDropdownValue = value;
  }

  Future<void> handleEditAdd(BuildContext context, String nameField, String lengthField,
      String widthField, String heightField,
      {String? docId}) async {
    bool isFormValid = true;
    String name = nameField.trim().toLowerCase();
    String length = lengthField.trim();
    String width = widthField.trim();
    String height = heightField.trim();

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

    if (isFormValid) {
      Tank tank = Tank(
        docId ?? Uuid().v4(),
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
      Navigator.pop(context);
    }
  }
}
