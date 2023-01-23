import 'package:aquarium_bleu/models/task/interval_task.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/utils/date_time_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TaskCheckListTile extends StatefulWidget {
  final IntervalTask task;
  final String tankDocId;
  const TaskCheckListTile(this.task, this.tankDocId, {super.key});

  @override
  State<TaskCheckListTile> createState() => _TaskCheckListTileState();
}

class _TaskCheckListTileState extends State<TaskCheckListTile> {
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
      subtitle: Text(
          "${AppLocalizations.of(context).due} ${DateTimeUtil.formattedDate(
        context,
        widget.task.dueDate,
      )}. \nRepeat every 7 days dsd sdsadasdasda sda"),
    );
  }
}
