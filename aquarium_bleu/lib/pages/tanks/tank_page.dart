import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/widgets/tank_page/big_buttons.dart';
import 'package:flutter/material.dart';

class TankPage extends StatefulWidget {
  final Tank tank;

  const TankPage(this.tank, {super.key});

  @override
  State<TankPage> createState() => _TankPageState();
}

class _TankPageState extends State<TankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => null,
            icon: const Icon(Icons.edit),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: FittedBox(
              child: Text(
                widget.tank.name,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
          ),
          BigButtons(widget.tank),
        ],
      ),
    );
  }
}
