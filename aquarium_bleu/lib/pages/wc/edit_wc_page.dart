import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:aquarium_bleu/widgets/confirm_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EditWcPage extends StatefulWidget {
  final WaterChange wc;
  const EditWcPage(this.wc, {super.key});

  @override
  State<EditWcPage> createState() => _EditWcPageState();
}

class _EditWcPageState extends State<EditWcPage> {
  late DateTime _date;
  late TimeOfDay _time;

  @override
  void initState() {
    super.initState();
    _date = widget.wc.date;
    _time = TimeOfDay.fromDateTime(widget.wc.date);
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
                  await FirestoreStuff.deleteWc(tankId, widget.wc.docId).then((value) {
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
            IconTextBtn(
              iconData: Icons.edit_calendar,
              text: StringUtil.formattedDate(context, _date),
              onPressed: _handleDatePicker,
            ),
            const SizedBox(
              height: 10,
            ),
            IconTextBtn(
              iconData: Icons.schedule,
              text: StringUtil.formattedTime(context, _time),
              onPressed: () => _handleTimeBtn(),
            ),
            const SizedBox(
              height: 10,
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
    DateTime newWcDate = DateTime(
      _date.year,
      _date.month,
      _date.day,
      _time.hour,
      _time.minute,
    );

    widget.wc.date = newWcDate;
    FirestoreStuff.updateWc(tankId, widget.wc).then((value) => Navigator.pop(context));
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
}
