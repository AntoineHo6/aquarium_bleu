import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    // final mfaAction = AuthStateChangeAction<MFARequired>(
    //   (context, state) async {
    //     final nav = Navigator.of(context);

    //     await startMFAVerification(
    //       resolver: state.resolver,
    //       context: context,
    //     );

    //     nav.pushReplacementNamed('/profile');
    //   },
    // );

    return Scaffold(
      appBar: AppBar(),
      body: SignInScreen(
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
              openEmailVerfScreen(context);
            } else {
              Navigator.pop(context);
            }
          }),
          AuthStateChangeAction<UserCreated>((context, state) {
            if (!state.credential.user!.emailVerified) {
              openEmailVerfScreen(context);
            } else {
              Navigator.pop(context);
            }
          }),
          AuthStateChangeAction<CredentialLinked>((context, state) {
            if (!state.user.emailVerified) {
              openEmailVerfScreen(context);
            } else {
              Navigator.pop(context);
            }
          }),
          // mfaAction,
          EmailLinkSignInAction((context) {
            Navigator.pushReplacementNamed(context, '/email-link-sign-in');
          }),
        ],
      ),
    );
  }
}

void openEmailVerfScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => EmailVerificationScreen(
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
            // Navigator.pushReplacementNamed(context, '/all-pages');
          }),
          AuthCancelledAction((context) {
            Navigator.pop(context);
            // FirebaseUIAuth.signOut(context: context);
            // Navigator.pushReplacementNamed(context, '/sign-in');
          }),
        ],
      ),
    ),
  );
}
