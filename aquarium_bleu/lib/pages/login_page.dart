import 'package:aquarium_bleu/auth.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? errMsg = '';
  bool isLogin = true;

  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late bool _isPasswordVisible;

  bool isEmailValid = true;
  bool isPasswordValid = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _isPasswordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/dark_login_bg_2.png"),
                fit: BoxFit.cover,
                opacity: 0.05,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(Spacing.screenEdgePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      "Aquarium Bleu",
                      style: Theme.of(context).textTheme.displaySmall,
                    ),
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: MyTheme.seedColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      hintText: AppLocalizations.of(context)!.email,
                      errorText: isEmailValid ? null : AppLocalizations.of(context)!.emptyField,
                    ),
                    controller: _emailController,
                  ),
                  const SizedBox(
                    height: Spacing.betweenSections,
                  ),
                  TextField(
                    decoration: new InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: MyTheme.seedColor),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                        borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
                      ),
                      hintText: AppLocalizations.of(context)!.password,
                      errorText: isPasswordValid ? null : AppLocalizations.of(context)!.emptyField,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {},
                      child: Text(AppLocalizations.of(context)!.forgotPassword),
                    ),
                  ),
                  const SizedBox(
                    height: Spacing.betweenSections,
                  ),
                  FilledButton(
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: isLogin ? _handleLogin : createUserWithEmailAndPassword,
                    child: Text(AppLocalizations.of(context)!.login),
                  ),
                  // const SizedBox(
                  //   height: Spacing.betweenSections,
                  // ),
                  Center(
                    child: Text(
                      errMsg!,
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                  const SizedBox(
                    height: Spacing.betweenSections,
                  ),
                  Row(children: <Widget>[
                    Expanded(child: Divider()),
                    Text(
                      AppLocalizations.of(context)!.or,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    Expanded(child: Divider()),
                  ]),
                  const SizedBox(
                    height: Spacing.betweenSections,
                  ),
                  GoogleSignInButton(
                    clientId:
                        '36684847155-fv4cjr066likbl4cbqkrllpa0nq9mnvi.apps.googleusercontent.com',
                    loadingIndicator: CircularProgressIndicator.adaptive(),
                    onSignedIn: (credential) async {
                      await Navigator.pushReplacementNamed(context, '/all-pages');
                    },
                  ),
                  // GoogleSignInIconButton(
                  //   clientId: '36684847155-fv4cjr066likbl4cbqkrllpa0nq9mnvi.apps.googleusercontent.com',
                  //   loadingIndicator: CircularProgressIndicator.adaptive(),
                  //   onSignedIn: (credential) {
                  //     Navigator.pushReplacementNamed(context, '/all-pages');
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      await Auth().signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      await Navigator.pushReplacementNamed(context, '/all-pages');
    } on FirebaseAuthException catch (e) {
      setState(() {
        errMsg = e.message;
      });
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _emailController.text, password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      setState(() {
        errMsg = e.message;
      });
    }
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        isEmailValid = false;
      });
    } else {
      isEmailValid = true;
    }

    if (password.isEmpty) {
      setState(() {
        isPasswordValid = false;
      });
    } else {
      isPasswordValid = true;
    }

    await signInWithEmailAndPassword();
  }
}
