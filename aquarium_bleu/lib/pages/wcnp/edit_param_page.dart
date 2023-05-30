import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/num_util.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:aquarium_bleu/widgets/water_param/confirm_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class EditParamPage extends StatefulWidget {
  final Parameter dataPoint;
  const EditParamPage(this.dataPoint, {super.key});

  @override
  State<EditParamPage> createState() => _EditParamPageState();
}

class _EditParamPageState extends State<EditParamPage> {
  late TextEditingController _valueFieldController;
  bool _isValueValid = true;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _valueFieldController = TextEditingController();
    _valueFieldController.value = TextEditingValue(text: widget.dataPoint.value.toString());
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
                title: Text(AppLocalizations.of(context).confirm),
                content: Text(AppLocalizations.of(context).areUSureDelete),
                onConfirm: () async {
                  await FirestoreStuff.deleteParam(tankId, widget.dataPoint).then((value) {
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
                    "${AppLocalizations.of(context).value} (${AppLocalizations.of(context).required})",
                errorText: _isValueValid ? null : _errorText,
              ),
              maxLength: 50,
            ),
            const SizedBox(
              height: 10,
            ),
            IconTextBtn(
                iconData: Icons.edit_calendar,
                text: StringUtil.formattedDate(context, widget.dataPoint.date),
                onPressed: _handleDatePicker),
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
                    child: Text(AppLocalizations.of(context).cancel),
                  ),
                ),
                Expanded(
                  flex: 70,
                  child: ElevatedButton(
                    onPressed: () => _handleUpdate(tankId),
                    child: Text(AppLocalizations.of(context).update),
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
        _errorText = AppLocalizations.of(context).theValueIsEmpty;
      });
    } else if (!NumUtil.isNumeric(value)) {
      setState(() {
        _isValueValid = false;
        _errorText = AppLocalizations.of(context).theValueIsNotAValidNumber;
      });
    } else {
      widget.dataPoint.value = double.parse(value);
      FirestoreStuff.updateParam(tankId, widget.dataPoint).then((value) => Navigator.pop(context));
    }
  }

  void _handleDatePicker() {
    showDatePicker(
      context: context,
      initialDate: widget.dataPoint.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((newDate) async {
      if (newDate != null) {
        setState(() {
          widget.dataPoint.date = newDate;
        });
      }
    });
  }
}
