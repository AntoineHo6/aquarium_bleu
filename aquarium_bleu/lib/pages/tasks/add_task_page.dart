import 'package:aquarium_bleu/enums/repeat_end_type.dart';
import 'package:aquarium_bleu/enums/repeat_frequency.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  RepeatFrequency _frequency = RepeatFrequency.daily;
  final List<bool> _activeDaysOfWeek = [false, true, false, false, false, false, false];
  int numOfActiveDaysOfWeek = 1;
  DateTime _nextDueDate = DateTime.now().toUtc();
  TimeOfDay _nextDueTime = TimeOfDay.now();
  RepeatEndType _repeatEndType = RepeatEndType.never;
  DateTime _lastRepeatDate = DateTime.now().toUtc();
  int _numOfOccurrences = 10;
  late TextEditingController _numOfOccurrencesFieldController;

  @override
  void initState() {
    super.initState();
    _titleFieldController = TextEditingController();
    _descFieldController = TextEditingController();
    _amountFieldController = TextEditingController();
    _numOfOccurrencesFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _titleFieldController.dispose();
    _descFieldController.dispose();
    _amountFieldController.dispose();
    _numOfOccurrencesFieldController.dispose();
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
                text: StringUtil.formattedDate(context, _nextDueDate),
                onPressed: () => _handleDateBtn(context, _nextDueDate),
              ),
              IconTextBtn(
                iconData: Icons.schedule,
                text: StringUtil.formattedTime(context, _nextDueTime),
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
                        DropdownButton<RepeatFrequency>(
                          value: _frequency,
                          items: [
                            DropdownMenuItem(
                              value: RepeatFrequency.daily,
                              child: Text(AppLocalizations.of(context).nDays(amount)),
                            ),
                            DropdownMenuItem(
                              value: RepeatFrequency.weekly,
                              child: Text(AppLocalizations.of(context).nWeeks(amount)),
                            ),
                            DropdownMenuItem(
                              value: RepeatFrequency.monthly,
                              child: Text(AppLocalizations.of(context).nMonths(amount)),
                            ),
                            DropdownMenuItem(
                              value: RepeatFrequency.yearly,
                              child: Text(AppLocalizations.of(context).nYears(amount)),
                            ),
                          ],
                          onChanged: (RepeatFrequency? value) {
                            setState(() {
                              _frequency = value!;
                            });
                          },
                        ),
                      ],
                    )
                  : const SizedBox(),
              _frequency == RepeatFrequency.weekly && _repeat
                  ? Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _populateDayOfWeekChips(),
                      ),
                    )
                  : const SizedBox(),
              _repeat
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context).ends,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        RadioMenuButton<RepeatEndType>(
                          value: RepeatEndType.never,
                          groupValue: _repeatEndType,
                          onChanged: (value) {
                            setState(() {
                              _repeatEndType = value!;
                            });
                          },
                          child: Text(AppLocalizations.of(context).never),
                        ),
                        RadioMenuButton<RepeatEndType>(
                          value: RepeatEndType.on,
                          groupValue: _repeatEndType,
                          onChanged: (value) {
                            setState(() {
                              _repeatEndType = value!;
                            });
                          },
                          child: Row(
                            children: [
                              Text(AppLocalizations.of(context).on),
                              const SizedBox(
                                width: 10,
                              ),
                              IconTextBtn(
                                iconData: Icons.calendar_today,
                                text: StringUtil.formattedDate(context, _lastRepeatDate),
                                onPressed: _repeatEndType == RepeatEndType.on
                                    ? () => _handleDateBtn(context, _lastRepeatDate)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            RadioMenuButton<RepeatEndType>(
                              value: RepeatEndType.after,
                              groupValue: _repeatEndType,
                              onChanged: (value) {
                                setState(() {
                                  _repeatEndType = value!;
                                });
                              },
                              child: Text(AppLocalizations.of(context).after),
                            ),
                            Flexible(
                              child: TextField(
                                enabled: _repeatEndType == RepeatEndType.after ? true : false,
                                controller: _numOfOccurrencesFieldController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
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

  _handleDateBtn(BuildContext context, DateTime date) {
    showDatePicker(
      context: context,
      initialDate: date,
      firstDate: DateTime(2000).toUtc(),
      lastDate: DateTime(2100).toUtc(),
    ).then((value) => {
          setState(() {
            value != null ? date = value : null;
          })
        });
  }

  _handleTimeBtn(BuildContext context) {
    showTimePicker(context: context, initialTime: _nextDueTime).then((value) => {
          setState(() {
            value != null ? _nextDueTime = value : null;
          })
        });
  }
}
