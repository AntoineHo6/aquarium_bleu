import 'package:aquarium_bleu/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskWeekdays extends Task {
  List days;

  TaskWeekdays({
    required super.title,
    required super.description,
    required super.dueDate,
    required this.days,
  });

  static Task fromJson(Map<String, dynamic> json) {
    return TaskWeekdays(
      title: json['title'],
      description: json['description'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      days: json['days'], // dunno if this works
    );
  }
}
