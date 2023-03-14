import 'package:aquarium_bleu/strings.dart';

enum DateRangeType {
  months1,
  months2,
  months3,
  months6,
  months9,
  all,
  custom,
}

extension DateRangeTypeStr on DateRangeType {
  String get getStr {
    switch (this) {
      case DateRangeType.months1:
        return Strings.months1;
      case DateRangeType.months2:
        return Strings.months2;
      case DateRangeType.months3:
        return Strings.months3;
      case DateRangeType.months6:
        return Strings.months6;
      case DateRangeType.months9:
        return Strings.months9;
      case DateRangeType.all:
        return Strings.all;
      case DateRangeType.custom:
        return Strings.custom;
    }
  }
}
