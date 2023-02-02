import 'package:flutter/material.dart';

class TankCard extends StatelessWidget {
  final String name;
  final Function onPressed;

  const TankCard({required this.name, required this.onPressed, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Image.asset(
                "assets/images/koi_pixel.png",
                fit: BoxFit.cover,
                opacity: const AlwaysStoppedAnimation(0.8),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            )
          ],
        ),
      ),
    );
  }
}
