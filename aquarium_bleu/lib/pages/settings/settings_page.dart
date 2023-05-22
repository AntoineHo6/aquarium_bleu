import 'package:aquarium_bleu/pages/settings/theme_page.dart';
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
          ListTile(
            title: Text(AppLocalizations.of(context).theme),
            subtitle: settingsProvider.themeMode == ThemeMode.dark
                ? Text(AppLocalizations.of(context).dark)
                : Text(AppLocalizations.of(context).light),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ThemePage(),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () {
              FirebaseUIAuth.signOut(context: context);
              Navigator.pushReplacementNamed(context, '/sign-in');
            },
            child: Text(AppLocalizations.of(context).signOut),
          ),
        ],
      ),
    );
  }
}
