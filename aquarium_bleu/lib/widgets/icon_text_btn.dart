import 'package:flutter/material.dart';

class IconTextBtn extends StatelessWidget {
  final IconData iconData;
  final String text;
  final Function()? onPressed;
  final double spaceBetweenSize;
  final bool isError;

  const IconTextBtn({
    super.key,
    required this.iconData,
    required this.text,
    required this.onPressed,
    this.spaceBetweenSize = 8,
    this.isError = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          side: BorderSide(
            color: (isError ? Theme.of(context).colorScheme.error : Colors.transparent),
          ),
        ),
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
