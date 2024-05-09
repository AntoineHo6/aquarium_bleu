import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/pages/wcnp/param_picker_page.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AddParamValAlertDialog extends StatefulWidget {
  final Map<dynamic, dynamic> paramVisibility;

  const AddParamValAlertDialog(this.paramVisibility, {super.key});

  @override
  State<AddParamValAlertDialog> createState() => _AddParamValAlertDialogState();
}

class _AddParamValAlertDialogState extends State<AddParamValAlertDialog> {
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  late TextEditingController _valueFieldController;
  bool _isValueValid = true;
  String? _errorText;
  WaterParamType? _param;
  bool isParamBtnInError = false;
  late String _paramBtnText;

  @override
  void initState() {
    super.initState();
    _valueFieldController = TextEditingController();

    String? lastSelectedParam =
        Provider.of<SettingsProvider>(context, listen: false).lastSelectedParam;

    if (lastSelectedParam != null) {
      _param = WaterParamType.values.byName(lastSelectedParam);
    }
  }

  @override
  void dispose() {
    _valueFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setParamBtnText();

    return AlertDialog(
      title: Text(AppLocalizations.of(context)!.addParameterValue),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              controller: _valueFieldController,
              decoration: InputDecoration(
                hintText:
                    "${AppLocalizations.of(context)!.value} (${AppLocalizations.of(context)!.required})",
                errorText: _isValueValid ? null : _errorText,
              ),
              maxLength: 10,
            ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            IconTextBtn(
              iconData: Icons.science_outlined,
              text: _paramBtnText,
              onPressed: () => _handleParamPickerBtn(),
              isError: isParamBtnInError,
            ),
            IconTextBtn(
              iconData: Icons.calendar_today,
              text: StringUtil.formattedDate(context, _date),
              onPressed: () => _handleDateBtn(),
            ),
            IconTextBtn(
              iconData: Icons.schedule,
              text: StringUtil.formattedTime(context, _time),
              onPressed: () => _handleTimeBtn(),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.add),
          onPressed: () => _handleAdd(),
        ),
      ],
    );
  }

  _handleParamPickerBtn() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParamPickerPage(_param, widget.paramVisibility),
      ),
    ).then((value) => setState(() {
          if (value != null) {
            _param = value;
            _setParamBtnText();
            isParamBtnInError = false;
          }
        }));
  }

  _handleDateBtn() {
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

  _handleTimeBtn() {
    showTimePicker(context: context, initialTime: _time).then((value) => {
          setState(() {
            value != null ? _time = value : null;
          })
        });
  }

  void _handleAdd() {
    String value = _valueFieldController.text.trim();
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    if (StringUtil.isNumeric(value) && _param != null) {
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
        docId: const Uuid().v4(),
        type: _param!,
        value: double.parse(value),
        date: paramDate,
      );

      // 3. Add parameter to db
      FirestoreStuff.addParameter(
        tankProvider.tank.docId,
        addMe,
      );

      // 4. Set selected parameter as the last used
      Provider.of<SettingsProvider>(context, listen: false).setLastSelectedParam(_param!.getStr);

      Navigator.pop(context);
    }

    // check for value error states
    if (value.isEmpty) {
      setState(() {
        _isValueValid = false;
        _errorText = AppLocalizations.of(context)!.theValueIsEmpty;
      });
    } else if (!StringUtil.isNumeric(value)) {
      setState(() {
        _isValueValid = false;
        _errorText = AppLocalizations.of(context)!.theValueIsNotAValidNumber;
      });
    }

    // check for parameter error states
    if (_param == null) {
      setState(() {
        isParamBtnInError = true;
      });
    }
  }

  void _setParamBtnText() {
    if (_param == null) {
      _paramBtnText = AppLocalizations.of(context)!.selectParameter;
    } else {
      _paramBtnText = StringUtil.paramTypeToString(context, _param!);
    }
  }
}

// TODO: allow 24h or am/pm format
