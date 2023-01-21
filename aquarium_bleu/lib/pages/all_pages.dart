import 'package:aquarium_bleu/pages/tanks_page.dart';
import 'package:flutter/material.dart';
import '../widgets/my_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Temp extends StatefulWidget {
  const Temp({super.key});

  @override
  State<Temp> createState() => _TanksPageState();
}

class _TanksPageState extends State<Temp> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    TanksPage(),
    Text("allo"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context).tanks,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context).settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      drawer: const MyDrawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }
}
