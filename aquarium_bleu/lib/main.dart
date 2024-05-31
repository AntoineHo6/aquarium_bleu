import 'package:aquarium_bleu/pages/all_pages.dart';
import 'package:aquarium_bleu/pages/login_page.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/sign_in_decorations.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

final actionCodeSettings = ActionCodeSettings(
  url: 'https://aquarium-bleu.web.app/',
  handleCodeInApp: true,
  androidMinimumVersion: '21',
  androidPackageName: 'com.aquarium_bleu',
  iOSBundleId: 'com.aquariumbleu',
);
final emailLinkProviderConfig = EmailLinkAuthProvider(actionCodeSettings: actionCodeSettings);

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseUIAuth.configureProviders([
    EmailAuthProvider(),
    emailLinkProviderConfig,
    GoogleProvider(
      clientId: '36684847155-fv4cjr066likbl4cbqkrllpa0nq9mnvi.apps.googleusercontent.com',
    ),
  ]);

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
          ChangeNotifierProvider(
            create: (_) => TankProvider(),
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
      builder: FToastBuilder(),
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
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
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/all-pages',
      routes: {
        '/sign-in': (context) {
          return LoginPage();
          // return SignInScreen(
          //   showPasswordVisibilityToggle: true,
          //   providers: [
          //     EmailAuthProvider(),
          //     GoogleProvider(
          //       clientId: '36684847155-fv4cjr066likbl4cbqkrllpa0nq9mnvi.apps.googleusercontent.com',
          //     ),
          //   ],
          //   actions: [
          //     ForgotPasswordAction((context, email) {
          //       Navigator.pushNamed(
          //         context,
          //         '/forgot-password',
          //         arguments: {'email': email},
          //       );
          //     }),
          //     AuthStateChangeAction<SignedIn>((context, state) {
          //       if (!state.user!.emailVerified) {
          //         Navigator.pushNamed(context, '/verify-email');
          //       } else {
          //         Navigator.pushReplacementNamed(context, '/all-pages');
          //       }
          //     }),
          //     AuthStateChangeAction<UserCreated>((context, state) {
          //       if (!state.credential.user!.emailVerified) {
          //         Navigator.pushNamed(context, '/verify-email');
          //       } else {
          //         Navigator.pushReplacementNamed(context, '/all-pages');
          //       }
          //     }),
          //     AuthStateChangeAction<CredentialLinked>((context, state) {
          //       if (!state.user.emailVerified) {
          //         Navigator.pushNamed(context, '/verify-email');
          //       } else {
          //         Navigator.pushReplacementNamed(context, '/all-pages');
          //       }
          //     }),
          //   ],
          //   subtitleBuilder: (context, action) {
          //     return Padding(
          //       padding: const EdgeInsets.only(bottom: 8),
          //       child: Text(
          //         action == AuthAction.signIn
          //             ? AppLocalizations.of(context)!.signInWelcomeMsg
          //             : AppLocalizations.of(context)!.createAccWelcomeMsg,
          //       ),
          //     );
          //   },
          // );
        },
        '/verify-email': (context) {
          return EmailVerificationScreen(
            headerBuilder: headerIcon(Icons.verified),
            sideBuilder: sideIcon(Icons.verified),
            actionCodeSettings: actionCodeSettings,
            actions: [
              EmailVerifiedAction(() {
                Navigator.pop(context);
              }),
              AuthCancelledAction((context) {
                FirebaseUIAuth.signOut(context: context).then((value) {
                  Navigator.pop(context);
                });
              }),
            ],
          );
        },
        '/forgot-password': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'],
            headerMaxExtent: 200,
            headerBuilder: headerIcon(Icons.lock),
            sideBuilder: sideIcon(Icons.lock),
          );
        },
        '/all-pages': (context) => const AllPages(),
      },
    );
  }
}

// TODO fix: when first creating an account, it will show the mesg acc doesnt exist.