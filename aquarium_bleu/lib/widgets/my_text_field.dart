import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  final TextEditingController controller;
  final bool isFieldValid;
  final Function(String)? onChanged;
  final String? errorText;
  final int? maxLength;
  final String? hintText;

  const MyTextField({
    super.key,
    required this.controller,
    required this.isFieldValid,
    this.onChanged,
    this.errorText,
    this.maxLength,
    this.hintText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: widget.maxLength,
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
        hintText: widget.hintText,
        errorText: widget.isFieldValid ? null : widget.errorText,
      ),
    );
  }
}
