import 'package:aquarium_bleu/enums/unit_of_length.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DimensionsInput extends StatefulWidget {
  final TextEditingController lengthFieldController;
  final TextEditingController widthFieldController;
  final TextEditingController heightFieldController;
  final bool isLengthValid;
  final bool isWidthValid;
  final bool isHeightValid;
  final UnitOfLength dropdownValue;

  const DimensionsInput(
      this.lengthFieldController,
      this.widthFieldController,
      this.heightFieldController,
      this.isLengthValid,
      this.isWidthValid,
      this.isHeightValid,
      this.dropdownValue,
      {super.key});

  @override
  State<DimensionsInput> createState() => _DimensionsInputState();
}

class _DimensionsInputState extends State<DimensionsInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(
              '${AppLocalizations.of(context)!.dimensions}:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // IconButton(onPressed: () {}, icon: const Icon(Icons.info)),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: widget.lengthFieldController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.length,
                  errorText: widget.isLengthValid ? null : '',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.close,
                size: 15,
              ),
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: widget.widthFieldController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.width,
                  errorText: widget.isWidthValid ? null : '',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Icon(
                Icons.close,
                size: 15,
              ),
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                controller: widget.heightFieldController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.height,
                  errorText: widget.isHeightValid ? null : '',
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            DropdownButton<UnitOfLength>(
              value: widget.dropdownValue,
              items: [
                DropdownMenuItem(
                  value: UnitOfLength.cm,
                  child: Text(AppLocalizations.of(context)!.cm),
                ),
                DropdownMenuItem(
                  value: UnitOfLength.inch,
                  child: Text(AppLocalizations.of(context)!.inches),
                ),
              ],
              onChanged: (UnitOfLength? value) {
                // setState(() {
                //   widget.dropdownValue = value!;
                // });
              },
            ),
          ],
        )
      ],
    );
  }
}
