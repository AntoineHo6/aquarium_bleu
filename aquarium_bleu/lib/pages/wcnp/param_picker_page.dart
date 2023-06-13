import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ParamPickerPage extends StatefulWidget {
  final WaterParamType? currentParam;
  final Map<String, dynamic>? paramVis;

  const ParamPickerPage(this.currentParam, this.paramVis, {super.key});

  @override
  State<ParamPickerPage> createState() => _ParamPickerPageState();
}

class _ParamPickerPageState extends State<ParamPickerPage> {
  late WaterParamType? currentParam;
  late List<WaterParamType> visibleParamTypes = [];

  @override
  void initState() {
    super.initState();
    currentParam = widget.currentParam;

    for (var paramType in WaterParamType.values) {
      if (widget.paramVis![paramType.getStr]) {
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
            childAspectRatio: 4,
            crossAxisCount: 2,
            children: visibleParamTypes
                .map((paramType) => ListTile(
                      title: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(StringUtil.paramTypeToString(context, paramType)),
                      ),
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
          Padding(
            padding: const EdgeInsets.only(
              left: Spacing.screenEdgePadding,
              right: Spacing.screenEdgePadding,
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
