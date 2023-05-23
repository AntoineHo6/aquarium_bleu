import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/models/task/interval_task.dart';
import 'package:aquarium_bleu/models/water_change.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class FirestoreStuff {
  static late String uid;

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
        .doc(uid)
        .collection('tanks')
        .snapshots()
        .map((event) => event.docs.map((doc) => Tank.fromJson(doc.id, doc.data())).toList());
  }

  // static Stream<List<Parameter>> readParameters(String tankId, WaterParamType param) {
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(uid)
  //       .collection('tanks')
  //       .doc(tankId)
  //       .collection(param.getStr)
  //       .orderBy("date")
  //       .snapshots()
  //       .map((event) => event.docs.map((doc) => Parameter.fromJson(doc.data())).toList());
  // }

  static Stream<List<Parameter>> readParamWithRange(
      String tankId, WaterParamType parameter, DateTime start, DateTime end) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection(parameter.getStr)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy("date")
        .snapshots()
        .map((event) => event.docs.map((doc) => Parameter.fromJson(doc.id, doc.data())).toList());
  }

  static Future addParameter(String tankId, Parameter param) async {
    final docParam = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    final json = param.toJson();

    await docParam.set(json);
  }

  static Future deleteParam(String tankId, Parameter param) async {
    final paramDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection(param.type.getStr)
        .doc(param.docId);

    await paramDoc.delete();
  }

  static Stream<List<WaterChange>> readWaterChangesWithRange(
      String tankId, DateTime start, DateTime end) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('waterChanges')
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy("date", descending: true)
        .snapshots()
        .map((event) => event.docs.map((doc) => WaterChange.fromJson(doc.id, doc.data())).toList());
  }

  static Future addWaterChange(String tankId, WaterChange waterChange) async {
    final docWaterChange = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('waterChanges')
        .doc(waterChange.docId);

    await docWaterChange.set(waterChange.toJson());
  }

  static Stream<List<IntervalTask>> readIntervalTasks(String docId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(docId)
        .collection('intervalTasks')
        .orderBy("dueDate")
        .snapshots()
        .map(
            (event) => event.docs.map((doc) => IntervalTask.fromJson(doc.id, doc.data())).toList());
  }

  static Future updateIntervalTask(IntervalTask updatedTask, String tankId) async {
    final intervalTask = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('intervalTasks')
        .doc(updatedTask.docId);

    await intervalTask.update(updatedTask.toJson());
  }

  static Future<String> addTank(String name, bool isFreshWater) async {
    final String docId = const Uuid().v4();
    final docTank =
        FirebaseFirestore.instance.collection('users').doc(uid).collection('tanks').doc(docId);

    // TODO: redo
    final json = {
      'name': name,
      'isFreshwater': isFreshWater,
    };

    await docTank.set(json);

    return docId;
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readParamVis(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('isParamVisible')
        .snapshots();
  }

  static Future updateParamVis(String tankId, Map<String, dynamic> visibleParams) async {
    final visibilityDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('isParamVisible');

    await visibilityDoc.update(visibleParams);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readDateRangeWcnpPrefs(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange')
        .snapshots();
  }

  static Future updateDateRangeType(String tankId, DateRangeType type) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange');

    await dateRangeDoc.update({'type': type.getStr});
  }

  static Future updateCustomStartDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('dateRange');

    await dateRangeDoc.update({'customDateStart': newDate});
  }

  static Future updateCustomEndDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
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
        .doc(uid)
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
        .doc(uid)
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
        .doc(uid)
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
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('showWaterChanges')
        .snapshots();
  }

  static Future updateShowWaterChanges(String tankId, bool newValue) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('wcnpPrefs')
        .doc('showWaterChanges');

    await dateRangeDoc.update({'value': newValue});
  }
}
