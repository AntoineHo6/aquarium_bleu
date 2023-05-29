import 'package:aquarium_bleu/models/dimensions.dart';

class Tank {
  final String docId;
  String name;
  bool isFreshwater;
  String? imgName;
  Dimensions? dimensions;

  Tank(
    this.docId, {
    required this.name,
    required this.isFreshwater,
    this.imgName,
    this.dimensions,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'isFreshwater': isFreshwater,
        'imgName': imgName,
        // 'dimensions': dimensions, // rework
      };

  static Tank fromJson(String docId, Map<String, dynamic> json) {
    return Tank(
      docId,
      name: json['name'],
      isFreshwater: json['isFreshwater'],
      imgName: json['imgName'],
      dimensions: json['dimensions'] == null ? null : Dimensions.fromJson(json['dimensions']),
    );
  }
}
