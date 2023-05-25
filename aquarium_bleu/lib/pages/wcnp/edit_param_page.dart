import 'package:aquarium_bleu/firestore_stuff.dart';
import 'package:aquarium_bleu/models/parameter.dart';
import 'package:flutter/material.dart';

class EditParamPage extends StatefulWidget {
  final String tankId;
  final Parameter dataPoint;
  const EditParamPage(this.tankId, this.dataPoint, {super.key});

  @override
  State<EditParamPage> createState() => _EditParamPageState();
}

class _EditParamPageState extends State<EditParamPage> {
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
      body: const Column(),
    );
  }
}
