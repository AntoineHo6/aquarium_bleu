import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/task_r_rule.dart';
import 'package:aquarium_bleu/pages/tasks/add_task_page.dart';
import 'package:aquarium_bleu/pages/tasks/date_picker_calendar_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  DateTime _currentDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tasks),
      ),
      body: FutureBuilder<Map<int, List<String>>>(
          future: FirestoreStuff.fetchTaskDaysInMonth(tankProvider.tank.docId, _currentDate.month),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Text> tasks = [];
              // temp
              snapshot.data!.forEach((day, taskRuleId) => tasks.add(Text(day.toString())));

              return Column(
                children: [
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DatePickerCalendarPage(
                          selectedDate: _currentDate,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_month_outlined),
                    style: const ButtonStyle(),
                  ),
                  Text(StringUtil.formattedDate(context, _currentDate)),
                  const SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: tasks,
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator.adaptive(),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskPage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  // Future<Map<int, List<String>>> _fetchTaskDateTimesInMonth(int month) async {
  //   final tankProvider = Provider.of<TankProvider>(context, listen: false);
  //   List<TaskRRule> taskRRules = await FirestoreStuff.readTaskRRules(tankProvider.tank.docId);

  //   // fetch list of EXTASKS, map<taskRRuleId, List<DateTime>>

  //   Map<int, List<String>> taskDatesInMonth = {};

  //   for (TaskRRule taskRRule in taskRRules) {
  //     taskRRule.rRule
  //         .getInstances(start: taskRRule.startDate.copyWith(isUtc: true))
  //         .where((element) => element.month == month)
  //         .forEach((dateTime) {
  //       // ignore those is EXTASKS
  //       if (taskDatesInMonth[dateTime.day] == null) {
  //         taskDatesInMonth[dateTime.day] = [];
  //       }

  //       taskDatesInMonth[dateTime.day]!.add(taskRRule.id);
  //     });
  //   }

  //   return taskDatesInMonth;
  // }
}
