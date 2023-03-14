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
              title: Padding(
                padding: const EdgeInsets.symmetric(horizontal: Spacing.screenEdgePadding),
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
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenEdgePadding,
                    vertical: Spacing.betweenSections,
                  ),
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
