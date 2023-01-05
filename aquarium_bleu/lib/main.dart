import 'package:aquarium_bleu/pages/tanks_home_page.dart';
import 'package:aquarium_bleu/widgets/tank_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (FirebaseAuth.instance.currentUser == null) {
    print("user is not signed in");
  } else {
    runApp(const MyApp('/'));
  }
}

class MyApp extends StatelessWidget {
  const MyApp(this.myInitialRoute, {super.key});

  final String myInitialRoute;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[300],
      ),
      initialRoute: myInitialRoute,
      routes: {
        '/': (context) => TanksHomePage(),
        '/sign-in': (context) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
          );
        }
      },
    );
  }
}
