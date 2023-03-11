import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class WaterParamPickerPage extends StatefulWidget {
  String? param;
  final List<String> visibleParams;

  WaterParamPickerPage(this.param, this.visibleParams, {super.key});

  @override
  State<WaterParamPickerPage> createState() => _WaterParamPickerPageState();
}

class _WaterParamPickerPageState extends State<WaterParamPickerPage> {
  @override
  Widget build(BuildContext context) {
    final List<ListTile> paramRadioBtns = [];
    // print('about to loop');
    for (String param in widget.visibleParams) {
      // print(param);
    }

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
            children: widget.visibleParams
                .map((param) => ListTile(
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
                    ))
                .toList(),
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
