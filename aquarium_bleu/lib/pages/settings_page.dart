import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              FirebaseUIAuth.signOut(context: context);
              Navigator.pushReplacementNamed(context, '/sign-in');
            },
            child: const Text("Sign out"),
          ),
          Switch.adaptive(
            value: settingsProvider.getThemeMode() == ThemeMode.dark
                ? true
                : false,
            onChanged: (newValue) async =>
                await _onThemeChanged(newValue, settingsProvider),
          ),
          const Text('nitrate'),
          Switch.adaptive(
            value:
                settingsProvider.getVisibleParams()['nitrate'] ? true : false,
            onChanged: (newValue) async =>
                await settingsProvider.setVisibleParam('nitrate', newValue),
          ),
        ],
      ),
    );
  }
}

Future<void> _onThemeChanged(
    bool isDarkMode, SettingsProvider settingsProvider) async {
  (isDarkMode)
      ? await settingsProvider.setThemeMode(ThemeMode.dark, isDarkMode)
      : await settingsProvider.setThemeMode(ThemeMode.light, isDarkMode);
}
