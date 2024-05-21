import 'package:flutter/material.dart';

class MsgAlertDialog extends StatelessWidget {
  final Widget title;
  final Widget content;

  const MsgAlertDialog({
    this.title = const Text(''),
    required this.content,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: title,
      content: content,
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('OK'),
        ),
      ],
    );
  }
}
