import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/task_r_rule.dart';
import 'package:aquarium_bleu/pages/tasks/add_task_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TasksPage extends StatefulWidget {
  const TasksPage({super.key});

  @override
  State<TasksPage> createState() => _TasksPageState();
}

class _TasksPageState extends State<TasksPage> {
  List<Widget> tasks = [];

  @override
  void initState() {
    super.initState();

    _fetchTaskDatesInMonth(DateTime.now().month).then((value) => print(value));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: tasks,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskPage(),
            ),
          );

          // final Iterable<DateTime> instances = rrule.getInstances(
          //   start: DateTime.now().copyWith(isUtc: true),
          // );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Future _fetchTaskDatesInMonth(int month) async {
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    List<TaskRRule> taskRRules = await FirestoreStuff.readTaskRRules(tankProvider.tank.docId);

    Map<DateTime, String> taskDatesInMonth = {};

    for (TaskRRule taskRRule in taskRRules) {
      taskRRule.rRule
          .getInstances(start: taskRRule.startDate.copyWith(isUtc: true))
          .where((element) => element.month == month)
          .forEach((dateTime) {
        taskDatesInMonth[dateTime] = taskRRule.id;
      });
    }

    return taskDatesInMonth;
  }
}
