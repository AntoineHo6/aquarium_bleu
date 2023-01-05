import 'package:flutter/material.dart';

import '../widgets/my_drawer.dart';
import '../widgets/tank_card.dart';

class TanksHomePage extends StatefulWidget {
  const TanksHomePage({super.key});

  @override
  State<TanksHomePage> createState() => _TanksHomePageState();
}

class _TanksHomePageState extends State<TanksHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
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
              childCount: 3,
              (BuildContext context, int index) {
                return ElevatedButton(
                  onPressed: () => print("sds"),
                  child: TankCard("Apisto Tank"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
