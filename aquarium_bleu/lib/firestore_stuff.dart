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
import 'package:flutter/scheduler.dart';
import 'package:uuid/uuid.dart';

class FirestoreStuff {
  static writeNewUser(String? uid, String? email) async {
    uid = uid!;
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

    final json = {'email': email};

    await docUser.set(json);
  }

  static Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  static Stream<List<Tank>> readTanks() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .snapshots()
        .map((event) => event.docs.map((doc) => Tank.fromJson(doc.id, doc.data())).toList());
  }

  static Stream<Parameter> readLatestParameter(String tankId, WaterParamType param) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection(param.getStr)
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots()
        .map((event) => Parameter.fromJson(event.docs.first.id, event.docs.first.data()));
  }

  static Stream<List<Parameter>> readParamWithRange(
      String tankId, WaterParamType param, DateTime start, DateTime end) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection(param.getStr)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => Parameter.fromJson(doc.id, doc.data())).toList());
  }

  static Future addParameter(String tankId, Parameter param) async {
    final paramDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    await paramDoc.set(param.toJson());
  }

  static Future updateParam(String tankId, Parameter param) async {
    final paramDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    await paramDoc.update(param.toJson());
  }

  static Future deleteParam(String tankId, Parameter param) async {
    final paramDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    await paramDoc.delete();
  }

  static Stream<List<WaterChange>> readWcWithRange(String tankId, DateTime start, DateTime end) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('waterChanges')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => WaterChange.fromJson(doc.id, doc.data())).toList());
  }

  static Future deleteWc(String tankId, String wcId) async {
    final wcDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('waterChanges')
        .doc(wcId);

    await wcDoc.delete();
  }

  static Future updateWc(String tankId, WaterChange wc) async {
    final wcDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('waterChanges')
        .doc(wc.docId);

    await wcDoc.update(wc.toJson());
  }

  static Stream<WaterChange> readLatestWc(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('waterChanges')
        .orderBy("date", descending: true)
        .limit(1)
        .snapshots()
        .map((event) => WaterChange.fromJson(event.docs.first.id, event.docs.first.data()));
  }

  static Future addWaterChange(String tankId, WaterChange waterChange) async {
    final docWaterChange = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('waterChanges')
        .doc(waterChange.docId);

    await docWaterChange.set(waterChange.toJson());
  }

  // remake
  static Future<String> addTank(Tank tank) async {
    final docTank = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tank.docId);

    await docTank.set(tank.toJson());

    return tank.docId;
  }

  static Future updateTank(Tank tank) async {
    final tankDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tank.docId);

    await tankDoc.update(tank.toJson());
  }

  static Future deleteTank(Tank tank) async {
    final tankDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tank.docId);

    final dateRangeDoc = tankDoc.collection('wcnpPrefs').doc('dateRange');
    final isParamVisibleDoc = tankDoc.collection('wcnpPrefs').doc('isParamVisible');
    final showWaterChanges = tankDoc.collection('wcnpPrefs').doc('showWaterChanges');

    await dateRangeDoc.delete();
    await isParamVisibleDoc.delete();
    await showWaterChanges.delete();
    await tankDoc.delete();
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readParamVis(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('isParamVisible')
        .snapshots();
  }

  static Future updateParamVis(String tankId, Map<String, dynamic> visibleParams) async {
    final visibilityDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('isParamVisible');

    await visibilityDoc.update(visibleParams);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readDateRangeWcnpPrefs(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange')
        .snapshots();
  }

  static Future updateDateRangeType(String tankId, DateRangeType type) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange');

    await dateRangeDoc.update({'type': type.getStr});
  }

  static Future updateCustomStartDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange');

    await dateRangeDoc.update({'customDateStart': newDate});
  }

  static Future updateCustomEndDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange');

    await dateRangeDoc.update({'customDateEnd': newDate});
  }

  static Future addDefaultWcnpPrefs(String tankId) async {
    // 1. Add date range pref
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange');

    final json1 = {
      'type': Strings.all,
      'customDateStart': DateTime.now().subtract(const Duration(days: 7)),
      'customDateEnd': DateTime.now(),
    };

    await dateRangeDoc.set(json1);

    // 2. Add param visibility pref
    final visibilityDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('isParamVisible');

    final json2 = {
      for (var paramType in WaterParamType.values) paramType.getStr: true,
    };

    await visibilityDoc.set(json2);

    // 3. Add show water change pref
    final showWaterChangesDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('showWaterChanges');

    final json3 = {
      'value': true,
    };

    await showWaterChangesDoc.set(json3);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readShowWaterChanges(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('showWaterChanges')
        .snapshots();
  }

  static Future updateShowWaterChanges(String tankId, bool newValue) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('showWaterChanges');

    await dateRangeDoc.update({'value': newValue});
  }

  static Future addTaskRRule(String tankId, TaskRRule taskRRule) async {
    final taskRRuleDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('taskRRules')
        .doc(taskRRule.id);

    await taskRRuleDoc.set(taskRRule.toJson());
  }

  static Future<List<TaskRRule>> readTaskRRules(String tankId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('taskRRules')
        .get();

    final allData =
        querySnapshot.docs.map((doc) => TaskRRule.fromJson(doc.id, doc.data())).toList();

    return allData;
  }

  static Future<Map<int, List<String>>> fetchTaskDaysInMonth(String tankId, DateTime date) async {
    List<TaskRRule> taskRRules = await readTaskRRules(tankId);

    Map<String, List<int>> exDaysInMonth = {};

    Map<int, List<String>> taskDatesInMonth = {};

    DateTime firstDayOfMonth = DateTime(date.year, date.month, 1);
    // check if its the last month of the year, if adding a month increments the year
    DateTime firstDayOfNextMonth = DateTime(date.year, date.month + 1, 1);

    for (TaskRRule taskRRule in taskRRules) {
      // fetch list of EXTASKS, map<taskRRuleId, List<DateTime>>
      final exDatesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('exTasks')
        .where('rRuleId', isEqualTo: taskRRule.id)
        .where('date', isGreaterThanOrEqualTo: firstDayOfMonth, isLessThanOrEqualTo: firstDayOfNextMonth)
        .get();

      final allData =
        exDatesSnapshot.docs.map((doc) => (doc.data()['date'] as Timestamp).toDate().toUtc()).toList();

      taskRRule.rRule
          .getInstances(start: taskRRule.startDate.copyWith(isUtc: true))
          .take(31)
          .where((element) => element.month == date.month && element.year == date.year)
          .forEach((dateTime) {
        // ignore those is EXTASKS
        if (allData.contains(dateTime)) {
          print('booger');
          // do nothing
        }
        else if (taskDatesInMonth[dateTime.day] == null) {
          taskDatesInMonth[dateTime.day] = [];
          taskDatesInMonth[dateTime.day]!.add(taskRRule.id);
        }
        else {
          taskDatesInMonth[dateTime.day]!.add(taskRRule.id);
        }
      });
    }

    return taskDatesInMonth;
  }

  static Future addTask(String tankId, Task task) async {
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('tasks')
        .doc(task.id);

    await taskDoc.set(task.toJson());
  }

  static Future removeTask(String tankId, Task task) async {
    final taskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('tasks')
        .doc(task.id);

    await taskDoc.delete();

    final exTaskDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('exTasks')
        .doc(task.id);
    
    await exTaskDoc.set({
      'rRuleId': task.rRuleId,
      'date': task.dueDate,
    });
  }

  static Future<Task> fetchTask(String tankId, String rRuleId, DateTime date) async {
    final rRuleDoc = FirebaseFirestore.instance
      .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('taskRRules')
        .doc(rRuleId);

    final doc = await rRuleDoc.get();
    TaskRRule taskRRule = TaskRRule.fromJson(doc.id, doc.data()!);
    
    final instances = taskRRule.rRule.getInstances(start: date.copyWith(isUtc: true));
    final firstInstance = instances.first;

    // 1. If task is in EXTASKS, ignore

    // 2. Query from tasks collection
    final taskSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('tanks')
        .doc(tankId)
        .collection('tasks')
        .where('rRuleId', isEqualTo: rRuleId)
        .where('dueDate', isEqualTo: firstInstance)
        .get();

    final task = taskSnapshot.docs.map((doc) => Task.fromJson(doc.id, doc.data())).toList();

    // 3. If task doesn't exist in tasks collection, generate from rule
    if (task.isEmpty) {
      late Task newTask;

      newTask = Task(const Uuid().v4(), rRuleId: rRuleId, title: taskRRule.title, description: taskRRule.description, dueDate: firstInstance, isCompleted: false);

      await addTask(tankId, newTask);

      return newTask;

    } else {
      return task[0];
    }
  }

  static Future<List<Task>> fetchTasksInDay(String tankId, List<String> rRuleIds, DateTime date) async {
    List<Task> tasks = [];
    for (String rRuleId in rRuleIds) {
      tasks.add(await fetchTask(tankId, rRuleId, date));
    }

    return tasks;
  }
}
