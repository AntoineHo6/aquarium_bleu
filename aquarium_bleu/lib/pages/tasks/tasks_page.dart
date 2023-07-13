import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/task/task.dart';
import 'package:aquarium_bleu/models/task_r_rule.dart';
import 'package:aquarium_bleu/pages/tasks/add_task_page.dart';
import 'package:aquarium_bleu/pages/tasks/date_picker_calendar_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/date_util.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/colored_dot.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  late List<int> _currentDays = [];
  DateTime _currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    int numDays = DateUtil.getMonthDays(_currentDate);
    _currentDays = List<int>.generate(numDays, (i) => i + 1);
  }

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

              List<Widget> headerDayTiles = [];
              for (int day in _currentDays) {
                List<Widget> taskDots = [];
                if (snapshot.data!.containsKey(day)) {
                  int numTasks = snapshot.data![day]!.length;

                  if (numTasks >= 1) {
                    taskDots.add(const ColoredDot(color: Colors.amber));
                  }
                  if (numTasks >= 2) {
                    taskDots.add(const ColoredDot(color: Colors.amber));
                  }
                  if (numTasks >= 3) {
                    taskDots.add(const ColoredDot(color: Colors.amber));
                  }
                }
                headerDayTiles.add(
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = DateTime(_currentDate.year, _currentDate.month, day);
                      });
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.2,
                      height: MediaQuery.of(context).size.height * 0.125,
                      child: Card(
                        elevation: _currentDate.day == day ? 15 : 1,
                        child: Column(
                          children: [
                            Text(
                              day.toString(),
                              style: Theme.of(context).textTheme.headlineLarge,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: taskDots,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }

              List<Widget> currentDateTasks = [];

              if (snapshot.data!.containsKey(_currentDate.day)) {
                for (String taskId in snapshot.data![_currentDate.day]!) {}
              }

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
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: headerDayTiles,
                    ),
                  ),
                  FutureBuilder(
                    future: FirestoreStuff.fetchTask(tankProvider.tank.docId, snapshot.data![_currentDate.day]!.first, _currentDate),
                    builder: (BuildContext context, taskSnapshot) {
                    if (taskSnapshot.hasData) {
                      return Text(taskSnapshot.data!.description);
                    }
                    else {
                      return Text('dasd');
                    }
                  }),
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
}
