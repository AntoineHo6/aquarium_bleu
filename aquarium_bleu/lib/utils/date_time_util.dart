import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DateTimeUtil {
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
        return '${_getMonthAbbr(context, 1)} ${date.day}, ${date.year}';
    }
  }
}
