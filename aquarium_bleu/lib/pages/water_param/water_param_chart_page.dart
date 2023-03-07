import 'package:aquarium_bleu/utils/string_util.dart';
import 'package:flutter/material.dart';

class WaterParamChartPage extends StatefulWidget {
  final String param;

  const WaterParamChartPage(this.param, {super.key});

  @override
  State<WaterParamChartPage> createState() => _WaterParamChartPageState();
}

class _WaterParamChartPageState extends State<WaterParamChartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringUtil.paramToString(context, widget.param)),
      ),
      body: Column(),
    );
  }
}
