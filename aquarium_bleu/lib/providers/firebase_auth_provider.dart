import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthProvider extends ChangeNotifier {
  final actionCodeSettings = ActionCodeSettings(
    url: 'https://aquariumbleu.page.link',
    // handleCodeInApp: true,
    // androidMinimumVersion: '1',
    // androidPackageName: 'com.example.aquarium_bleu',
    // iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
  );

  String get initialRoute {
    final auth = FirebaseAuth.instance;

    if (auth.currentUser == null || auth.currentUser!.isAnonymous) {
      return '/sign-in';
    }

    if (!auth.currentUser!.emailVerified && auth.currentUser!.email != null) {
      return '/verify-email';
    }

    return '/';
  }
}
