import 'package:flutter/material.dart';
import 'database_helper.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
  const HistoryPage({Key? key}) : super(key: key);
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final db = await DatabaseHelper.instance.database;
    final history = await db.query('history', orderBy: 'date DESC');

    setState(() {
      _history = history;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Riwayat'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await _fetchHistory();
        },
     child:  _history.isEmpty
          ? Center(child: Text('Belum ada riwayat transaksi'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final item = _history[index];
                return ListTile(
                  title: Text('${item['transaction_type']}'),
                  subtitle: Text('Jumlah stok: ${item['quantity']}'),
                  trailing: Text('${item['date']}'),
                );
              },
            ),
      )
    );
  }
}
