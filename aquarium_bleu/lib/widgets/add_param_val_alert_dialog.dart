import 'package:aquarium_bleu/pages/water_param/add_water_param_page.dart';
import 'package:aquarium_bleu/widgets/date_picker_btn.dart';
import 'package:aquarium_bleu/widgets/my_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddParamValAlertDialog extends StatefulWidget {
  const AddParamValAlertDialog({super.key});

  @override
  State<AddParamValAlertDialog> createState() => _AddParamValAlertDialogState();
}

class _AddParamValAlertDialogState extends State<AddParamValAlertDialog> {
  DateTime _date = DateTime.now();
  late TextEditingController _valueFieldController;
  bool _isValueValid = true;
  String? _errorText;
  String _param = 'ammonia'; // TODO: make this the last param added

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

  void _handleAdd(BuildContext context) {
    String value = _valueFieldController.text.trim();
    if (_isNumeric(value)) {
      // is valid
    } else if (value.isEmpty) {
      setState(() {
        _isValueValid = false;
        _errorText = AppLocalizations.of(context).theValueIsEmpty;
      });
    } else {
      setState(() {
        _isValueValid = false;
        _errorText = AppLocalizations.of(context).theValueIsNotAValidNumber;
      });
    }
  }

  bool _isNumeric(String? s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        AppLocalizations.of(context).addParameterValue,
      ),
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
            ElevatedButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => const WaterParamPickerPage(),
              ),
              child: Text(_param),
            ),
            DatePickerBtn(
              date: _date,
              onPressed: () => {
                showDatePicker(
                  context: context,
                  initialDate: _date,
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                ).then((value) => {
                      setState(() {
                        value != null ? _date = value : null;
                      })
                    })
              },
            )
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
}
