import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/task/task.dart';
import 'package:flutter/material.dart';

class TasksProvider extends ChangeNotifier {
  late List<int> currentDaysInMonth = [];
  late DateTime currentDate;
  late List<Task> selectedDayTasks = [];

  TasksProvider(String tankId) {
    updateCurrentDate(DateTime.now());
    updateCurrentDays(currentDate);
    setSelectedDayTasks(tankId);
  }

  void updateCurrentDate(DateTime newDate) {
    currentDate = DateTime(newDate.year, newDate.month, newDate.day, 0, 0, 0, 0, 0);
  }

  void updateCurrentDays(DateTime date) {
    int numDays = DateUtils.getDaysInMonth(currentDate.year, currentDate.month);
    currentDaysInMonth = List<int>.generate(numDays, (i) => i + 1);
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
