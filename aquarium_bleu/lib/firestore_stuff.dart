import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/models/task/task.dart';
import 'package:aquarium_bleu/models/task_r_rule.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class FirestoreStuff {
  static const usersCollection = 'users';
  static const tanksCollection = 'tanks';
  static const wcCollection = 'waterChanges';
  static const wcnpPrefsCollection = 'wcnpPrefs';
  static const tasksCollection = 'tasks';
  static const exTasksCollection = 'exTasks';
  static const taskRRulesCollection = 'taskRRules';

  static writeNewUser(String? uid, String? email) async {
    uid = uid!;
    final docUser = FirebaseFirestore.instance.collection(usersCollection).doc(uid);

    final json = {'email': email};

    await docUser.set(json);
  }

  static Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection(usersCollection);

      var doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  static Stream<List<Tank>> readTanks() {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .snapshots()
        .map((event) => event.docs.map((doc) => Tank.fromJson(doc.id, doc.data())).toList());
  }

  // static Stream<Parameter> readLatestParameter(
  //     String tankId, WaterParamType param) {
  //   return FirebaseFirestore.instance
  //       .collection(usersCollection)
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .collection(tanksCollection)
  //       .doc(tankId)
  //       .collection(param.getStr)
  //       .orderBy("date", descending: true)
  //       .limit(1)
  //       .snapshots()
  //       .map((event) =>
  //           Parameter.fromJson(event.docs.first.id, event.docs.first.data()));
  // }

  static Stream<List<Parameter>> readParamWithRange(
      String tankId, WaterParamType param, DateTime start, DateTime end) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(param.getStr)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy('date', descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => Parameter.fromJson(doc.id, doc.data())).toList());
  }

  static Future addParameter(String tankId, Parameter param) async {
    final paramDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    await paramDoc.set(param.toJson());
  }

  static Future updateParam(String tankId, Parameter param) async {
    final paramDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    await paramDoc.update(param.toJson());
  }

  static Future deleteParam(String tankId, Parameter param) async {
    final paramDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    await paramDoc.delete();
  }

  static Stream<List<WaterChange>> readWcWithRange(String tankId, DateTime start, DateTime end) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcCollection)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => WaterChange.fromJson(doc.id, doc.data())).toList());
  }

  static Future deleteWc(String tankId, String wcId) async {
    final wcDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcCollection)
        .doc(wcId);

    await wcDoc.delete();
  }

  static Future updateWc(String tankId, WaterChange wc) async {
    final wcDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcCollection)
        .doc(wc.docId);

    await wcDoc.update(wc.toJson());
  }

  static Stream<WaterChange> readLatestWc(String tankId) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcCollection)
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots()
        .map((event) => WaterChange.fromJson(event.docs.first.id, event.docs.first.data()));
  }

  static Future addWaterChange(String tankId, WaterChange waterChange) async {
    final docWaterChange = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcCollection)
        .doc(waterChange.docId);

    await docWaterChange.set(waterChange.toJson());
  }

  // remake
  static Future<String> addTank(Tank tank) async {
    final docTank = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tank.docId);

    await docTank.set(tank.toJson());

    return tank.docId;
  }

  static Future updateTank(Tank tank) async {
    final tankDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tank.docId);

    await tankDoc.update(tank.toJson());
  }

  static Future deleteTank(Tank tank) async {
    final tankDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tank.docId);

    final dateRangeDoc = tankDoc.collection(wcnpPrefsCollection).doc('dateRange');
    final isParamVisibleDoc = tankDoc.collection(wcnpPrefsCollection).doc('isParamVisible');
    final showWaterChanges = tankDoc.collection(wcnpPrefsCollection).doc('showWaterChanges');

    await dateRangeDoc.delete();
    await isParamVisibleDoc.delete();
    await showWaterChanges.delete();
    await tankDoc.delete();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readParamVis(String tankId) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('isParamVisible')
        .snapshots();
  }

  static Future updateParamVis(String tankId, Map<String, dynamic> visibleParams) async {
    final visibilityDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('isParamVisible');

    await visibilityDoc.update(visibleParams);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readDateRangeWcnpPrefs(String tankId) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('dateRange')
        .snapshots();
  }

  static Future updateDateRangeType(String tankId, DateRangeType type) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('dateRange');

    await dateRangeDoc.update({'type': type.getStr});
  }

  static Future updateCustomStartDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('dateRange');

    await dateRangeDoc.update({'customDateStart': newDate});
  }

  static Future updateCustomEndDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('dateRange');

    await dateRangeDoc.update({'customDateEnd': newDate});
  }

  static Future addDefaultWcnpPrefs(String tankId) async {
    // 1. Add date range pref
    final dateRangeDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('dateRange');

    final json1 = {
      'type': Strings.all,
      'customDateStart': DateTime.now().subtract(const Duration(days: 7)),
      'customDateEnd': DateTime.now(),
    };

    await dateRangeDoc.set(json1);

    // 2. Add param visibility pref
    final visibilityDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('isParamVisible');

    final json2 = {
      for (var paramType in WaterParamType.values) paramType.getStr: true,
    };

    await visibilityDoc.set(json2);

    // 3. Add show water change pref
    final showWaterChangesDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('showWaterChanges');

    final json3 = {
      'value': true,
    };

    await showWaterChangesDoc.set(json3);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readShowWaterChanges(String tankId) {
    return FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('showWaterChanges')
        .snapshots();
  }

  static Future updateShowWaterChanges(String tankId, bool newValue) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(wcnpPrefsCollection)
        .doc('showWaterChanges');

    await dateRangeDoc.update({'value': newValue});
  }

  static Future addTaskRRule(String tankId, TaskRRule taskRRule) async {
    final taskRRuleDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection('taskRRules')
        .doc(taskRRule.id);

    await taskRRuleDoc.set(taskRRule.toJson());
  }

  static Future<List<TaskRRule>> readTaskRRules(String tankId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection('taskRRules')
        .get();

    final allData =
        querySnapshot.docs.map((doc) => TaskRRule.fromJson(doc.id, doc.data())).toList();

    return allData;
  }

  static Future<Map<int, int>> fetchNumOfTasksPerDayInMonth(
      String tankId, DateTime firstDayOfMonth, DateTime firstDayOfNextMonth) async {
    // 1. count the rRule tasks
    List<TaskRRule> taskRRules = await readTaskRRules(tankId);

    Map<int, int> numTasksPerDay = {};

    for (TaskRRule taskRRule in taskRRules) {
      final exDatesSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(tanksCollection)
          .doc(tankId)
          .collection('exTasks')
          .where('rRuleId', isEqualTo: taskRRule.id)
          .where(
            'date',
            isGreaterThanOrEqualTo: firstDayOfMonth,
            isLessThanOrEqualTo: firstDayOfNextMonth,
          )
          .get();

      final exDates = exDatesSnapshot.docs
          .map((doc) => (doc.data()['date'] as Timestamp).toDate().copyWith(isUtc: true))
          .toList();

      final instances = taskRRule.rRule
          .getInstances(
            start: taskRRule.startDate.copyWith(isUtc: true),
          )
          .where(
            (instance) =>
                instance.compareTo(firstDayOfMonth) > 0 &&
                instance.compareTo(firstDayOfNextMonth) < 0,
          );

      // if rrule is never ending, use takewhile
      // or specify num of days in that month
      for (var instance in instances) {
        if (exDates.contains(instance)) {
          // do nothing
        } else {
          numTasksPerDay.update(
            instance.day,
            (value) => ++value,
            ifAbsent: () => 1,
          );
        }
      }
    }

    // 2. count the unique tasks
    final uniqueTasksSnapshot = await FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(tasksCollection)
        .where('rRuleId', isNull: true)
        .where(
          'date',
          isGreaterThanOrEqualTo: firstDayOfMonth,
          isLessThanOrEqualTo: firstDayOfNextMonth,
        )
        .get();

    uniqueTasksSnapshot.docs.map((doc) => numTasksPerDay.update(
          (doc.data()['date'] as Timestamp).toDate().day,
          (value) => ++value,
          ifAbsent: () => 1,
        ));

    return numTasksPerDay;
  }

  static Future addTask(String tankId, Task task) async {
    final taskDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(tasksCollection)
        .doc(task.id);

    await taskDoc.set(task.toJson());
  }

  static Future deleteTask(String tankId, Task task) async {
    final taskDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(tasksCollection)
        .doc(task.id);

    await taskDoc.delete();

    final exTaskDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection(exTasksCollection)
        .doc(task.id);

    await exTaskDoc.set({
      'rRuleId': task.rRuleId,
      'date': task.date,
    });
  }

  static Future<List<Task>> fetchTasksInDay(String tankId, DateTime day) async {
    List<Task> tasks = [];

    DateTime bidonDay = DateTime(1969, 12, 12);
    DateTime dayEnd = DateTime(day.year, day.month, day.day, 23, 59, 59);

    // 1. check rrules
    List<TaskRRule> taskRRules = await readTaskRRules(tankId);

    for (TaskRRule taskRRule in taskRRules) {
      final exDatesSnapshot = await FirebaseFirestore.instance
          .collection(usersCollection)
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection(tanksCollection)
          .doc(tankId)
          .collection('exTasks')
          .where('rRuleId', isEqualTo: taskRRule.id)
          .where(
            'date',
            isGreaterThanOrEqualTo: day,
            isLessThanOrEqualTo: dayEnd,
          )
          .get();

      final exDates =
          exDatesSnapshot.docs.map((doc) => (doc.data()['date'] as Timestamp).toDate()).toList();

      if (taskRRule.startDate.compareTo(dayEnd) <= 0) {
        DateTime test = taskRRule.startDate.toUtc();

        DateTime instance =
            taskRRule.rRule.getInstances(start: taskRRule.startDate.toUtc()).firstWhere(
                  (instance) =>
                      instance.day == day.day &&
                      instance.month == day.month &&
                      instance.year == day.year,
                  orElse: () => bidonDay,
                );

        if (instance != bidonDay) {
          // 1. If task is in EXTASKS, ignore
          if (exDates.contains(instance.toLocal())) {
            // do nothing
          } else {
            // 2. Query from tasks collection
            final taskSnapshot = await FirebaseFirestore.instance
                .collection(usersCollection)
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection(tanksCollection)
                .doc(tankId)
                .collection(tasksCollection)
                .where('rRuleId', isEqualTo: taskRRule.id)
                .where('date', isEqualTo: instance)
                .get();

            final task = taskSnapshot.docs.map((doc) => Task.fromJson(doc.id, doc.data())).toList();

            // 3. If task doesn't exist in tasks collection, generate from rule
            if (task.isEmpty) {
              Task newTask;

              newTask = Task(
                const Uuid().v4(),
                rRuleId: taskRRule.id,
                title: taskRRule.title,
                description: taskRRule.description,
                date: instance.toLocal(),
                isCompleted: false,
              );

              await addTask(tankId, newTask);

              tasks.add(newTask);
            } else {
              tasks.add(task[0]);
            }
          }
        }
      }
    }

    // 2. check unique tasks
    // final uniqueTasksSnapshot = await FirebaseFirestore.instance
    //     .collection(usersCollection)
    //     .doc(FirebaseAuth.instance.currentUser!.uid)
    //     .collection(tanksCollection)
    //     .doc(tankId)
    //     .collection('exTasks')
    //     .where('rRuleId', isNull: true)
    //     .where(
    //       'date',
    //       isGreaterThanOrEqualTo: day,
    //       isLessThanOrEqualTo: dayEnd,
    //     )
    //     .get();

    return tasks;
  }
}
