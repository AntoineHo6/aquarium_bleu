import 'package:aquarium_bleu/models/parameter.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/models/task/interval_task.dart';
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

  static Stream<List<Parameter>> readParameters(String tankId, String parameter) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection(parameter)
        .orderBy("date")
        .snapshots()
        .map((event) => event.docs.map((doc) => Parameter.fromJson(doc.data())).toList());
  }

  static Stream<List<Parameter>> readParametersWithRange(
      String tankId, String parameter, DateTime start, DateTime end) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection(parameter)
        .where('date', isGreaterThanOrEqualTo: start)
        .where('date', isLessThanOrEqualTo: end)
        .orderBy("date")
        .snapshots()
        .map((event) => event.docs.map((doc) => Parameter.fromJson(doc.data())).toList());
  }

  static Future addParameter(String tankId, String paramName, Parameter param) async {
    final docParam = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection(paramName)
        .doc(const Uuid().v4());

    final json = param.toJson();

    await docParam.set(json);
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

  static Future addDefaultParamVisPrefs(String tankId) async {
    final visibilityDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('isParamVisible');

    final json = {
      for (String param in Strings.params) param: true,
    };

    await visibilityDoc.set(json);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readParamVisPrefs(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('isParamVisible')
        .snapshots();
  }

  static Future updateParamVisPrefs(String tankId, Map<String, dynamic> visibleParams) async {
    final visibilityDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('isParamVisible');

    await visibilityDoc.update(visibleParams);
  }

  static Stream<DocumentSnapshot<Map<String, dynamic>>> readDateRangePrefs(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('dateRange')
        .snapshots();
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> readTankPrefs(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .snapshots();
  }

  static Future updateDateRangeType(String tankId, String type) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('dateRange');

    await dateRangeDoc.update({'type': type});
  }

  static Future updateCustomStartDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('dateRange');

    await dateRangeDoc.update({'customDateStart': newDate});
  }

  static Future updateCustomEndDate(String tankId, DateTime newDate) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('dateRange');

    await dateRangeDoc.update({'customDateEnd': newDate});
  }

  static Future addDefaultDateRangePrefs(String tankId) async {
    final dateRangeDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .doc(tankId)
        .collection('prefs')
        .doc('dateRange');

    final json = {
      'type': Strings.all,
      'customDateStart': DateTime.now().subtract(const Duration(days: 7)),
      'customDateEnd': DateTime.now(),
    };

    await dateRangeDoc.set(json);
  }
}
