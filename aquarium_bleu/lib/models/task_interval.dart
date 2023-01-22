import 'package:aquarium_bleu/models/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TaskInterval extends Task {
  int length;

  TaskInterval({
    required super.title,
    required super.description,
    required super.dueDate,
    required this.length,
  });

  static Task fromJson(Map<String, dynamic> json) {
    return TaskInterval(
      title: json['title'],
      description: json['description'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
      length: json['length'], // prob have to convert
    );
  }
}
