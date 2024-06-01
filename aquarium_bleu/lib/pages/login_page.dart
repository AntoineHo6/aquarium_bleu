import 'package:aquarium_bleu/auth.dart';
import 'package:aquarium_bleu/styles/my_theme.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
  late TextEditingController _confirmPasswordController;
  late bool _isPasswordVisible;
  late bool _isConfirmPasswordVisible;

  bool isEmailValid = true;
  bool isPasswordValid = true;
  bool isConfirmPasswordValid = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _isPasswordVisible = false;
    _isConfirmPasswordVisible = false;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/dark_login_bg.png"),
            fit: BoxFit.cover,
            opacity: 0.05,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.screenEdgePadding),
              child: Column(
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
                  Visibility(
                    visible: !isLogin,
                    child: Column(
                      children: [
                        const SizedBox(
                          height: Spacing.betweenSections,
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
                            hintText: AppLocalizations.of(context)!.confirmPassword,
                            errorText: isConfirmPasswordValid
                                ? null
                                : AppLocalizations.of(context)!.emptyField,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                });
                              },
                            ),
                          ),
                          controller: _confirmPasswordController,
                          obscureText: !_isConfirmPasswordVisible,
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isLogin,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/forgot-password',
                            arguments: {'email': _emailController.text},
                          );
                        },
                        child: Text(AppLocalizations.of(context)!.forgotPassword),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: Spacing.betweenSections,
                  ),
                  Container(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                      ),
                      onPressed: isLogin ? _handleLogin : createUserWithEmailAndPassword,
                      child: Text(
                        isLogin
                            ? AppLocalizations.of(context)!.signIn
                            : AppLocalizations.of(context)!.signUp,
                      ),
                    ),
                  ),
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
                  GoogleSignInIconButton(
                    clientId:
                        '36684847155-fv4cjr066likbl4cbqkrllpa0nq9mnvi.apps.googleusercontent.com',
                    loadingIndicator: CircularProgressIndicator.adaptive(),
                    onSignedIn: (credential) {
                      Navigator.pushReplacementNamed(context, '/all-pages');
                    },
                  ),
                  const SizedBox(
                    height: Spacing.betweenSections,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isLogin
                            ? AppLocalizations.of(context)!.dontHaveAnAccount
                            : AppLocalizations.of(context)!.alreadyHaveAnAccount,
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        child: Text(
                          isLogin
                              ? AppLocalizations.of(context)!.signUp
                              : AppLocalizations.of(context)!.signIn,
                        ),
                      ),
                    ],
                  ),
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

  Future<void> handleSignUp() async {}
}
