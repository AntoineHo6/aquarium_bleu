import 'package:aquarium_bleu/enums/units_of_length.dart';

class Dimensions {
  UnitsOfLength unit;
  double depth;
  double height;
  double length;

  Dimensions({
    required this.unit,
    required this.depth,
    required this.height,
    required this.length,
  });

  static Dimensions fromJson(Map<String, dynamic> json) {
    return Dimensions(
      unit: UnitsOfLength.values
          .firstWhere((e) => e.toString() == 'UnitsOfLength.' + json['unit']),
      depth: double.parse(json['depth']),
      height: double.parse(json['height']),
      length: double.parse(json['length']),
    );
  }
}
