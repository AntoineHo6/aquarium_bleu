import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TuneChartPage extends StatefulWidget {
  final String tankId;
  final String currentDateRangeType;
  final DateTime customDateStart;
  final DateTime customDateEnd;
  final Map<String, dynamic>? visibleParams;

  const TuneChartPage(this.tankId, this.currentDateRangeType, this.customDateStart,
      this.customDateEnd, this.visibleParams,
      {super.key});

  @override
  State<TuneChartPage> createState() => _TuneChartPageState();
}

class _TuneChartPageState extends State<TuneChartPage> {
  bool isSelected = false;
  late String currentDateRangeType;
  late DateTime customDateStart;
  late DateTime customDateEnd;
  late Map<String, dynamic> visibleParams;

  @override
  void initState() {
    super.initState();
    currentDateRangeType = widget.currentDateRangeType;
    customDateStart = widget.customDateStart;
    customDateEnd = widget.customDateEnd;
    visibleParams = widget.visibleParams!;
  }

  @override
  Widget build(BuildContext context) {
    // populate choiceChips list
    List<Widget> choiceChips = [];
    for (var paramType in WaterParamType.values) {
      choiceChips.add(ChoiceChip(
        label: Text(StringUtil.paramToString(context, paramType.getStr)), // TODO: use enum
        selected: widget.visibleParams![paramType.getStr],
        onSelected: (newValue) async {
          setState(() {
            visibleParams[paramType.getStr] = newValue;
          });
        },
      ));
    }

    // populate date range radiobtns list
    List<Widget> dateRangeRadioBtns = [];
    for (String dateRangeType in Strings.dateRangeTypes) {
      dateRangeRadioBtns.add(
        ListTile(
          title: Text(StringUtil.dateRangeTypeToString(context, dateRangeType)),
          leading: Radio<String>(
            value: dateRangeType,
            groupValue: currentDateRangeType,
            onChanged: (String? value) async {
              setState(() {
                currentDateRangeType = value!;
              });
            },
          ),
        ),
      );
    }

    return WillPopScope(
      onWillPop: () async {
        await FirestoreStuff.updateParamVisPrefs(widget.tankId, visibleParams);
        await FirestoreStuff.updateDateRangeType(widget.tankId, currentDateRangeType);
        await FirestoreStuff.updateCustomStartDate(widget.tankId, customDateStart);
        await FirestoreStuff.updateCustomEndDate(widget.tankId, customDateEnd);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).dateRange,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  childAspectRatio: 4,
                  crossAxisCount: 2,
                  children: dateRangeRadioBtns,
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    IconTextBtn(
                      iconData: Icons.date_range,
                      text: StringUtil.formattedDate(context, customDateStart),
                      onPressed: currentDateRangeType == Strings.custom
                          ? () => _handleCustomDateStartBtn(context)
                          : null,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      '-',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    IconTextBtn(
                      iconData: Icons.date_range,
                      text: StringUtil.formattedDate(context, customDateEnd),
                      onPressed: currentDateRangeType == Strings.custom
                          ? () => _handleCustomDateEndBtn(context)
                          : null,
                    )
                  ],
                ),
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Text(
                  AppLocalizations.of(context).visibleParameters,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Wrap(
                  spacing: 10,
                  children: choiceChips,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _handleCustomDateStartBtn(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: customDateStart,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((newDate) async {
      if (newDate != null) {
        setState(() {
          customDateStart = newDate;
        });
      }
    });
  }

  _handleCustomDateEndBtn(BuildContext context) {
    showDatePicker(
      context: context,
      initialDate: customDateEnd,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    ).then((newDate) async {
      if (newDate != null) {
        setState(() {
          customDateEnd = newDate;
        });
      }
    });
  }
}
