import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StringUtil {
  static String _getMonthAbbr(BuildContext context, int month) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context)!.janAbbr;
      case 2:
        return AppLocalizations.of(context)!.febAbbr;
      case 3:
        return AppLocalizations.of(context)!.marAbbr;
      case 4:
        return AppLocalizations.of(context)!.aprAbbr;
      case 5:
        return AppLocalizations.of(context)!.mayAbbr;
      case 6:
        return AppLocalizations.of(context)!.junAbbr;
      case 7:
        return AppLocalizations.of(context)!.julAbbr;
      case 8:
        return AppLocalizations.of(context)!.augAbbr;
      case 9:
        return AppLocalizations.of(context)!.sepAbbr;
      case 10:
        return AppLocalizations.of(context)!.octAbbr;
      case 11:
        return AppLocalizations.of(context)!.novAbbr;
      case 12:
        return AppLocalizations.of(context)!.decAbbr;
      default:
        return "bidon";
    }
  }

  static String formattedDate(BuildContext context, DateTime date) {
    switch (AppLocalizations.of(context)!.localeName) {
      case 'fr':
        return '${date.day} ${_getMonthAbbr(context, date.month)}, ${date.year}';
      default:
        // is english
        return '${_getMonthAbbr(context, date.month)} ${date.day}, ${date.year}';
    }
  }

  static String formattedTime(BuildContext context, TimeOfDay time) {
    return '${time.hour}:${time.minute.toString().padLeft(2, '0')}';
  }

  static paramTypeToString(BuildContext context, WaterParamType paramType) {
    switch (paramType) {
      case WaterParamType.ammonia:
        return AppLocalizations.of(context)!.ammonia;
      case WaterParamType.nitrite:
        return AppLocalizations.of(context)!.nitrite;
      case WaterParamType.nitrate:
        return AppLocalizations.of(context)!.nitrate;
      case WaterParamType.tds:
        return AppLocalizations.of(context)!.tds;
      case WaterParamType.ph:
        return AppLocalizations.of(context)!.ph;
      case WaterParamType.kh:
        return AppLocalizations.of(context)!.kh;
      case WaterParamType.gh:
        return AppLocalizations.of(context)!.gh;
      case WaterParamType.temp:
        return AppLocalizations.of(context)!.temp;
      case WaterParamType.alkalinity:
        return AppLocalizations.of(context)!.alkalinity;
      case WaterParamType.calcium:
        return AppLocalizations.of(context)!.calcium;
      case WaterParamType.copper:
        return AppLocalizations.of(context)!.copper;
      case WaterParamType.co2:
        return AppLocalizations.of(context)!.co2;
      case WaterParamType.iron:
        return AppLocalizations.of(context)!.iron;
      case WaterParamType.magnesium:
        return AppLocalizations.of(context)!.magnesium;
      case WaterParamType.o2:
        return AppLocalizations.of(context)!.o2;
      case WaterParamType.oxygen:
        return AppLocalizations.of(context)!.oxygen;
      case WaterParamType.phosphate:
        return AppLocalizations.of(context)!.phosphate;
      case WaterParamType.orp:
        return AppLocalizations.of(context)!.orp;
      case WaterParamType.potassium:
        return AppLocalizations.of(context)!.potassium;
      case WaterParamType.salinity:
        return AppLocalizations.of(context)!.salinity;
      case WaterParamType.silica:
        return AppLocalizations.of(context)!.silica;
      case WaterParamType.strontium:
        return AppLocalizations.of(context)!.strontium;
      case WaterParamType.boron:
        return AppLocalizations.of(context)!.boron;
      case WaterParamType.iodine:
        return AppLocalizations.of(context)!.iodine;
      default:
        return AppLocalizations.of(context)!.error;
    }
  }

  static dateRangeTypeToString(BuildContext context, DateRangeType dateRangeType) {
    switch (dateRangeType) {
      case DateRangeType.months1:
        return AppLocalizations.of(context)!.months1;
      case DateRangeType.months2:
        return AppLocalizations.of(context)!.months2;
      case DateRangeType.months3:
        return AppLocalizations.of(context)!.months3;
      case DateRangeType.months6:
        return AppLocalizations.of(context)!.months6;
      case DateRangeType.months9:
        return AppLocalizations.of(context)!.months9;
      case DateRangeType.all:
        return AppLocalizations.of(context)!.all;
      case DateRangeType.custom:
        return AppLocalizations.of(context)!.custom;
    }
  }

  static bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }
}
