import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: Text("scedule"),
          ),
      // body: Padding(
      //   padding: const EdgeInsets.all(Spacing.screenEdgePadding),
      //   child: Column(
      //     children: [],
      //   ),
      // ),
    );
  }
}
