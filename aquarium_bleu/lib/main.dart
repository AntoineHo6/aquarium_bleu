import 'package:aquarium_bleu/pages/tanks_home_page.dart';
import 'package:aquarium_bleu/widgets/tank_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_auth/firebase_auth.dart'
    hide PhoneAuthProvider, EmailAuthProvider;
import 'package:flutter/material.dart';

final actionCodeSettings = ActionCodeSettings(
  url: 'https://aquariumbleu.page.link',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  androidPackageName: 'com.example.aquarium_bleu',
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[300],
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => TanksHomePage(),
        '/sign-in': (context) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
            ],
            actions: [
              AuthStateChangeAction<UserCreated>((context, state) {
                if (!state.credential.user!.emailVerified) {
                  print("NEED VERIFY");
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  print("VERIFIIIIIIIIIEEEEEDD");
                  Navigator.pushReplacementNamed(context, '/');
                }
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                if (!state.user!.emailVerified) {
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.pushReplacementNamed(context, '/');
                }
              }),
            ],
          );
        },
        '/verify-email': (context) {
          return EmailVerificationScreen(
            // headerBuilder: headerIcon(Icons.verified),
            // sideBuilder: sideIcon(Icons.verified),
            actionCodeSettings: actionCodeSettings,
            actions: [
              EmailVerifiedAction(() {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
              AuthCancelledAction((context) {
                FirebaseUIAuth.signOut(context: context);
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
      },
    );
  }
}
