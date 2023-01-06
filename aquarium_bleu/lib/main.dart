import 'package:aquarium_bleu/pages/tanks_page.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/firebase_auth_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (_) => CloudFirestoreProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      initialRoute: context.watch<FirebaseAuthProvider>().initialRoute,
      routes: customRoutes,
    );
  }
}

var customRoutes = <String, WidgetBuilder>{
  '/': (context) {
    // Set the uid in CloudFireStoreProvider here because we enter this route
    // when the user is logged in.
    String uid = context.read<FirebaseAuthProvider>().auth.currentUser!.uid;
    context.read<CloudFirestoreProvider>().uid = uid;

    return const TanksPage();
  },
  '/sign-in': (context) {
    return SignInScreen(
      providers: [
        EmailAuthProvider(),
        GoogleProvider(
          clientId:
              '36684847155-ljau3rf4gqpv9pq71ld1hp1p9ak7o0ir.apps.googleusercontent.com',
        ),
      ],
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          if (!state.credential.user!.emailVerified) {
            Navigator.pushNamed(context, '/verify-email');
          } else {
            Navigator.pushReplacementNamed(context, '/');
          }
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          if (!state.user!.emailVerified) {
            Navigator.pushNamed(context, '/verify-email');
          } else {
            Provider.of<CloudFirestoreProvider>(context, listen: false)
                .checkIfDocExists(state.user!.uid)
                .then((value) {
              if (!value) {
                Provider.of<CloudFirestoreProvider>(context, listen: false)
                    .writeNewUser(state.user!.uid, state.user!.email);
              }
            });

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
      actionCodeSettings:
          context.watch<FirebaseAuthProvider>().actionCodeSettings,
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
};
