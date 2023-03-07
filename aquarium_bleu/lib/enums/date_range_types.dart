import 'package:aquarium_bleu/strings.dart';

enum DateRange {
  all,
  months1,
  months2,
  months3,
  months6,
  months9,
  custom,
}

extension DateRangeStr on DateRange {
  String get rangeStr {
    switch (this) {
      case DateRange.all:
        return Strings.all;
      case DateRange.months1:
        return Strings.months1;
      case DateRange.months2:
        return Strings.months2;
      case DateRange.months3:
        return Strings.months3;
      case DateRange.months6:
        return Strings.months6;
      case DateRange.months9:
        return Strings.months9;
      case DateRange.custom:
        return Strings.custom;
    }
  }
}
