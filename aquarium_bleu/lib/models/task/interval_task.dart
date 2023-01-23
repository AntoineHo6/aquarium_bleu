import 'package:aquarium_bleu/models/task/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class IntervalTask extends Task {
  int interval;
  bool nextTaskCreated = false;

  IntervalTask(
    super.docId, {
    required super.title,
    required super.desc,
    required super.dueDate,
    super.isCompleted,
    required this.interval,
    nextTaskCreated,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'desc': desc,
        'dueDate': dueDate,
        'isCompleted': isCompleted,
        'interval': interval,
        'nextTaskCreated': nextTaskCreated,
      };

  static IntervalTask fromJson(String docId, Map<String, dynamic> json) {
    return IntervalTask(
      docId,
      title: json['title'],
      desc: json['desc'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      isCompleted: json['isCompleted'],
      interval: json['interval'], // prob have to convert
      nextTaskCreated: json['nextTaskCreated'],
    );
  }

  // IntervalTask createNext() {
  //   nextTaskCreated = true;

  //   return IntervalTask(
  //     title: title,
  //     desc: desc,
  //     dueDate: dueDate, // due date + interval
  //     interval: interval,
  //   );
  // }
}
