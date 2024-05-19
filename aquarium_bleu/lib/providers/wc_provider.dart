import 'dart:collection';

import 'package:aquarium_bleu/utils/calendar_util.dart';
import 'package:flutter/material.dart';

class WcProvider extends ChangeNotifier {
  DateTime focusedDay = DateTime.now();
  DateTime? selectedDay = DateTime.now();
  LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap<DateTime, List<Event>>();
}
