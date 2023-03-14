import 'package:aquarium_bleu/strings.dart';

enum WaterParamType {
  ammonia,
  nitrite,
  nitrate,
  tds,
  ph,
  kh,
  gh,
  temp,
  alkalinity,
  calcium,
  copper,
  co2,
  iron,
  magnesium,
  o2,
  oxygen,
  phosphate,
  orp,
  potassium,
  salinity,
  silica,
  strontium,
  boron,
  iodine,
}

extension WaterParamTypeStr on WaterParamType {
  String get getStr {
    switch (this) {
      case WaterParamType.ammonia:
        return Strings.ammonia;
      case WaterParamType.nitrite:
        return Strings.nitrite;
      case WaterParamType.nitrate:
        return Strings.nitrate;
      case WaterParamType.tds:
        return Strings.tds;
      case WaterParamType.ph:
        return Strings.ph;
      case WaterParamType.kh:
        return Strings.kh;
      case WaterParamType.gh:
        return Strings.gh;
      case WaterParamType.temp:
        return Strings.temp;
      case WaterParamType.alkalinity:
        return Strings.alkalinity;
      case WaterParamType.calcium:
        return Strings.calcium;
      case WaterParamType.copper:
        return Strings.copper;
      case WaterParamType.co2:
        return Strings.co2;
      case WaterParamType.iron:
        return Strings.iron;
      case WaterParamType.magnesium:
        return Strings.magnesium;
      case WaterParamType.o2:
        return Strings.o2;
      case WaterParamType.oxygen:
        return Strings.oxygen;
      case WaterParamType.phosphate:
        return Strings.phosphate;
      case WaterParamType.orp:
        return Strings.orp;
      case WaterParamType.potassium:
        return Strings.potassium;
      case WaterParamType.salinity:
        return Strings.salinity;
      case WaterParamType.silica:
        return Strings.silica;
      case WaterParamType.strontium:
        return Strings.strontium;
      case WaterParamType.boron:
        return Strings.boron;
      case WaterParamType.iodine:
        return Strings.iodine;
    }
  }
}
