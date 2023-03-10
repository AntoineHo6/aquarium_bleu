import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/pages/water_param/water_param_picker_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/num_util.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:aquarium_bleu/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class AddParamValAlertDialog extends StatefulWidget {
  final String tankId;
  final List<String> visibleParams;

  const AddParamValAlertDialog(this.tankId, this.visibleParams, {super.key});

  @override
  State<AddParamValAlertDialog> createState() => _AddParamValAlertDialogState();
}

class _AddParamValAlertDialogState extends State<AddParamValAlertDialog> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  late TextEditingController _valueFieldController;
  bool _isValueValid = true;
  String? _errorText;
  String? _param;
  bool isParamBtnInError = false;
  late String _paramBtnText;

  @override
  void initState() {
    super.initState();
    _valueFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _valueFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _param ??= Provider.of<SettingsProvider>(context).lastSelectedParam;
    _setParamBtnText();

    return AlertDialog(
      title: Text(AppLocalizations.of(context).addParameterValue),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            MyTextField(
              controller: _valueFieldController,
              isFieldValid: _isValueValid,
              hintText:
                  "${AppLocalizations.of(context).value} (${AppLocalizations.of(context).required})",
              maxLength: 10,
              errorText: _errorText,
            ),
            Container(
              margin: const EdgeInsets.only(top: Spacing.betweenSections),
              child: IconTextBtn(
                iconData: Icons.science_outlined,
                text: _paramBtnText,
                onPressed: () => _handleParamPickerBtn(context),
                isError: isParamBtnInError,
              ),
            ),
            IconTextBtn(
              iconData: Icons.calendar_today,
              text: StringUtil.formattedDate(context, _date),
              onPressed: () => _handleDateBtn(context),
            ),
            IconTextBtn(
              iconData: Icons.schedule,
              text: StringUtil.formattedTime(context, _time),
              onPressed: () => _handleTimeBtn(context),
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

  _handleParamPickerBtn(BuildContext context) {
    showDialog(
            context: context,
            builder: (BuildContext context) =>
                WaterParamPickerPage(_param, widget.visibleParams))
        .then((value) => setState(() {
              if (value != null) {
                _param = value;
                // _paramBtnText = StringUtil.paramToString(context, value);
                _setParamBtnText();
                isParamBtnInError = false;
              }
              // value != null ? _param = value : null;
            }));
  }

  _handleDateBtn(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((value) => {
          setState(() {
            value != null ? _date = value : null;
          })
        });
  }

  _handleTimeBtn(BuildContext context) {
    showTimePicker(context: context, initialTime: _time).then((value) => {
          setState(() {
            value != null ? _time = value : null;
          })
        });
  }

  void _handleAdd(BuildContext context) {
    String value = _valueFieldController.text.trim();

    if (NumUtil.isNumeric(value) && _param != null) {
      // 1. Combine _date and _time in a DateTime for Parameter object
      DateTime paramDate = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      // 2. Create parameter object
      Parameter addMe = Parameter(
        value: double.parse(value),
        date: paramDate,
      );

      // 3. Add parameter to db
      Provider.of<CloudFirestoreProvider>(context, listen: false).addParameter(
        widget.tankId,
        _param!,
        addMe,
      );

      // 4. Set selected parameter as the last used
      Provider.of<SettingsProvider>(context, listen: false)
          .setLastSelectedParam(_param!);

      Navigator.pop(context);
    }

    // check for value error states
    if (value.isEmpty) {
      setState(() {
        _isValueValid = false;
        _errorText = AppLocalizations.of(context).theValueIsEmpty;
      });
    } else if (!NumUtil.isNumeric(value)) {
      setState(() {
        _isValueValid = false;
        _errorText = AppLocalizations.of(context).theValueIsNotAValidNumber;
      });
    }

    // check for parameter error states
    if (_param == Strings.none) {
      setState(() {
        isParamBtnInError = true;
      });
    }
  }

  void _setParamBtnText() {
    if (_param == Strings.none) {
      _paramBtnText = AppLocalizations.of(context).selectParameter;
    } else {
      _paramBtnText = StringUtil.paramToString(context, _param!);
    }
  }
}

//TODO: handle case when user has ammonia as the last used parameter for ex. and
// decides to not make is visible anymore.

// TODO: allow 24h or am/pm format
