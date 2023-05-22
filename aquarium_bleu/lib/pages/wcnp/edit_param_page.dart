import 'package:aquarium_bleu/models/parameter.dart';
import 'package:flutter/material.dart';

class EditWaterParamPage extends StatefulWidget {
  final Parameter dataPoint;
  const EditWaterParamPage(this.dataPoint, {super.key});

  @override
  State<EditWaterParamPage> createState() => _EditWaterParamPageState();
}

class _EditWaterParamPageState extends State<EditWaterParamPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(),
    );
  }
}
