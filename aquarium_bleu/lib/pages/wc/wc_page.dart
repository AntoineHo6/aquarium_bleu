import 'dart:collection';

import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/event.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/wc/edit_wc_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/wc/add_wc_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class WcPage extends StatefulWidget {
  const WcPage({super.key});

  @override
  WcPageState createState() => WcPageState();
}

class WcPageState extends State<WcPage> {
  late ValueNotifier<List<Event>> _selectedEvents;
  late Map<DateTime, List<Event>> dateToEventsMap = {};
  LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap<DateTime, List<Event>>();

  DateTime _focusedDay = DateUtils.dateOnly(DateTime.now());
  DateTime? _selectedDay;

  @override
  void initState() {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    FirestoreStuff.readAllWaterChanges(tankProvider.tank.docId).listen((waterChanges) {
      dateToEventsMap.clear();
      for (var waterChange in waterChanges) {
        var event = Event(waterChange);

        DateTime dateNoTime = DateUtils.dateOnly(waterChange.date);

        if (dateToEventsMap.containsKey(dateNoTime)) {
          dateToEventsMap[dateNoTime]!.add(event);
        } else {
          dateToEventsMap[dateNoTime] = [event];
        }
      }

      kEvents = LinkedHashMap<DateTime, List<Event>>(
        equals: isSameDay,
        hashCode: (DateTime key) => key.day * 1000000 + key.month * 10000 + key.year,
      )..addAll(dateToEventsMap);

      _selectedDay = _focusedDay;
      _selectedEvents = ValueNotifier(_getEventsForDay(_focusedDay));
    });

    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    return StreamBuilder<List<WaterChange>>(
        stream: FirestoreStuff.readAllWaterChanges(tankProvider.tank.docId),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                // title: Text(AppLocalizations.of(context)!.waterChanges),
                actions: [
                  IconButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (BuildContext context) => AddWcAlertDialog(tankProvider.tank.docId),
                    ).then((value) => setState(() {})),
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              body: Padding(
                padding: const EdgeInsets.all(Spacing.screenEdgePadding),
                child: Column(
                  children: [
                    TableCalendar<Event>(
                      firstDay: DateTime(2000),
                      lastDay: DateTime(2030),
                      focusedDay: _focusedDay,
                      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                      eventLoader: _getEventsForDay,
                      calendarStyle: const CalendarStyle(
                        outsideDaysVisible: false,
                        markerDecoration:
                            BoxDecoration(color: MyTheme.wcColor, shape: BoxShape.circle),
                      ),
                      headerStyle: const HeaderStyle(
                        formatButtonVisible: false,
                      ),
                      onDaySelected: _onDaySelected,
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                    const SizedBox(
                      height: Spacing.betweenSections,
                    ),
                    Expanded(
                      child: ValueListenableBuilder<List<Event>>(
                        valueListenable: _selectedEvents,
                        builder: (context, value, _) {
                          return ListView.builder(
                            itemCount: value.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: FilledButton.tonal(
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )),
                                  ),
                                  onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EditWcPage(value[index].wc),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: RichText(
                                      text: TextSpan(
                                        style: Theme.of(context).textTheme.titleMedium,
                                        children: <TextSpan>[
                                          TextSpan(
                                            text: StringUtil.formattedDate(
                                              context,
                                              value[index].wc.date,
                                            ),
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: MyTheme.wcColor,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    subtitle: Text(
                                      StringUtil.formattedTime(
                                        context,
                                        TimeOfDay.fromDateTime(value[index].wc.date),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }
        });
  }
}
