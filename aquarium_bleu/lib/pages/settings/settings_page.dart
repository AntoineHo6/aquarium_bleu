import 'package:aquarium_bleu/pages/settings/about_page.dart';
import 'package:aquarium_bleu/pages/settings/contact_page.dart';
import 'package:aquarium_bleu/pages/settings/theme_page.dart';
import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
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
    final tankProvider = Provider.of<TankProvider>(context, listen: false);
    final settingsProvider = Provider.of<SettingsProvider>(context);

    String themeStr;

    if (settingsProvider.themeMode == ThemeMode.dark) {
      themeStr = AppLocalizations.of(context)!.dark;
    } else if (settingsProvider.themeMode == ThemeMode.light) {
      themeStr = AppLocalizations.of(context)!.light;
    } else {
      themeStr = AppLocalizations.of(context)!.system;
    }

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(Spacing.screenEdgePadding),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Text(
                AppLocalizations.of(context)!.settings,
                style: Theme.of(context).textTheme.headlineLarge,
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                FirebaseAuth.instance.currentUser!.email!,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.general,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.theme),
              subtitle: Text(themeStr),
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
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  AppLocalizations.of(context)!.info,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.contact),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ContactPage(),
                  ),
                );
              },
            ),
            // ListTile(
            //   title: Text(AppLocalizations.of(context)!.about),
            //   trailing: const Icon(Icons.chevron_right),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const AboutPage(),
            //       ),
            //     );
            //   },
            // ),
            const SizedBox(
              height: Spacing.betweenSections,
            ),
            ListTile(
              title: Text(AppLocalizations.of(context)!.signOut),
              trailing: const Icon(Icons.chevron_right),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                await Navigator.pushReplacementNamed(context, '/sign-in');
              },
            ),
          ],
        ),
      ),
    );
  }
}
