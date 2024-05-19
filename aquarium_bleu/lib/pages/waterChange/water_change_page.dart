import 'dart:collection';

import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/pages/waterChange/edit_water_change_page.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/providers/wc_provider.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/calendar_util.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/wcnp_page/add_water_change_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class WaterChangePage extends StatefulWidget {
  const WaterChangePage({super.key});

  @override
  WaterChangePageState createState() => WaterChangePageState();
}

class WaterChangePageState extends State<WaterChangePage> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  late Map<DateTime, List<Event>> dateToEventsMap = {};
  LinkedHashMap<DateTime, List<Event>> kEvents = LinkedHashMap<DateTime, List<Event>>();

  DateTime _focusedDay = DateUtils.dateOnly(DateTime.now());
  DateTime? _selectedDay;

  @override
  void initState() {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);
    final wcProvider = Provider.of<WcProvider>(context, listen: false);

    FirestoreStuff.readAllWaterChanges(tankProvider.tank.docId).listen((waterChanges) {
      print("PENITH");
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
        hashCode: getHashCode,
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
                title: Text(AppLocalizations.of(context)!.waterChanges),
              ),
              body: Column(
                children: [
                  TableCalendar<Event>(
                    firstDay: kFirstDay,
                    lastDay: kLastDay,
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
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  )),
                                ),
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => EditWaterChangePage(value[index].wc),
                                  ),
                                ),
                                child: ListTile(
                                  title: RichText(
                                    text: TextSpan(
                                      style: Theme.of(context).textTheme.titleMedium,
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: StringUtil.formattedDate(
                                              context, value[index].wc.date),
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
              floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      AddWaterChangeAlertDialog(tankProvider.tank.docId),
                ).then((value) => setState(() {})),
                child: const Icon(Icons.add),
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
