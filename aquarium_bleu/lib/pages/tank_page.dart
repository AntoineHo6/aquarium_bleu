import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TankPage extends StatefulWidget {
  final Tank tank;

  const TankPage(this.tank, {super.key});

  @override
  State<TankPage> createState() => _TankPageState();
}

enum MenuItem {
  addMeasurement,
}

class _TankPageState extends State<TankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tank.name),
        actions: [
          PopupMenuButton(
            onSelected: (MenuItem item) {
              switch (item) {
                case MenuItem.addMeasurement:
                  // TODO: Handle this case.
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<MenuItem>>[
              const PopupMenuItem<MenuItem>(
                value: MenuItem.addMeasurement,
                child: Text('Item 1'),
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder(
          stream: context
              .watch<CloudFirestoreProvider>()
              .readNitrates(widget.tank.docId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: snapshot.data!
                    .map((nitrate) => ElevatedButton(
                        onPressed: () => null,
                        child: Text(nitrate.amount.toString())))
                    .toList(),
              );
            } else {
              return Container();
            }
          }),
    );
  }
}
