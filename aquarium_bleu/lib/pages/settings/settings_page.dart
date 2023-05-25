import 'package:aquarium_bleu/pages/settings/theme_page.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

    Widget btn = FirebaseAuth.instance.currentUser!.isAnonymous
        ? ElevatedButton(
            child: Text(AppLocalizations.of(context).signIn),
            onPressed: () {
              Navigator.pushNamed(context, '/sign-in');
            },
          )
        : ElevatedButton(
            child: Text(AppLocalizations.of(context).signOut),
            onPressed: () {
              FirebaseAuth.instance
                  .signOut()
                  .then((value) => FirebaseAuth.instance.signInAnonymously().then(
                        (value) => setState(() {}),
                      ));
            },
          );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.screenEdgePadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                  FirebaseAuth.instance.currentUser!.email ??
                      AppLocalizations.of(context).noAccountConnected,
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
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
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: btn,
            ),
          ],
        ),
      ),
    );
  }
}
