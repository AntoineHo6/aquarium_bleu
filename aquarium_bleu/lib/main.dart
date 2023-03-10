import 'package:aquarium_bleu/pages/all_pages.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
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

  SharedPreferences.getInstance().then((myPrefs) {
    bool isDarkMode = myPrefs.getBool(Strings.isDarkMode) ?? true;

    String lastSelectedParam =
        myPrefs.getString(Strings.lastSelectedParam) ?? Strings.none;

    String waterParamDateRange =
        myPrefs.getString(Strings.waterParamDateRange) ?? Strings.months1;

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => CloudFirestoreProvider()),
          ChangeNotifierProvider(
            create: (_) => SettingsProvider(
              isDarkMode ? ThemeMode.dark : ThemeMode.light,
              // visibleParameters,
              lastSelectedParam,
              waterParamDateRange,
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
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp(
      title: 'Aquarium Bleu',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
      ],
      theme: MyTheme.lightTheme,
      darkTheme: MyTheme.darkTheme,
      themeMode: settingsProvider.themeMode,
      initialRoute: initialRoute,
      routes: customRoutes,
    );
  }
}

String get initialRoute {
  final FirebaseAuth auth = FirebaseAuth.instance;
  if (auth.currentUser == null || auth.currentUser!.isAnonymous) {
    return '/sign-in';
  }

  if (!auth.currentUser!.emailVerified && auth.currentUser!.email != null) {
    return '/verify-email';
  }

  return '/all-pages';
}

void _initUid(BuildContext context) {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid;
  context.read<CloudFirestoreProvider>().uid = uid;
}

var customRoutes = <String, WidgetBuilder>{
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
            Navigator.pushReplacementNamed(context, '/all-pages');
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

            Navigator.pushReplacementNamed(context, '/all-pages');
          }
        }),
      ],
    );
  },
  '/verify-email': (context) {
    return EmailVerificationScreen(
      // headerBuilder: headerIcon(Icons.verified),
      // sideBuilder: sideIcon(Icons.verified),

      // actionCodeSettings:
      //     context.watch<FirebaseAuthProvider>().actionCodeSettings,
      actionCodeSettings: ActionCodeSettings(
        url: 'https://aquariumbleu.page.link',
        // handleCodeInApp: true,
        // androidMinimumVersion: '1',
        // androidPackageName: 'com.example.aquarium_bleu',
        // iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
      ),
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
  '/all-pages': (context) {
    // Set the uid in CloudFireStoreProvider here because we enter this route
    // when the user is logged in.
    _initUid(context);

    return const AllPages();
  },
};
