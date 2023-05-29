import 'package:aquarium_bleu/models/tank.dart';
import 'package:flutter/material.dart';

class TankProvider with ChangeNotifier {
  late Tank tank;
  late Widget image;

  // used to avoid duplicate tank names when adding tanks
  List<String> tankNames = [];
}
