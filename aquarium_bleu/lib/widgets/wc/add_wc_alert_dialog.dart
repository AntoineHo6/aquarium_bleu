import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

class AddWcAlertDialog extends StatefulWidget {
  final String tankId;
  final DateTime focusedDate;

  const AddWcAlertDialog({required this.tankId, required this.focusedDate, super.key});

  @override
  State<AddWcAlertDialog> createState() => _AddWcAlertDialogState();
}

class _AddWcAlertDialogState extends State<AddWcAlertDialog> {
  late DateTime _date;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _date = widget.focusedDate;
    _time = TimeOfDay.now();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: Text(AppLocalizations.of(context)!.addWaterChange),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
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
          child: Text(AppLocalizations.of(context)!.cancel),
          onPressed: () => Navigator.pop(context),
        ),
        TextButton(
          child: Text(AppLocalizations.of(context)!.add),
          onPressed: () => _handleAdd(context),
        ),
      ],
    );
  }

  void _handleAdd(BuildContext context) {
    DateTime dateTime = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );

    WaterChange waterChange = WaterChange(docId: const Uuid().v4(), date: dateTime);

    FirestoreStuff.addWaterChange(
      widget.tankId,
      waterChange,
    );

    Navigator.pop(context, true);
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
}
