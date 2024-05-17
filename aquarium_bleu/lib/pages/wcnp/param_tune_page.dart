import 'package:aquarium_bleu/enums/date_range_type.dart';
import 'package:aquarium_bleu/enums/water_param_type.dart';
import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/providers/tank_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class ParamTunePage extends StatefulWidget {
  const ParamTunePage({super.key});

  @override
  State<ParamTunePage> createState() => _ParamTunePageState();
}

class _ParamTunePageState extends State<ParamTunePage> {
  late int numOfVisibleParams;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      numOfVisibleParams = 0;
      for (var paramType in WaterParamType.values) {
        if (Provider.of<TankProvider>(context, listen: false)
            .tank
            .visibleParams[paramType.getStr]) {
          numOfVisibleParams++;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    // populate date range radiobtns list
    List<Widget> dateRangeRadioBtns = [];
    for (var dateRangeType in DateRangeType.values) {
      dateRangeRadioBtns.add(
        ListTile(
          title: Text(StringUtil.dateRangeTypeToString(context, dateRangeType)),
          leading: Radio<DateRangeType>(
            value: dateRangeType,
            groupValue: tankProvider.tank.dateRangeType,
            onChanged: (DateRangeType? value) async {
              setState(() {
                tankProvider.tank.dateRangeType = value!;
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
        selected: tankProvider.tank.visibleParams[paramType.getStr],
        onSelected: (isVisible) {
          setState(() {
            if (numOfVisibleParams > 1 && !isVisible) {
              numOfVisibleParams--;
              tankProvider.tank.visibleParams[paramType.getStr] = isVisible;
            } else if (isVisible) {
              numOfVisibleParams++;
              tankProvider.tank.visibleParams[paramType.getStr] = isVisible;
            } else {
              // animate a nono animation to show that there has to be at least 1 visible param.
            }
          });
        },
      ));
    }

    return PopScope(
      onPopInvoked: (b) async {
        await FirestoreStuff.updateTank(tankProvider.tank);
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
                  AppLocalizations.of(context)!.dateRange,
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
                    tankProvider.tank.dateRangeType == DateRangeType.custom
                        ? FilledButton.tonal(
                            onPressed: () => _handleCustomDateStartPicker(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.date_range),
                                _sectionSeparator,
                                Text(
                                    '${AppLocalizations.of(context)!.customDateStart}: ${StringUtil.formattedDate(context, tankProvider.tank.customDateStart)}'),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    tankProvider.tank.dateRangeType == DateRangeType.custom
                        ? FilledButton.tonal(
                            onPressed: () => _handleCustomDateEndPicker(),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.date_range),
                                _sectionSeparator,
                                Text(
                                    '${AppLocalizations.of(context)!.customDateEnd}: ${StringUtil.formattedDate(context, tankProvider.tank.customDateEnd)}'),
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
                  AppLocalizations.of(context)!.showWaterChangeLines,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Switch.adaptive(
                  value: tankProvider.tank.showWcInCharts,
                  onChanged: (newValue) => setState(() {
                    tankProvider.tank.showWcInCharts = newValue;
                  }),
                ),
                const SizedBox(
                  height: Spacing.betweenSections,
                ),
                Text(
                  AppLocalizations.of(context)!.visibleParameters,
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

  _handleCustomDateStartPicker() {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    showDatePicker(
      context: context,
      initialDate: tankProvider.tank.customDateStart,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((newDate) async {
      if (newDate != null) {
        setState(() {
          tankProvider.tank.customDateStart = newDate;
        });
      }
    });
  }

  _handleCustomDateEndPicker() {
    TankProvider tankProvider = Provider.of<TankProvider>(context, listen: false);

    showDatePicker(
      context: context,
      initialDate: tankProvider.tank.customDateEnd,
      firstDate: tankProvider.tank.customDateStart,
      lastDate: DateTime.now(),
    ).then((newDate) async {
      if (newDate != null) {
        setState(() {
          tankProvider.tank.customDateEnd = newDate;
        });
      }
    });
  }

  final _sectionSeparator = const SizedBox(
    height: 10,
    width: 10,
  );
}
