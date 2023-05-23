import 'package:cloud_firestore/cloud_firestore.dart';

class WaterChange {
  final String docId;
  final DateTime date;

  WaterChange({
    required this.docId,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
      };

  static WaterChange fromJson(String docId, Map<String, dynamic> json) {
    return WaterChange(
      docId: docId,
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
