import 'package:aquarium_bleu/models/task/task.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UniqueTask extends Task {
  UniqueTask(
    super.docId, {
    required super.title,
    required super.desc,
    required super.dueDate,
  });

  static UniqueTask fromJson(String docId, Map<String, dynamic> json) {
    return UniqueTask(
      docId,
      title: json['title'],
      desc: json['desc'],
      dueDate: (json['dueDate'] as Timestamp).toDate(),
    );
  }
}
