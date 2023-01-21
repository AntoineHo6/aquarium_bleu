import 'package:aquarium_bleu/pages/all_pages.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/firebase_auth_provider.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Future<SharedPreferences> prefs = SharedPreferences.getInstance();

  prefs.then((myPrefs) {
    bool isDarkMode = myPrefs.getBool('isDarkMode') ?? true;

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FirebaseAuthProvider()),
          ChangeNotifierProvider(create: (_) => CloudFirestoreProvider()),
          ChangeNotifierProvider(
            create: (_) => SettingsProvider(
              isDarkMode ? ThemeMode.dark : ThemeMode.light,
            ),
          ),
        ],
        child: const MyApp(),
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'Aquarium Bleu',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('fr', ''),
      ],
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: themeProvider.getThemeMode(),
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

    return const Temp();
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
