import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/models/task/task.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreStuff {
  static const usersCollection = 'users';
  static const tanksCollection = 'tanks';
  static const wcCollection = 'waterChanges';
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

    await tankDoc.delete();
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

    // if task was generated from a rrule, we prevent generation
    if (task.rRuleId != null) {
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
  }

  static Future<void> updateTask(String tankId, Task task) async {
    final taskDoc = FirebaseFirestore.instance
        .collection(usersCollection)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection(tanksCollection)
        .doc(tankId)
        .collection('tasks')
        .doc(task.id);

    await taskDoc.update(task.toJson());
  }
}
