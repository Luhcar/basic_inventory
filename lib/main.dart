import 'package:basic_inventory/history_page.dart';
import 'package:flutter/material.dart';
import 'list_item.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _index = 0;
  List<Widget> widgetList = const [ItemListPage(), HistoryPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: IndexedStack(
          children: widgetList,
          index: _index,
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            setState(() {
              _index = index;
            });
          },
          currentIndex: _index,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'List',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'Riwayat',
            ),
          ],
        ));
  }
}
