import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/strings.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TuneChartPage extends StatefulWidget {
  final String tankId;
  final Map<String, dynamic>? visibleParams;

  const TuneChartPage(this.tankId, this.visibleParams, {super.key});

  @override
  State<TuneChartPage> createState() => _TuneChartPageState();
}

class _TuneChartPageState extends State<TuneChartPage> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    final firestoreProvider = Provider.of<CloudFirestoreProvider>(context);

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

    List<Radio> dateRanges = [];

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).dateRange,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              Wrap(),
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
