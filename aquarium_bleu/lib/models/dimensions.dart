import 'package:aquarium_bleu/enums/units_of_length.dart';

class Dimensions {
  UnitsOfLength unit;
  double width;
  double length;
  double height;

  Dimensions({
    required this.unit,
    required this.width,
    required this.length,
    required this.height,
  });

  static Dimensions fromJson(Map<String, dynamic> json) {
    return Dimensions(
      unit: UnitsOfLength.values.firstWhere((e) => e.toString() == 'UnitsOfLength.${json['unit']}'),
      width: (json['width']).toDouble(),
      length: json['length'].toDouble(),
      height: json['height'].toDouble(),
    );
  }
}
