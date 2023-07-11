import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String title;
  String description;
  DateTime dueDate;

  Task(
    this.id, {
    required this.title,
    required this.description,
    required this.dueDate,
  });

  static Task fromJson(String docId, Map<String, dynamic> json) {
    return Task(
      docId,
      title: json['title'],
      description: json['description'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
    );
  }
}
