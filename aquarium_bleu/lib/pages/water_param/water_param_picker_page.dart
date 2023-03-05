import 'package:aquarium_bleu/providers/settings_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WaterParamPickerPage extends StatefulWidget {
  String? param;

  WaterParamPickerPage(this.param, {super.key});

  @override
  State<WaterParamPickerPage> createState() => _WaterParamPickerPageState();
}

class _WaterParamPickerPageState extends State<WaterParamPickerPage> {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final Map visibleParams = settingsProvider.getVisibleParams();
    final List<ListTile> paramRadioBtns = [];
    visibleParams.forEach((param, isVisible) => {
          if (isVisible)
            {
              paramRadioBtns.add(
                ListTile(
                  title: Text(StringUtil.paramToString(context, param)),
                  leading: Radio<String>(
                    value: param,
                    groupValue: widget.param,
                    onChanged: (String? value) {
                      setState(() {
                        widget.param = value!;
                      });
                    },
                  ),
                ),
              )
            }
        });

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
            ),
            child: ElevatedButton(
              child: Text(AppLocalizations.of(context).select),
              onPressed: () {
                Navigator.pop(context, widget.param);
              },
            ),
          ),
        ],
      ),
    );
  }
}
