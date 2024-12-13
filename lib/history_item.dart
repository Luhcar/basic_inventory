import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddHistoryPage extends StatelessWidget {
  final int itemId;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  String _transactionType = 'Masuk';

  AddHistoryPage({required this.itemId});

  void _saveHistory(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final history = {
        'item_id': itemId,
        'transaction_type': _transactionType,
        'quantity': int.parse(_quantityController.text),
        'date': _dateController.text,
      };
      await DatabaseHelper.instance.insertHistory(history);
      Navigator.pop(context);
    }
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
