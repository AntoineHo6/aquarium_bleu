import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class NameTextField extends StatefulWidget {
  TextEditingController controller;
  bool isNameValid;
  Function(String)? onChanged;
  String? errorText;

  NameTextField({
    super.key,
    required this.controller,
    required this.isNameValid,
    this.onChanged,
    this.errorText,
  });

  @override
  State<NameTextField> createState() => _NameTextFieldState();
}

class _NameTextFieldState extends State<NameTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 50,
      controller: widget.controller,
      onChanged: widget.onChanged,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).focusColor,
          ),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).hintColor,
            width: 0.5,
          ),
        ),
        hintText: AppLocalizations.of(context).name,
        errorText: widget.isNameValid ? null : widget.errorText,
      ),
    );
  }
}
