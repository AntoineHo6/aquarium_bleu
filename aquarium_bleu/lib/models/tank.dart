import 'package:aquarium_bleu/models/dimensions.dart';
import 'package:aquarium_bleu/models/nitrate.dart';

class Tank {
  final String docId;
  final String name;
  final Dimensions? dimensions;

  Tank(this.docId, {required this.name, this.dimensions});

  Map<String, dynamic> toJson() => {
        'name': name,
        'dimensions': dimensions, // rework
      };

  static Tank fromJson(String docId, Map<String, dynamic> json) {
    return Tank(
      docId,
      name: json['name'],
      dimensions: json['dimensions'] == null
          ? null
          : Dimensions.fromJson(json['dimensions']),
    );
  }
}
