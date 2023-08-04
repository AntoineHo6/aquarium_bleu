import 'package:aquarium_bleu/enums/repeat_end_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rrule/rrule.dart';

class TaskRRule {
  String id;
  String title;
  String description;
  DateTime startDate;
  RecurrenceRule rRule;
  RepeatEndType repeatEndType;

  TaskRRule(
    this.id, {
    required this.title,
    required this.description,
    required this.startDate,
    required this.rRule,
    required this.repeatEndType,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'startDate': startDate.toUtc(),
        'rRule': const RecurrenceRuleStringCodec().encoder.convert(rRule),
        'repeatEndType': repeatEndType.getStr,
      };

  static TaskRRule fromJson(String docId, Map<String, dynamic> json) {
    return TaskRRule(
      docId,
      title: json['title'],
      description: json['description'],
      startDate: (json['startDate'] as Timestamp).toDate(),
      rRule: const RecurrenceRuleStringCodec().decoder.convert(json['rRule']),
      repeatEndType: RepeatEndType.values
          .firstWhere((e) => e.toString() == 'RepeatEndType.${json['repeatEndType']}'),
    );
  }
}
