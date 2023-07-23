import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rrule/rrule.dart';

class TaskRRule {
  String id;
  String title;
  String description;
  DateTime startDate;
  RecurrenceRule rRule;

  TaskRRule(
    this.id, {
    required this.title,
    required this.description,
    required this.startDate,
    required this.rRule,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'startDate': startDate,
        'rRule': const RecurrenceRuleStringCodec().encoder.convert(rRule),
      };

  static TaskRRule fromJson(String docId, Map<String, dynamic> json) {
    return TaskRRule(
      docId,
      title: json['title'],
      description: json['description'],
      startDate: (json['startDate'] as Timestamp).toDate().copyWith(isUtc: true),
      rRule: const RecurrenceRuleStringCodec().decoder.convert(json['rRule']),
    );
  }
}
