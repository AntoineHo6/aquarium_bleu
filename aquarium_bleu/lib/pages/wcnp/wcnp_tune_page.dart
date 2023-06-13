import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class WcnpTunePage extends StatefulWidget {
  final DateRangeType currentDateRangeType;
  final DateTime customDateStart;
  final DateTime customDateEnd;
  final Map<String, dynamic>? visibleParams;
  final bool showWaterChanges;

  const WcnpTunePage(this.currentDateRangeType, this.customDateStart, this.customDateEnd,
      this.visibleParams, this.showWaterChanges,
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
        String tankId = Provider.of<TankProvider>(context, listen: false).tank.docId;
        await FirestoreStuff.updateDateRangeType(tankId, currentDateRangeType);
        await FirestoreStuff.updateCustomStartDate(tankId, customDateStart);
        await FirestoreStuff.updateCustomEndDate(tankId, customDateEnd);
        await FirestoreStuff.updateParamVis(tankId, visibleParams);
        await FirestoreStuff.updateShowWaterChanges(tankId, showWaterChanges);
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
                  childAspectRatio: 7,
                  crossAxisCount: 1,
                  children: dateRangeRadioBtns,
                ),
                _sectionSeparator,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    currentDateRangeType == DateRangeType.custom
                        ? FilledButton.tonal(
                            onPressed: () => _handleDatePicker(customDateStart),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.date_range),
                                _sectionSeparator,
                                Text(
                                    '${AppLocalizations.of(context).customDateStart}: ${StringUtil.formattedDate(context, customDateStart)}'),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    currentDateRangeType == DateRangeType.custom
                        ? FilledButton.tonal(
                            onPressed: () => _handleDatePicker(customDateEnd),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.date_range),
                                _sectionSeparator,
                                Text(
                                    '${AppLocalizations.of(context).customDateEnd}: ${StringUtil.formattedDate(context, customDateEnd)}'),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Text(
                  AppLocalizations.of(context).showWaterChangeLines,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch.adaptive(
                  value: showWaterChanges,
                  onChanged: (newValue) => setState(() {
                    showWaterChanges = !showWaterChanges;
                  }),
                ),
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Text(
                  AppLocalizations.of(context).visibleParameters,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                _sectionSeparator,
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

  _handleDatePicker(DateTime date) {
    showDatePicker(
      context: context,
      initialDate: date,
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

  final _sectionSeparator = const SizedBox(
    height: 10,
    width: 10,
  );
}
