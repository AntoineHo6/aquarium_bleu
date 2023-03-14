import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WaterParamPickerPage extends StatefulWidget {
  final WaterParamType? currentParam;
  final Map<String, dynamic>? paramVisibility;

  const WaterParamPickerPage(this.currentParam, this.paramVisibility, {super.key});

  @override
  State<WaterParamPickerPage> createState() => _WaterParamPickerPageState();
}

class _WaterParamPickerPageState extends State<WaterParamPickerPage> {
  late WaterParamType? currentParam;
  late List<WaterParamType> visibleParamTypes = [];

  @override
  void initState() {
    super.initState();
    currentParam = widget.currentParam;

    for (var paramType in WaterParamType.values) {
      if (widget.paramVisibility![paramType.getStr]) {
        visibleParamTypes.add(paramType);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            children: visibleParamTypes
                .map((paramType) => ListTile(
                      title: Text(StringUtil.paramTypeToString(context, paramType)), //TODO: use enum
                      leading: Radio<WaterParamType>(
                        value: paramType,
                        groupValue: currentParam,
                        onChanged: (WaterParamType? newCurrentParam) {
                          setState(() {
                            currentParam = newCurrentParam!;
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
                Navigator.pop(context, currentParam);
              },
            ),
          ),
        ],
      ),
    );
  }
}
