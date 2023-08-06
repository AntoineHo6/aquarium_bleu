import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/models/dimensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Tank {
  final String docId;
  String name;
  bool isFreshwater;
  String? imgName;
  Dimensions dimensions;
  Map<dynamic, dynamic> visibleParams = {};
  bool showWcInCharts = true;
  DateRangeType dateRangeType = DateRangeType.all;
  DateTime customDateStart = DateTime.now().subtract(const Duration(days: 7));
  DateTime customDateEnd = DateTime.now();

  Tank(
    this.docId, {
    required this.name,
    required this.isFreshwater,
    this.imgName,
    required this.dimensions,
  }) {
    for (var paramType in WaterParamType.values) {
      visibleParams[paramType.getStr] = true;
    }
  }

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
        'visibleParams': visibleParams,
        'showWcInCharts': showWcInCharts,
        'dateRangeType': dateRangeType.getStr,
        'customDateStart': customDateStart,
        'customDateEnd': customDateEnd,
      };

  static Tank fromJson(String docId, Map<String, dynamic> json) {
    var newTank = Tank(
      docId,
      name: json['name'],
      isFreshwater: json['isFreshwater'],
      imgName: json['imgName'],
      dimensions: Dimensions.fromJson(json['dimensions']),
    );

    newTank.visibleParams = json['visibleParams'];
    newTank.showWcInCharts = json['showWcInCharts'];
    newTank.dateRangeType = DateRangeType.values
        .firstWhere((e) => e.toString() == 'DateRangeType.${json['dateRangeType']}');
    newTank.customDateStart = (json['customDateStart'] as Timestamp).toDate();
    newTank.customDateEnd = (json['customDateEnd'] as Timestamp).toDate();

    return newTank;
  }
}
