import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
// import 'package:firebase_core/firebase_core.dart';

class FirebaseStorageStuff {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadImg(String name, String path) async {
    File file = File(path);

    try {
      await storage.ref('${FirebaseAuth.instance.currentUser!.uid}/$name').putFile(file);
    } on FirebaseException catch (_) {
      // print(e);
    }
  }
}
