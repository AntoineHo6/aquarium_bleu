import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class DatePickerCalendarPage extends StatefulWidget {
  final DateTime selectedDate;

  const DatePickerCalendarPage({required this.selectedDate, super.key});

  @override
  State<DatePickerCalendarPage> createState() => _DatePickerCalendarPageState();
}

class _DatePickerCalendarPageState extends State<DatePickerCalendarPage> {
  late DateTime _selectedDate;
  late DateTime _focusedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.selectedDate;
    _focusedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDate,
            firstDay: DateTime.utc(2000, 12, 1),
            lastDay: DateTime.utc(2050, 12, 1),
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDate, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDate = selectedDay;
                _focusedDate = focusedDay;
              });
            },
          )
        ],
      ),
    );
  }
}
