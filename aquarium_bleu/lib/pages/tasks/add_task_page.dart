import 'package:aquarium_bleu/enums/repeat_end_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/task/task.dart';
import 'package:aquarium_bleu/models/task_r_rule.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:rrule/rrule.dart';
import 'package:uuid/uuid.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  late TextEditingController _titleFieldController;
  late TextEditingController _descFieldController;
  late TextEditingController _repeatEveryFieldController;
  String? _titleErrorText;
  String? _repeatEveryErrorText;
  String? _numOfOccurrencesErrorText;
  bool _repeat = false;
  Frequency _frequency = Frequency.daily;
  final List<bool> _activeDaysOfWeek = [false, true, false, false, false, false, false];
  int numOfActiveDaysOfWeek = 1;
  DateTime _startDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  RepeatEndType _repeatEndType = RepeatEndType.never;
  DateTime _endOnDate = DateTime.now();
  late TextEditingController _numOfOccurrencesFieldController;

  @override
  void initState() {
    super.initState();
    _titleFieldController = TextEditingController();
    _descFieldController = TextEditingController();
    _repeatEveryFieldController = TextEditingController();
    _numOfOccurrencesFieldController = TextEditingController();
  }

  @override
  void dispose() {
    _titleFieldController.dispose();
    _descFieldController.dispose();
    _repeatEveryFieldController.dispose();
    _numOfOccurrencesFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int repeatInterval = int.tryParse(_repeatEveryFieldController.value.text) ?? 1;
    int numOfOccurrences = int.tryParse(_numOfOccurrencesFieldController.value.text) ?? 1;

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
                  errorText: _titleErrorText,
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
                text: StringUtil.formattedDate(context, _startDate),
                onPressed: () => _handleNextDueDateBtn(),
              ),
              IconTextBtn(
                iconData: Icons.schedule,
                text: StringUtil.formattedTime(context, _startTime),
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
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            style: Theme.of(context).textTheme.titleMedium,
                            children: <TextSpan>[
                              TextSpan(text: '${AppLocalizations.of(context).repeatEvery}: '),
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
                        Row(
                          children: [
                            Flexible(
                              child: TextField(
                                controller: _repeatEveryFieldController,
                                keyboardType: TextInputType.number,
                                maxLength: 3,
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  errorText: _repeatEveryErrorText,
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
                                  child: Text(AppLocalizations.of(context).nDays(repeatInterval)),
                                ),
                                DropdownMenuItem(
                                  value: Frequency.weekly,
                                  child: Text(AppLocalizations.of(context).nWeeks(repeatInterval)),
                                ),
                                DropdownMenuItem(
                                  value: Frequency.monthly,
                                  child: Text(AppLocalizations.of(context).nMonths(repeatInterval)),
                                ),
                                DropdownMenuItem(
                                  value: Frequency.yearly,
                                  child: Text(AppLocalizations.of(context).nYears(repeatInterval)),
                                ),
                              ],
                              onChanged: (Frequency? value) {
                                setState(() {
                                  _frequency = value!;
                                });
                              },
                            ),
                          ],
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
                                text: StringUtil.formattedDate(context, _endOnDate),
                                onPressed: _repeatEndType == RepeatEndType.on
                                    ? () => _handleLastRepeatDateBtn()
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
                                decoration: InputDecoration(
                                  border: const OutlineInputBorder(),
                                  errorText: _numOfOccurrencesErrorText,
                                ),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of(context).nOccurrences(numOfOccurrences),
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
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
                        _handleAdd();
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

  _handleNextDueDateBtn() {
    showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((value) => {
          setState(() {
            if (value != null) {
              _startDate = value;
              _endOnDate = _startDate.add(const Duration(days: 7));
            }
          })
        });
  }

  _handleLastRepeatDateBtn() {
    showDatePicker(
      context: context,
      initialDate: _endOnDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    ).then((value) => {
          setState(() {
            value != null ? _endOnDate = value : null;
          })
        });
  }

  _handleTimeBtn() {
    showTimePicker(context: context, initialTime: _startTime).then((value) => {
          setState(() {
            value != null ? _startTime = value : null;
          })
        });
  }

  _handleAdd() async {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    bool isValid = true;

    // check if title is empty
    String title = _titleFieldController.text.trim();
    if (title.isEmpty) {
      isValid = false;
      setState(() {
        _titleErrorText = AppLocalizations.of(context).emptyField;
      });
    } else {
      setState(() {
        _titleErrorText = null;
      });
    }

    if (!_repeat && isValid) {
      Task newTask = Task(
        const Uuid().v4(),
        rRuleId: null,
        title: title,
        description: _descFieldController.text.trim(),
        date: _startDate,
        isCompleted: false,
      );

      await FirestoreStuff.addTask(tankProvider.tank.docId, newTask);
    } else {
      // 2. Check if "repeat every" field is valid
      int? repeatEveryVal = int.tryParse(_repeatEveryFieldController.text.trim());

      if (repeatEveryVal == null) {
        isValid = false;
        _repeatEveryErrorText = AppLocalizations.of(context).theValueIsNotAValidNumber;
      } else {
        setState(() {
          _repeatEveryErrorText = null;
        });
      }

      // 3. validate after n Occurrences
      if (_repeatEndType == RepeatEndType.after) {
        int? numOfOccurrences = int.tryParse(_numOfOccurrencesFieldController.text.trim());

        if (numOfOccurrences == null) {
          isValid = false;
          _numOfOccurrencesErrorText = AppLocalizations.of(context).theValueIsNotAValidNumber;
        } else {
          setState(() {
            _numOfOccurrencesErrorText = null;
          });
        }
      }

      // 4. Create rrule
      if (isValid) {
        DateTime? until;
        int? count;

        if (_repeatEndType == RepeatEndType.on) {
          until = _endOnDate;
        } else if (_repeatEndType == RepeatEndType.after) {
          count = int.parse(_numOfOccurrencesFieldController.text.trim());
        }

        if (_frequency == Frequency.daily) {
          RecurrenceRule rRule = RecurrenceRule(
            frequency: _frequency,
            until: until!.toUtc(),
            count: count,
            interval: int.parse(_repeatEveryFieldController.text.trim()), // temp
          );

          DateTime taskStartDate = DateTime(
            _startDate.year,
            _startDate.month,
            _startDate.day,
            _startTime.hour,
            _startTime.minute,
          );

          TaskRRule taskRRule = TaskRRule(
            const Uuid().v4(),
            title: title,
            description: _descFieldController.text.trim(),
            startDate: taskStartDate,
            rRule: rRule,
          );

          await FirestoreStuff.addTaskRRule(tankProvider.tank.docId, taskRRule);
        }
      }
    }
  }
}
