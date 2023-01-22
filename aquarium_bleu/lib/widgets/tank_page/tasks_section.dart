import 'package:flutter/material.dart';

class TasksSection extends StatefulWidget {
  const TasksSection({super.key});

  @override
  State<TasksSection> createState() => _TasksSectionState();
}

class _TasksSectionState extends State<TasksSection> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Colors.amber,
          child: Row(
            children: [
              Text("Tasks"),
              Spacer(),
              TextButton(
                onPressed: () => null,
                child: Text("fuck"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
