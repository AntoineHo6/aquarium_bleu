import 'package:aquarium_bleu/models/tank.dart';
import 'package:aquarium_bleu/models/task/interval_task.dart';
import 'package:aquarium_bleu/providers/cloud_firestore_provider.dart';
import 'package:aquarium_bleu/styles/spacing.dart';
import 'package:aquarium_bleu/widgets/tank_page/big_buttons_section.dart';
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
    return StreamBuilder<List<IntervalTask>>(
      stream: context.watch<CloudFirestoreProvider>().readIntervalTasks(
            widget.tank.docId,
          ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              // appBar: AppBar(
              //   actions: [
              //     IconButton(
              //       onPressed: () => null,
              //       icon: const Icon(Icons.edit),
              //     ),
              //   ],
              // ),
              body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: false,
                expandedHeight: MediaQuery.of(context).size.height * 0.2,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Container(
                    margin: const EdgeInsets.only(
                      left: Spacing.screenEdgeMargin,
                      right: Spacing.screenEdgeMargin,
                    ),
                    child: FittedBox(
                      child: Text(
                        widget.tank.name,
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (BuildContext context, int index) {
                    return Container(
                      margin: _sectionMargins,
                      child: BigButtonsSection(widget.tank),
                    );
                  },
                ),
              ),
            ],
          )

              // SingleChildScrollView(
              //   child: Column(
              //     children: [
              //       Center(
              //         child: Container(
              //           margin: _sectionMargins,
              //           child: FittedBox(
              //             child: Text(
              //               widget.tank.name,
              //               textAlign: TextAlign.center,
              //               style: Theme.of(context).textTheme.displayLarge,
              //             ),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         margin: _sectionMargins,
              //         child: BigButtonsSection(widget.tank),
              //       ),
              //     ],
              //   ),
              // ),
              );
        } else {
          return Container();
        }
      },
    );
  }
}

const EdgeInsets _sectionMargins = EdgeInsets.fromLTRB(
  Spacing.screenEdgeMargin,
  Spacing.betweenSections,
  Spacing.screenEdgeMargin,
  Spacing.betweenSections,
);
