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
    int repeatInterval = int.tryParse(_amountFieldController.value.text) ?? 1;
    int numOfOccurrences = int.tryParse(_numOfOccurrencesFieldController.value.text) ?? 10;

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
              RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.titleMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: _repeat
                          ? '${AppLocalizations.of(context).nextDueDate}: '
                          : '${AppLocalizations.of(context).dueDate}: ',
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
              IconTextBtn(
                iconData: Icons.calendar_today,
                text: StringUtil.formattedDate(context, _nextDueDate),
                onPressed: () => _handleDateBtn(_nextDueDate),
              ),
              IconTextBtn(
                iconData: Icons.schedule,
                text: StringUtil.formattedTime(context, _nextDueTime),
                onPressed: () => _handleTimeBtn(),
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
                              child: Text(AppLocalizations.of(context).nDays(repeatInterval)),
                            ),
                            DropdownMenuItem(
                              value: RepeatFrequency.weekly,
                              child: Text(AppLocalizations.of(context).nWeeks(repeatInterval)),
                            ),
                            DropdownMenuItem(
                              value: RepeatFrequency.monthly,
                              child: Text(AppLocalizations.of(context).nMonths(repeatInterval)),
                            ),
                            DropdownMenuItem(
                              value: RepeatFrequency.yearly,
                              child: Text(AppLocalizations.of(context).nYears(repeatInterval)),
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
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleMedium,
                            children: <TextSpan>[
                              TextSpan(
                                text: '${AppLocalizations.of(context).ends}: ',
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
                        const SizedBox(
                          height: 10,
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
                                    ? () => _handleDateBtn(_lastRepeatDate)
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
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
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(AppLocalizations.of(context).nOccurrences(numOfOccurrences)),
                          ],
                        ),
                      ],
                    )
                  : const SizedBox(),
              const SizedBox(
                height: Spacing.betweenSections,
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
                      onPressed: () async {
                        // _handleAdd();
                      },
                      child: Text(AppLocalizations.of(context).add),
                    ),
                  ),
                ],
              ),
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

  _handleDateBtn(DateTime date) {
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

  _handleTimeBtn() {
    showTimePicker(context: context, initialTime: _nextDueTime).then((value) => {
          setState(() {
            value != null ? _nextDueTime = value : null;
          })
        });
  }

  _handleAdd() {}
}
