import 'package:aquarium_bleu/models/dimensions.dart';

class Tank {
  final String docId;
  final String name;
  final bool isFreshwater;
  final Dimensions? dimensions;

  Tank(
    this.docId, {
    required this.name,
    required this.isFreshwater,
    this.dimensions,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'isFreshwater': isFreshwater, // check
        'dimensions': dimensions, // rework
      };

  static Tank fromJson(String docId, Map<String, dynamic> json) {
    return Tank(
      docId,
      name: json['name'],
      isFreshwater: json['isFreshwater'],
      dimensions: json['dimensions'] == null
          ? null
          : Dimensions.fromJson(json['dimensions']),
    );
  }
}
