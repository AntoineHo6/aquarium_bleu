import 'package:aquarium_bleu/dimensions.dart';

class Tank {
  final String name;
  Dimensions? dimensions;

  Tank({required this.name, this.dimensions});

  Map<String, dynamic> toJson() => {
        'name': name,
        'dimensions': dimensions,
      };

  static Tank fromJson(Map<String, dynamic> json) => Tank(
        name: json['name'],
        dimensions: json['dimensions'] == null
            ? null
            : Dimensions.fromJson(json['dimensions']),
      );
}
