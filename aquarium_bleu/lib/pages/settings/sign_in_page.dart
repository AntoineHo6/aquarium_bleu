import 'package:aquarium_bleu/main.dart';
import 'package:aquarium_bleu/styles/sign_in_decorations.dart';
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
          // ForgotPasswordAction((context, email) {
          //   Navigator.pushNamed(
          //     context,
          //     '/forgot-password',
          //     arguments: {'email': email},
          //   );
          // }),
          VerifyPhoneAction((context, _) {
            Navigator.pushNamed(context, '/phone');
          }),
          AuthStateChangeAction<SignedIn>((context, state) {
            if (!state.user!.emailVerified) {
              openEmailVerfScreen(context);
            } else {
              // TODO: if user signs in with an existing acc from an anonymous one,
              //       ask if they want to migrate current data or not
              // 1. if yes, copy tanks (make an algorithm)
              // 2. paste tanks to existing user account

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
          // EmailLinkSignInAction((context) {
          //   Navigator.pushReplacementNamed(context, '/email-link-sign-in');
          // }),
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
                  .then((value) => Navigator.pushNamed(context, '/all-pages'));
            });
          }),
        ],
      ),
    ),
  );
}

// TODO fix: when first creating an account, it will show the mesg acc doesnt exist.
