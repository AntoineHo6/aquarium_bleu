import 'package:aquarium_bleu/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StringUtil {
  static String _getMonthAbbr(BuildContext context, int month) {
    switch (month) {
      case 1:
        return AppLocalizations.of(context).janAbbr;
      case 2:
        return AppLocalizations.of(context).febAbbr;
      case 3:
        return AppLocalizations.of(context).marAbbr;
      case 4:
        return AppLocalizations.of(context).aprAbbr;
      case 5:
        return AppLocalizations.of(context).mayAbbr;
      case 6:
        return AppLocalizations.of(context).junAbbr;
      case 7:
        return AppLocalizations.of(context).julAbbr;
      case 8:
        return AppLocalizations.of(context).augAbbr;
      case 9:
        return AppLocalizations.of(context).sepAbbr;
      case 10:
        return AppLocalizations.of(context).octAbbr;
      case 11:
        return AppLocalizations.of(context).novAbbr;
      case 12:
        return AppLocalizations.of(context).decAbbr;
      default:
        return "ds";
    }
  }

  static String formattedDate(BuildContext context, DateTime date) {
    switch (AppLocalizations.of(context).localeName) {
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

  static paramToString(BuildContext context, String param) {
    switch (param) {
      case Strings.ammonia:
        return AppLocalizations.of(context).ammonia;
      case Strings.nitrite:
        return AppLocalizations.of(context).nitrite;
      case Strings.nitrate:
        return AppLocalizations.of(context).nitrate;
      case Strings.tds:
        return AppLocalizations.of(context).tds;
      case Strings.ph:
        return AppLocalizations.of(context).ph;
      case Strings.kh:
        return AppLocalizations.of(context).kh;
      case Strings.gh:
        return AppLocalizations.of(context).gh;
      case Strings.temp:
        return AppLocalizations.of(context).temp;
      case Strings.alkalinity:
        return AppLocalizations.of(context).alkalinity;
      case Strings.calcium:
        return AppLocalizations.of(context).calcium;
      case Strings.copper:
        return AppLocalizations.of(context).copper;
      case Strings.co2:
        return AppLocalizations.of(context).co2;
      case Strings.iron:
        return AppLocalizations.of(context).iron;
      case Strings.magnesium:
        return AppLocalizations.of(context).magnesium;
      case Strings.o2:
        return AppLocalizations.of(context).o2;
      case Strings.oxygen:
        return AppLocalizations.of(context).oxygen;
      case Strings.phosphate:
        return AppLocalizations.of(context).phosphate;
      case Strings.orp:
        return AppLocalizations.of(context).orp;
      case Strings.potassium:
        return AppLocalizations.of(context).potassium;
      case Strings.salinity:
        return AppLocalizations.of(context).salinity;
      case Strings.silica:
        return AppLocalizations.of(context).silica;
      case Strings.strontium:
        return AppLocalizations.of(context).strontium;
      case Strings.boron:
        return AppLocalizations.of(context).boron;
      case Strings.iodine:
        return AppLocalizations.of(context).iodine;
      default:
        return AppLocalizations.of(context).error;
    }
  }
}
