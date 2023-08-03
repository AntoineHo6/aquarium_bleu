import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/task/task.dart';
import 'package:flutter/material.dart';

class TasksProvider extends ChangeNotifier {
  late List<int> currentDays = [];
  late DateTime currentDate;
  late List<Task> selectedDayTasks = [];

  TasksProvider(String tankId) {
    DateTime now = DateTime.now();
    currentDate = DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);

    int numDays = DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    currentDays = List<int>.generate(numDays, (i) => i + 1);

    setSelectedDayTasks(tankId);
  }

  void setSelectedDayTasks(String tankId) {
    FirestoreStuff.fetchTasksInDay(tankId, currentDate).then(
      (tasks) {
        selectedDayTasks = tasks;
        notifyListeners();
      },
    );
  }
}
