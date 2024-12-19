import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddHistoryPage extends StatefulWidget {
  final int itemId;

  AddHistoryPage({required this.itemId});

  @override
  State<AddHistoryPage> createState() => _AddHistoryPageState();
}

class _AddHistoryPageState extends State<AddHistoryPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  late TextEditingController _dateController = TextEditingController();
  String _transactionType = 'Masuk';

  void _saveHistory(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final history = {
        'item_id': widget.itemId,
        'transaction_type': _transactionType,
        'quantity': int.parse(_quantityController.text),
        'date': _dateController.text,
      };
      await DatabaseHelper.instance.addHistory(widget.itemId, _transactionType, int.parse(_quantityController.text));
      Navigator.pop(context);
    }
  }

@override
  void initState() {
    super.initState();
    // Set default value menjadi tanggal saat ini
    _dateController = TextEditingController(
      text: DateTime.now().toIso8601String().split('T')[0], // Format: yyyy-MM-dd
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Riwayat Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _transactionType,
                items: ['Masuk', 'Keluar']
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  _transactionType = value!;
                },
                decoration: InputDecoration(labelText: 'Jenis Transaksi'),
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Jumlah'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Jumlah tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Tanggal'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal tidak boleh kosong';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveHistory(context),
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
