import 'package:rrule/rrule.dart';

abstract class Task {
  String docId;
  String title;
  String desc;
  RecurrenceRule rRule;
  // notify

  Task(
    this.docId, {
    required this.title,
    required this.desc,
    required this.rRule,
  });
}
