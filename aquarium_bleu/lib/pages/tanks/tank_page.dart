import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/tank_page/big_buttons_section.dart';
import 'package:aquarium_bleu/widgets/tank_page/tasks_section.dart';
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
            child: Container(
              margin: _sectionMargins,
              child: FittedBox(
                child: Text(
                  widget.tank.name,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
            ),
          ),
          Container(
            margin: _sectionMargins,
            child: BigButtonsSection(widget.tank),
          ),
          Container(
            margin: _sectionMargins,
            child: const TasksSection(),
          ),
        ],
      ),
    );
  }
}

const EdgeInsets _sectionMargins = EdgeInsets.fromLTRB(
  Spacing.screenEdgeMargin,
  Spacing.betweenSections,
  Spacing.screenEdgeMargin,
  Spacing.betweenSections,
);
