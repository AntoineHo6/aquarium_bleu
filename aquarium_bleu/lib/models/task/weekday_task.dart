import 'package:aquarium_bleu/models/task/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WeekDayTask extends Task {
  List days;
  bool nextTaskCreated = false;

  WeekDayTask(
    super.docId, {
    required super.title,
    required super.desc,
    required super.dueDate,
    required this.days,
  });

  static WeekDayTask fromJson(String docId, Map<String, dynamic> json) {
    return WeekDayTask(
      docId,
      title: json['title'],
      desc: json['desc'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      days: json['days'], // dunno if this works
    );
  }
}
