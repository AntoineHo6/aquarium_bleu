import 'package:aquarium_bleu/pages/all_pages.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/sign_in_decorations.dart';
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

  if (FirebaseAuth.instance.currentUser == null) {
    await FirebaseAuth.instance.signInAnonymously();
  }

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
      debugShowCheckedModeBanner: false,
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
        '/sign-in': (context) {
          return SignInScreen(
            providers: [
              EmailAuthProvider(),
              GoogleProvider(
                clientId: '36684847155-ljau3rf4gqpv9pq71ld1hp1p9ak7o0ir.apps.googleusercontent.com',
              ),
            ],
            actions: [
              ForgotPasswordAction((context, email) {
                Navigator.pushNamed(
                  context,
                  '/forgot-password',
                  arguments: {'email': email},
                );
              }),
              VerifyPhoneAction((context, _) {
                Navigator.pushNamed(context, '/phone');
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                if (!state.user!.emailVerified) {
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  // TODO: if user signs in with an existing acc from an anonymous one,
                  //       ask if they want to migrate current data or not
                  // 1. if yes, copy tanks (make an algorithm)
                  // 2. paste tanks to existing user account

                  Navigator.pop(context);
                  Navigator.pushReplacementNamed(context, '/all-pages');
                }
              }),
              AuthStateChangeAction<UserCreated>((context, state) {
                if (!state.credential.user!.emailVerified) {
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.pushReplacementNamed(context, '/all-pages');
                }
              }),
              AuthStateChangeAction<CredentialLinked>((context, state) {
                if (!state.user.emailVerified) {
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.pushReplacementNamed(context, '/all-pages');
                }
              }),
              // EmailLinkSignInAction((context) {
              //   Navigator.pushReplacementNamed(context, '/email-link-sign-in');
              // }),
            ],
            styles: const {
              EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
            },
            headerBuilder: backBtn(),
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  action == AuthAction.signIn
                      ? 'Welcome to Firebase UI! Please sign in to continue.'
                      : 'Welcome to Firebase UI! Please create an account to continue',
                ),
              );
            },
          );
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
                  FirebaseAuth.instance
                      .signInAnonymously()
                      .then((value) => Navigator.pushNamed(context, '/sign-in'));
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
        '/all-pages': (context) {
          return const AllPages();
        },
      },
    );
  }
}

// TODO fix: when first creating an account, it will show the mesg acc doesnt exist.