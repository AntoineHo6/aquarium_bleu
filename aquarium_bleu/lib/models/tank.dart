import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:aquarium_bleu/models/dimensions.dart';

class Tank {
  final String docId;
  String name;
  bool isFreshwater;
  String? imgName;
  Dimensions dimensions;

  Tank(
    this.docId, {
    required this.name,
    required this.isFreshwater,
    this.imgName,
    required this.dimensions,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'isFreshwater': isFreshwater,
        'imgName': imgName,
        'dimensions': {
          'unit': dimensions.unit.unitStr,
          'width': dimensions.width,
          'length': dimensions.length,
          'height': dimensions.height,
        },
      };

  static Tank fromJson(String docId, Map<String, dynamic> json) {
    return Tank(
      docId,
      name: json['name'],
      isFreshwater: json['isFreshwater'],
      imgName: json['imgName'],
      dimensions: Dimensions.fromJson(json['dimensions']),
    );
  }
}
