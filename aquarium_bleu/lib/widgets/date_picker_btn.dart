import 'package:flutter/material.dart';

class IconTextBtn extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function() onPressed;
  final double spaceBetweenSize;

  const IconTextBtn({
    super.key,
    required this.iconData,
    required this.text,
    required this.onPressed,
    this.spaceBetweenSize = 8,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(iconData),
            SizedBox(width: spaceBetweenSize),
            Text(text),
          ],
        ),
      ),
    );
  }
}
