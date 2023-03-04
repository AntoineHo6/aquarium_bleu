
import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/tank_page/big_buttons_section.dart';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: false,
            expandedHeight: MediaQuery.of(context).size.height * 0.2,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/koi_pixel.png",
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.15),
              ),
              centerTitle: true,
              title: Container(
                margin: const EdgeInsets.only(
                  left: Spacing.screenEdgeMargin,
                  right: Spacing.screenEdgeMargin,
                ),
                child: FittedBox(
                  child: Text(
                    widget.tank.name,
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => {},
                icon: const Icon(Icons.edit),
              )
            ],
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (BuildContext context, int index) {
                return Container(
                  margin: _sectionMargins,
                  child: BigButtonsSection(widget.tank),
                );
              },
            ),
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
