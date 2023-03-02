import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddWaterParamPage extends StatefulWidget {
  const AddWaterParamPage({super.key});

  @override
  State<AddWaterParamPage> createState() => _AddWaterParamPageState();
}

class _AddWaterParamPageState extends State<AddWaterParamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).addParameterValue),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Parameter",
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ],
        ),
      ),
    );
  }
}
