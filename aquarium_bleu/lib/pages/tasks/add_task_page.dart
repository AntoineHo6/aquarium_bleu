import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rrule/rrule.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TextEditingController _titleFieldController;
  late TextEditingController _descFieldController;
  late TextEditingController _amountFieldController;
  bool _repeat = false;
  Frequency _frequency = Frequency.daily;
  final List<bool> _activeDaysOfWeek = [false, true, false, false, false, false, false];
  int numOfActiveDaysOfWeek = 1;
  DateTime _date = DateTime.now().toUtc();
  TimeOfDay _time = TimeOfDay.now();

  @override
  void initState() {
    super.initState();
    _titleFieldController = TextEditingController();
    _descFieldController = TextEditingController();
    _amountFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _titleFieldController.dispose();
    _descFieldController.dispose();
    _amountFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int amount = int.tryParse(_amountFieldController.value.text) ?? 1;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.screenEdgePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                maxLength: 50,
                controller: _titleFieldController,
                decoration: InputDecoration(
                  label: RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.titleMedium,
                      children: <TextSpan>[
                        TextSpan(
                          text: '${AppLocalizations.of(context).title}: ',
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
                ),
              ),
              const SizedBox(
                height: Spacing.betweenSections,
              ),
              Text(
                '${AppLocalizations.of(context).description}:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              TextField(
                controller: _descFieldController,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: Spacing.betweenSections,
              ),
              Text(
                _repeat
                    ? '${AppLocalizations.of(context).nextDueDate}:'
                    : '${AppLocalizations.of(context).dueDate}:',
                style: Theme.of(context).textTheme.titleMedium,
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
              const SizedBox(
                height: Spacing.betweenSections,
              ),
              Row(
                children: [
                  RadioMenuButton(
                    value: true,
                    groupValue: _repeat,
                    onChanged: (bool? value) {
                      setState(() {
                        _repeat = value!;
                      });
                    },
                    child: Text(AppLocalizations.of(context).repeat),
                  ),
                  RadioMenuButton(
                    value: false,
                    groupValue: _repeat,
                    onChanged: (bool? value) {
                      setState(() {
                        _repeat = value!;
                      });
                    },
                    child: Text(AppLocalizations.of(context).doNotRepeat),
                  ),
                ],
              ),
              _repeat
                  ? Row(
                      children: [
                        Text(AppLocalizations.of(context).repeatEvery),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: TextField(
                            controller: _amountFieldController,
                            keyboardType: TextInputType.number,
                            maxLength: 3,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        DropdownButton<Frequency>(
                          value: _frequency,
                          items: [
                            DropdownMenuItem(
                              value: Frequency.daily,
                              child: Text(AppLocalizations.of(context).nDays(amount)),
                            ),
                            DropdownMenuItem(
                              value: Frequency.weekly,
                              child: Text(AppLocalizations.of(context).nWeeks(amount)),
                            ),
                            DropdownMenuItem(
                              value: Frequency.monthly,
                              child: Text(AppLocalizations.of(context).nMonths(amount)),
                            ),
                            DropdownMenuItem(
                              value: Frequency.yearly,
                              child: Text(AppLocalizations.of(context).nYears(amount)),
                            ),
                          ],
                          onChanged: (Frequency? value) {
                            setState(() {
                              _frequency = value!;
                            });
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
              _frequency == Frequency.weekly && _repeat
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _populateDayOfWeekChips(),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _populateDayOfWeekChips() {
    var daysLetters = [
      AppLocalizations.of(context).sundayLetter,
      AppLocalizations.of(context).mondayLetter,
      AppLocalizations.of(context).tuesdayLetter,
      AppLocalizations.of(context).wednesdayLetter,
      AppLocalizations.of(context).thursdayLetter,
      AppLocalizations.of(context).fridayLetter,
      AppLocalizations.of(context).saturdayLetter,
    ];

    List<Widget> chips = [];

    for (var i = 0; i < 7; i++) {
      chips.add(
        Flexible(
          child: InputChip(
            showCheckmark: false,
            label: Text(daysLetters[i]),
            shape: const CircleBorder(),
            selected: _activeDaysOfWeek[i],
            onSelected: (isActive) {
              setState(() {
                if (isActive) {
                  _activeDaysOfWeek[i] = isActive;
                  numOfActiveDaysOfWeek++;
                } else if (!isActive && numOfActiveDaysOfWeek > 1) {
                  _activeDaysOfWeek[i] = isActive;
                  numOfActiveDaysOfWeek--;
                }
              });
            },
          ),
        ),
      );
    }

    return chips;
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
