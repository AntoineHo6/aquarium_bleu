import 'package:aquarium_bleu/models/task/interval_task.dart';
import 'package:aquarium_bleu/widgets/task_check_list_tile.dart';
import 'package:flutter/material.dart';

class TasksSection extends StatefulWidget {
  final List<IntervalTask> intervalTasks;
  final String tankDocId;

  const TasksSection({
    super.key,
    required this.intervalTasks,
    required this.tankDocId,
  });

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Text(
                "Tasks",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              TextButton(
                onPressed: () => null,
                child: Text("View all"),
              ),
            ],
          ),
        ),
        for (var intervalTask in widget.intervalTasks)
          TaskCheckListTile(intervalTask, widget.tankDocId),
      ],
    );
  }
}
