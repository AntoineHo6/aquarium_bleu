import 'package:aquarium_bleu/pages/tank_page.dart';
import 'package:flutter/material.dart';
import '../widgets/my_drawer.dart';
import '../widgets/tank_card.dart';

class ChartData {
  ChartData(this.x, this.y);
  final DateTime x;
  final double y;
}

class TanksPage extends StatefulWidget {
  const TanksPage({super.key});

  @override
  State<TanksPage> createState() => _TanksPageState();
}

class _TanksPageState extends State<TanksPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const MyDrawer(),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            expandedHeight: 150.0,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Your tanks',
                style: Theme.of(context).textTheme.headline1,
                textScaleFactor: 0.3,
              ),
            ),
            centerTitle: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (BuildContext context, int index) {
                return ElevatedButton(
                  // Within the `FirstRoute` widget
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TankPage()),
                    );
                  },
                  child: const TankCard("Apisto Tank"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
