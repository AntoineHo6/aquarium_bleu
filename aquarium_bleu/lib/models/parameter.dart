import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Parameter {
  final WaterParamType type;
  final double value;
  final DateTime date;

  Parameter({
    required this.type,
    required this.value,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'type': type.getStr,
        'value': value,
        'date': date,
      };

  static Parameter fromJson(Map<String, dynamic> json) {
    return Parameter(
      type: WaterParamType.values.byName(json['type']),
      value: json['value'].toDouble(),
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
