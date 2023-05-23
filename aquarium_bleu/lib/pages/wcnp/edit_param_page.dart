import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:flutter/material.dart';

class EditWaterParamPage extends StatefulWidget {
  final String tankId;
  final Parameter dataPoint;
  const EditWaterParamPage(this.tankId, this.dataPoint, {super.key});

  @override
  State<EditWaterParamPage> createState() => _EditWaterParamPageState();
}

class _EditWaterParamPageState extends State<EditWaterParamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirestoreStuff.deleteParam(widget.tankId, widget.dataPoint)
                  .then((value) => Navigator.pop(context));
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Column(),
    );
  }
}
