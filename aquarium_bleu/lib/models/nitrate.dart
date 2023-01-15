import 'package:aquarium_bleu/enums/units_of_hardness.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Nitrate {
  final UnitsOfHardness unit;
  final double value;
  final DateTime date;

  Nitrate({
    required this.unit,
    required this.value,
    required this.date,
  });

  static Nitrate fromJson(Map<String, dynamic> json) {
    return Nitrate(
      unit: UnitsOfHardness.values
          .firstWhere((e) => e.toString() == 'UnitsOfHardness.${json['unit']}'),
      value: json['value'].toDouble(),
      date: (json['date'] as Timestamp).toDate(),
    );
  }
}
