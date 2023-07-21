import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String id;
  String? rRuleId;
  String title;
  String description;
  DateTime date;
  bool isCompleted;

  Task(
    this.id, {
    required this.rRuleId,
    required this.title,
    required this.description,
    required this.date,
    required this.isCompleted,
  });

  Map<String, dynamic> toJson() => {
        'rRuleId': rRuleId,
        'title': title,
        'description': description,
        'date': date,
        'isCompleted': isCompleted,
      };

  static Task fromJson(String docId, Map<String, dynamic> json) {
    return Task(
      docId,
      rRuleId: json['rRuleId'],
      title: json['title'],
      description: json['description'],
      date: (json['date'] as Timestamp).toDate(),
      isCompleted: json['isCompleted'],
    );
  }
}
