import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/main.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:aquarium_bleu/widgets/confirm_alert_dialog.dart';
import 'package:aquarium_bleu/widgets/toasts/removed_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class EditParamPage extends StatefulWidget {
  final Parameter dataPoint;
  const EditParamPage(this.dataPoint, {super.key});

  @override
  State<EditParamPage> createState() => _EditParamPageState();
}

class _EditParamPageState extends State<EditParamPage> {
  late FToast fToast;
  late TextEditingController _valueFieldController;
  bool _isValueValid = true;
  String? _errorText;
  late DateTime _date;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(navigatorKey.currentContext!);

    _valueFieldController = TextEditingController();
    _valueFieldController.value = TextEditingValue(text: widget.dataPoint.value.toString());
    _date = widget.dataPoint.date;
    _time = TimeOfDay.fromDateTime(widget.dataPoint.date);
  }

  @override
  void dispose() {
    _valueFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String tankId = Provider.of<TankProvider>(context, listen: false).tank.docId;

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => ConfirmAlertDialog(
                title: Text(AppLocalizations.of(context)!.confirm),
                content: Text(AppLocalizations.of(context)!.confirmDeleteX('')),
                onConfirm: () async {
                  await FirestoreStuff.deleteParam(tankId, widget.dataPoint).then((value) {
                    _showToast(RemovedToast());
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                },
              ),
            ),
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.screenEdgePadding),
        child: Column(
          children: [
            TextField(
              controller: _valueFieldController,
              decoration: InputDecoration(
                labelText:
                    "${AppLocalizations.of(context)!.value} (${AppLocalizations.of(context)!.required})",
                errorText: _isValueValid ? null : _errorText,
              ),
              maxLength: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                  child: IconTextBtn(
                    iconData: Icons.edit_calendar,
                    text: StringUtil.formattedDate(context, _date),
                    onPressed: _handleDatePicker,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: IconTextBtn(
                    iconData: Icons.schedule,
                    text: StringUtil.formattedTime(context, _time),
                    onPressed: () => _handleTimeBtn(),
                  ),
                ),
              ],
            ),
            // IconTextBtn(
            //   iconData: Icons.edit_calendar,
            //   text: StringUtil.formattedDate(context, _date),
            //   onPressed: _handleDatePicker,
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // IconTextBtn(
            //   iconData: Icons.schedule,
            //   text: StringUtil.formattedTime(context, _time),
            //   onPressed: () => _handleTimeBtn(),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Row(
              children: [
                Expanded(
                  flex: 70,
                  child: FilledButton(
                    onPressed: () => _handleUpdate(tankId),
                    child: Text(AppLocalizations.of(context)!.update),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleUpdate(String tankId) {
    String value = _valueFieldController.text.trim();

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
    } else {
      DateTime paramDate = DateTime(
        _date.year,
        _date.month,
        _date.day,
        _time.hour,
        _time.minute,
      );

      widget.dataPoint.date = paramDate;
      widget.dataPoint.value = double.parse(value);
      FirestoreStuff.updateParam(tankId, widget.dataPoint).then((value) => Navigator.pop(context));
    }
  }

  void _handleDatePicker() {
    showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((newDate) async {
      if (newDate != null) {
        setState(() {
          _date = newDate;
        });
      }
    });
  }

  _handleTimeBtn() {
    showTimePicker(context: context, initialTime: _time).then((value) => {
          setState(() {
            value != null ? _time = value : null;
          })
        });
  }

  _showToast(Widget toast) {
    fToast.showToast(
      child: toast,
    );
  }
}
