import 'package:aquarium_bleu/models/nitrate.dart';
import 'package:aquarium_bleu/models/tank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class CloudFirestoreProvider extends ChangeNotifier {
  late String _uid;

  set uid(String uid) {
    _uid = uid;
  }

  void writeNewUser(String? uid, String? email) async {
    _uid = uid!;
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

    final json = {'email': email};

    await docUser.set(json);
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance.collection('users');

      var doc = await collectionRef.doc(docId).get();

      return doc.exists;
    } catch (e) {
      rethrow;
    }
  }

  Stream<List<Tank>> readTanks() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('tanks')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Tank.fromJson(doc.id, doc.data()))
            .toList());
  }

  Stream<List<Nitrate>> readNitrates(String tankId) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('tanks')
        .doc(tankId)
        .collection('nitrates')
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => Nitrate.fromJson(doc.data())).toList());
  }

  Future createTank(String name, bool isFreshWater) async {
    final docTank = FirebaseFirestore.instance
        .collection('users')
        .doc(_uid)
        .collection('tanks')
        .doc(const Uuid().v4());

    final json = {
      'name': name,
      'isFreshwater': isFreshWater,
    };

    await docTank.set(json);
  }
}
