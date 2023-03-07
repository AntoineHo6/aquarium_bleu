import 'package:aquarium_bleu/models/tank.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFuncs {
  static Stream<List<Tank>> readTanks(String uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('tanks')
        .snapshots()
        .map((event) => event.docs
            .map((doc) => Tank.fromJson(doc.id, doc.data()))
            .toList());
  }
}
