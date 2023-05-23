import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:aquarium_bleu/widgets/icon_text_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WcnpTunePage extends StatefulWidget {
  final String tankId;
  final DateRangeType currentDateRangeType;
  final DateTime customDateStart;
  final DateTime customDateEnd;
  final Map<String, dynamic>? visibleParams;
  final bool showWaterChanges;

  const WcnpTunePage(this.tankId, this.currentDateRangeType, this.customDateStart,
      this.customDateEnd, this.visibleParams, this.showWaterChanges,
      {super.key});

  @override
  State<WcnpTunePage> createState() => _WcnpTunePageState();
}

class _WcnpTunePageState extends State<WcnpTunePage> {
  bool isSelected = false;
  late DateRangeType currentDateRangeType;
  late DateTime customDateStart;
  late DateTime customDateEnd;
  late Map<String, dynamic> visibleParams;
  late int numOfVisibleParams;
  late bool showWaterChanges;

  @override
  void initState() {
    super.initState();
    currentDateRangeType = widget.currentDateRangeType;
    customDateStart = widget.customDateStart;
    customDateEnd = widget.customDateEnd;
    visibleParams = widget.visibleParams!;
    numOfVisibleParams = 0;
    for (var paramType in WaterParamType.values) {
      if (widget.visibleParams![paramType.getStr]) {
        numOfVisibleParams++;
      }
    }
    showWaterChanges = widget.showWaterChanges;
  }

  @override
  Widget build(BuildContext context) {
    // populate date range radiobtns list
    List<Widget> dateRangeRadioBtns = [];
    for (var dateRangeType in DateRangeType.values) {
      dateRangeRadioBtns.add(
        ListTile(
          title: Text(StringUtil.dateRangeTypeToString(context, dateRangeType)),
          leading: Radio<DateRangeType>(
            value: dateRangeType,
            groupValue: currentDateRangeType,
            onChanged: (DateRangeType? value) async {
              setState(() {
                currentDateRangeType = value!;
              });
            },
          ),
        ),
      );
    }

    // populate choiceChips list && count number of visible parameters
    List<Widget> choiceChips = [];
    for (var paramType in WaterParamType.values) {
      choiceChips.add(ChoiceChip(
        label: Text(StringUtil.paramTypeToString(context, paramType)),
        selected: widget.visibleParams![paramType.getStr],
        onSelected: (isVisible) {
          setState(() {
            if (numOfVisibleParams > 1 && !isVisible) {
              numOfVisibleParams--;
              visibleParams[paramType.getStr] = isVisible;
            } else if (isVisible) {
              numOfVisibleParams++;
              visibleParams[paramType.getStr] = isVisible;
            } else {
              // animate a nono animation to show that there has to be at least 1 visible param.
            }
          });
        },
      ));
    }

    return WillPopScope(
      onWillPop: () async {
        await FirestoreStuff.updateDateRangeType(widget.tankId, currentDateRangeType);
        await FirestoreStuff.updateCustomStartDate(widget.tankId, customDateStart);
        await FirestoreStuff.updateCustomEndDate(widget.tankId, customDateEnd);
        await FirestoreStuff.updateParamVis(widget.tankId, visibleParams);
        await FirestoreStuff.updateShowWaterChanges(widget.tankId, showWaterChanges);
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
                  padding: const EdgeInsets.all(0),
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
                      onPressed: currentDateRangeType == DateRangeType.custom
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
                      onPressed: currentDateRangeType == DateRangeType.custom
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
                const SizedBox(
                  height: 10,
                ),
                Wrap(
                  spacing: 10,
                  children: choiceChips,
                ),
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Text(
                  AppLocalizations.of(context).showWaterChangeLines,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(
                  width: 10,
                ),
                Switch.adaptive(
                  value: showWaterChanges,
                  onChanged: (newValue) => setState(() {
                    showWaterChanges = !showWaterChanges;
                  }),
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
