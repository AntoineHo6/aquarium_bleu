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
}
