import 'package:cloud_firestore/cloud_firestore.dart';

class Parameter {
  final double value;
  final DateTime date;

  Parameter({
    required this.value,
    required this.date,
  });

  static Parameter fromJson(Map<String, dynamic> json) {
    return Parameter(
      value: json['value'].toDouble(),
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
