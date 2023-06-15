import 'package:aquarium_bleu/pages/tasks/add_task_page.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

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
          final rrule = RecurrenceRule(
            frequency: Frequency.daily,
            byHours: const {15},
            byWeekDays: {
              ByWeekDayEntry(DateTime.tuesday),
              ByWeekDayEntry(DateTime.thursday),
            },
          );

          final Iterable<DateTime> instances = rrule.getInstances(
            start: DateTime.now().copyWith(isUtc: true),
          );

          // final onlyThisMonth = instances.takeWhile(
          //   (instance) => instance.month == DateTime.now().month,
          // );

          // for (DateTime date in onlyThisMonth) {
          //   tasks.add(Text(date.toString()));
          // }

          // setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
