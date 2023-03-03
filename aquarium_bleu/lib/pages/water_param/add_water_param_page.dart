import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class WaterParamPickerPage extends StatefulWidget {
  const WaterParamPickerPage({super.key});

  @override
  State<WaterParamPickerPage> createState() => _WaterParamPickerPageState();
}

class _WaterParamPickerPageState extends State<WaterParamPickerPage> {
  String? _param = 'ammonia'; // TODO: make this the last param added

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final Map visibleParams = settingsProvider.getVisibleParams();
    final List<ListTile> paramRadioBtns = [];

    visibleParams.forEach(
      (paramName, isVisible) => {
        if (isVisible)
          {
            paramRadioBtns.add(
              ListTile(
                title: Text(paramName),
                leading: Radio<String>(
                  value: paramName,
                  groupValue: _param,
                  onChanged: (String? value) {
                    setState(() {
                      _param = value;
                    });
                  },
                ),
              ),
            ),
          },
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addParameterValue),
      ),
      body: ListView(
        children: [
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            shrinkWrap: true,
            childAspectRatio: 5,
            crossAxisCount: 2,
            children: paramRadioBtns,
          ),
          Container(
            margin: const EdgeInsets.only(
              left: Spacing.screenEdgeMargin,
              right: Spacing.screenEdgeMargin,
              top: Spacing.betweenSections,
              bottom: Spacing.screenEdgeMargin,
            ),
            child: ElevatedButton(
              child: const Text('select'),
              onPressed: () => {},
            ),
          ),
        ],
      ),
    );
  }
}
