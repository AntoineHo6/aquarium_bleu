import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:flutter/material.dart';

class HorizontalListCard extends StatefulWidget {
  final String title;
  final IconData iconData;
  final Color color;
  const HorizontalListCard(
      {required this.title, required this.iconData, required this.color, super.key});

  @override
  State<HorizontalListCard> createState() => _HorizontalListCardState();
}

class _HorizontalListCardState extends State<HorizontalListCard> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.height * 0.2,
      child: Card(
        clipBehavior: Clip.hardEdge,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.cardPadding),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: 0.6,
                  child: Icon(
                    widget.iconData,
                    size: MediaQuery.of(context).size.height * 0.15,
                    color: widget.color,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  widget.title,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
