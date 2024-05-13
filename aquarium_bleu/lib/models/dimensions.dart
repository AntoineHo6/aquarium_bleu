import 'package:aquarium_bleu/enums/unit_of_length.dart';

class Dimensions {
  UnitOfLength unit;
  double? width;
  double? length;
  double? height;

  Dimensions({
    required this.unit,
    this.width,
    this.length,
    this.height,
  });

  static Dimensions fromJson(Map<String, dynamic> json) {
    return Dimensions(
      unit: UnitOfLength.values[json['unit']],
      width: json['width']?.toDouble(),
      length: json['length']?.toDouble(),
      height: json['height']?.toDouble(),
    );
  }
}
