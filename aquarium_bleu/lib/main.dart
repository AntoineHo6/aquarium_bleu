import 'package:aquarium_bleu/pages/all_pages.dart';
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

final actionCodeSettings = ActionCodeSettings(
  url: 'https://aquariumbleu.page.link',
  handleCodeInApp: true,
  androidMinimumVersion: '1',
  androidPackageName: 'com.example.aquarium_bleu',
  iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
);
final emailLinkProviderConfig = EmailLinkAuthProvider(actionCodeSettings: actionCodeSettings);

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    emailLinkProviderConfig,
    GoogleProvider(
        clientId: '36684847155-ljau3rf4gqpv9pq71ld1hp1p9ak7o0ir.apps.googleusercontent.com'),
  ]);

  await FirebaseAuth.instance.signInAnonymously();

  SharedPreferences.getInstance().then((myPrefs) {
    String themeStr = myPrefs.getString(Strings.theme) ?? Strings.system;

    String? lastSelectedParam = myPrefs.getString(Strings.lastSelectedParam);

    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => SettingsProvider(
              themeStr,
              lastSelectedParam,
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
      initialRoute: '/all-pages',
      routes: {
        // '/verify-email': (context) {
        //   return EmailVerificationScreen(
        //     // headerBuilder: headerIcon(Icons.verified),
        //     // sideBuilder: sideIcon(Icons.verified),

        //     // actionCodeSettings:
        //     //     context.watch<FirebaseAuthProvider>().actionCodeSettings,
        //     actionCodeSettings: ActionCodeSettings(
        //       url: 'https://aquariumbleu.page.link',
        //       // handleCodeInApp: true,
        //       // androidMinimumVersion: '1',
        //       // androidPackageName: 'com.example.aquarium_bleu',
        //       // iOSBundleId: 'io.flutter.plugins.fireabaseUiExample',
        //     ),
        //     actions: [
        //       EmailVerifiedAction(() {
        //         Navigator.pushReplacementNamed(context, '/profile');
        //       }),
        //       AuthCancelledAction((context) {
        //         FirebaseUIAuth.signOut(context: context);
        //         Navigator.pushReplacementNamed(context, '/sign-in');
        //       }),
        //     ],
        //   );
        // },
        '/all-pages': (context) {
          return const AllPages();
        },
      },
    );
  }
}
