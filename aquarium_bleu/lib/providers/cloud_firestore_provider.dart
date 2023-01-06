import 'package:aquarium_bleu/tank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
      throw e;
    }
  }

  Stream<List<Tank>> readTanks() => FirebaseFirestore.instance
      .collection('users')
      .doc(_uid)
      .collection('tanks')
      .snapshots()
      .map((event) =>
          event.docs.map((doc) => Tank.fromJson(doc.data())).toList());
}
