import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  const ThemePage({super.key});

  @override
  State<ThemePage> createState() => ThemePageState();
}

class ThemePageState extends State<ThemePage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.theme),
        ),
        body: Column(
          children: [
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.system),
              value: ThemeMode.system,
              groupValue: settingsProvider.themeMode,
              onChanged: (newTheme) async =>
                  await _onThemeChanged(newTheme as ThemeMode, settingsProvider),
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.light),
              value: ThemeMode.light,
              groupValue: settingsProvider.themeMode,
              onChanged: (newTheme) async =>
                  await _onThemeChanged(newTheme as ThemeMode, settingsProvider),
            ),
            RadioListTile(
              title: Text(AppLocalizations.of(context)!.dark),
              value: ThemeMode.dark,
              groupValue: settingsProvider.themeMode,
              onChanged: (newTheme) async =>
                  await _onThemeChanged(newTheme as ThemeMode, settingsProvider),
            )
          ],
        ));
  }
}

Future<void> _onThemeChanged(ThemeMode newTheme, SettingsProvider settingsProvider) async {
  switch (newTheme) {
    case ThemeMode.system:
      await settingsProvider.setThemeMode(ThemeMode.system, Strings.system);
      break;
    case ThemeMode.light:
      await settingsProvider.setThemeMode(ThemeMode.light, Strings.light);
      break;
    case ThemeMode.dark:
      await settingsProvider.setThemeMode(ThemeMode.dark, Strings.dark);
      break;
  }
}
