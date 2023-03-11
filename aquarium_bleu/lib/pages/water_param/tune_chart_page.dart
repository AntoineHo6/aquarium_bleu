import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// ignore: must_be_immutable
class TuneChartPage extends StatefulWidget {
  final String tankId;
  String currentDateRangeType;
  final Map<String, dynamic>? visibleParams;

  TuneChartPage(this.tankId, this.currentDateRangeType, this.visibleParams, {super.key});

  @override
  State<TuneChartPage> createState() => _TuneChartPageState();
}

class _TuneChartPageState extends State<TuneChartPage> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<CloudFirestoreProvider>(context);

    // populate choiceChips list
    List<Widget> choiceChips = [];
    for (String param in Strings.params) {
      choiceChips.add(ChoiceChip(
        label: Text(StringUtil.paramToString(context, param)),
        selected: widget.visibleParams![param],
        onSelected: (newValue) async {
          widget.visibleParams![param] = newValue;
          await firestoreProvider.updateParamVis(
            widget.tankId,
            param,
            newValue,
          );
        },
      ));
    }

    // populate date range radiobtns list
    List<ListTile> dateRangeRadioBtns = [];
    for (String dateRangeType in Strings.dateRangeTypes) {
      dateRangeRadioBtns.add(
        ListTile(
          title: Text(StringUtil.dateRangeTypeToString(context, dateRangeType)), // TODO: change
          leading: Radio<String>(
            value: dateRangeType,
            groupValue: widget.currentDateRangeType,
            onChanged: (String? value) async {
              await firestoreProvider.updateDateRangeType(widget.tankId, value!);
              setState(() {
                widget.currentDateRangeType = value;
              });
            },
          ),
        ),
      );
    }

    return Scaffold(
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
    );
  }
}
