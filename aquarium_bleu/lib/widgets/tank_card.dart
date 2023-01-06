import 'package:flutter/material.dart';

class TankCard extends StatelessWidget {
  final String tankName;

  const TankCard(this.tankName, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(15),
      margin: const EdgeInsets.all(10),
      child: Text(
        tankName,
        style: Theme.of(context).textTheme.headline5,
      ),
    );
  }
}
