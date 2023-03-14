import 'package:cloud_firestore/cloud_firestore.dart';

class Parameter {
  final String type;
  final double value;
  final DateTime date;

  Parameter({
    required this.type,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'type': type,
        'value': value,
        'date': date,
      };

  static Parameter fromJson(Map<String, dynamic> json) {
    return Parameter(
      type: json['type'].toString(),
      value: json['value'].toDouble(),
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
