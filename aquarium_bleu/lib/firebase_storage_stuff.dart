import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FirebaseStorageStuff {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future uploadImg(String name, String path) async {
    File img = File(path);

    Uint8List? bytes = await FlutterImageCompress.compressWithFile(img.path, quality: 25);
    final Directory systemTempDir = Directory.systemTemp;
    final File file = await File('${systemTempDir.path}/$name').create();
    file.writeAsBytes(bytes!);

    try {
      await storage.ref('${FirebaseAuth.instance.currentUser!.uid}/$name').putFile(file);
    } on FirebaseException catch (_) {
      // print(e);
    }
  }
}
