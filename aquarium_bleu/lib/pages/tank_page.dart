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

class _TankPageState extends State<TankPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
