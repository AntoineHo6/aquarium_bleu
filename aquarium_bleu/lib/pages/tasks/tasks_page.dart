import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/pages/tasks/add_task_page.dart';
import 'package:aquarium_bleu/pages/tasks/date_picker_calendar_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
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
  late ScrollController _scrollController;
  late List<int> _currentDays = [];
  late DateTime _currentDate;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    _currentDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);

    int numDays = DateUtil.getMonthDays(_currentDate);
    _currentDays = List<int>.generate(numDays, (i) => i + 1);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _scrollController = ScrollController(
        initialScrollOffset:
            (MediaQuery.of(context).size.width * 0.2) * (_currentDate.day - 3));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tasks),
      ),
      body: FutureBuilder<Map<int, List<String>>>(
          future: FirestoreStuff.fetchTaskDaysInMonth(
              tankProvider.tank.docId, _currentDate),
          builder: (BuildContext context, snapshot) {
            if (snapshot.hasData) {
              List<Text> tasks = [];
              // temp
              snapshot.data!.forEach(
                  (day, taskRuleId) => tasks.add(Text(day.toString())));

              List<Widget> headerDayTiles = [];
              for (int day in _currentDays) {
                List<Widget> taskDots = [];
                if (snapshot.data!.containsKey(day)) {
                  int numTasks = snapshot.data![day]!.length;

                  if (numTasks >= 1) {
                    taskDots.add(const ColoredDot(color: Colors.lightBlue));
                  }
                  if (numTasks >= 2) {
                    taskDots.add(const SizedBox(
                      width: 3,
                    ));
                    taskDots.add(const ColoredDot(color: Colors.lightBlue));
                  }
                  if (numTasks >= 3) {
                    taskDots.add(const SizedBox(
                      width: 3,
                    ));
                    taskDots.add(const ColoredDot(color: Colors.lightBlue));
                  }
                }
                headerDayTiles.add(
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentDate = DateTime(
                            _currentDate.year, _currentDate.month, day);

                        _scrollController.animateTo(
                          (MediaQuery.of(context).size.width * 0.2) *
                              (_currentDate.day - 3),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
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
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: headerDayTiles,
                    ),
                  ),
                  FutureBuilder(
                    future: FirestoreStuff.fetchTasksInDay(
                        tankProvider.tank.docId,
                        snapshot.data![_currentDate.day]!,
                        _currentDate),
                    builder: (BuildContext context, tasksSnapshot) {
                      if (tasksSnapshot.hasData) {
                        return Column(
                          children: tasksSnapshot.data!
                              .map((task) => ElevatedButton(
                                    onPressed: () async {
                                      await FirestoreStuff.removeTask(
                                          tankProvider.tank.docId, task);
                                    },
                                    child: Text(task.title),
                                  ))
                              .toList(),
                        );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator.adaptive(),
                        );
                      }
                    },
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
}
