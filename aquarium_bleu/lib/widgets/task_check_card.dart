import 'package:aquarium_bleu/models/task/interval_task.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TaskCheckCard extends StatefulWidget {
  final IntervalTask task;
  final String tankDocId;
  const TaskCheckCard(this.task, this.tankDocId, {super.key});

  @override
  State<TaskCheckCard> createState() => _TaskCheckCardState();
}

class _TaskCheckCardState extends State<TaskCheckCard> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        shape: const CircleBorder(),
        value: widget.task.isCompleted,
        onChanged: (bool? value) {
          setState(() {
            widget.task.isCompleted = value!;
            context
                .read<CloudFirestoreProvider>()
                .updateIntervalTask(widget.task, widget.tankDocId);
          });
        },
      ),
      title: widget.task.isCompleted
          ? Text(widget.task.title,
              style: const TextStyle(
                decoration: TextDecoration.lineThrough,
                color: Colors.grey,
              ))
          : Text(widget.task.title),
      trailing: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth / 3,
            child: Text(
              widget.task.desc,
              overflow: TextOverflow.ellipsis,
            ),
          );
        },
      ),
      subtitle: Text(widget.task.dueDate.toString()),
    );
  }
}
