import 'package:basic_inventory/edit.dart';
import 'package:basic_inventory/history_item.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ItemDetailPage extends StatefulWidget {
  final Map<String, dynamic> item;

  ItemDetailPage({required this.item});

  @override
  _ItemDetailPage createState() => _ItemDetailPage();
}

List<Map<String, dynamic>> _items = [];

class _ItemDetailPage extends State<ItemDetailPage> {

  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    final items = await DatabaseHelper.instance.queryAllRows();
    setState(() {
      _items = items;
    });
  }

  void _delete(int id) async {
    DatabaseHelper.instance.delete(id);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            item['imagePath'] != null
                ? Image.file(File(item['imagePath']),
                    height: 300, width: 330, fit: BoxFit.cover)
                : Text('No Image Available'),
            SizedBox(height: 16.0),
            Text('Nama: ${item['name']}', style: TextStyle(fontSize: 18)),
            SizedBox(height: 8),
            Text('Deskripsi: ${item['description'] ?? '-'}'),
            SizedBox(height: 8),
            Text('Stok: ${item['quantity'] ?? '-'}'),
            SizedBox(height: 8),
            Text('Harga: Rp${item['price']}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            ElevatedButton(
              onPressed: () async {
                
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditItemPage(
                      item: item,
                    ),
                  ),
                ).then((_) {
                  setState(() {
                    _fetchItems();
                    Navigator.pop(context);
                  });
                });
              },
              child: Text('Edit Item'),
            ),
            ElevatedButton(
              onPressed: () async {
                final shouldDelete = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Konfirmasi'),
                    content:
                        Text('Apakah Anda yakin ingin menghapus item ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Hapus'),
                      ),
                    ],
                  ),
                );
                if (shouldDelete == true) {
                  if (item != null && item['id'] != null) {
                    await DatabaseHelper.instance.delete(item['id']);
                    setState(() {
                      _fetchItems(); 
                    });
                    Navigator.pop(context);
                  } else {
                    print('Error: Item atau ID tidak valid.');
                  }
                }
              },
              child: Text('Hapus'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddHistoryPage(itemId: item['id']),
                  ),
                );
              },
              child: Text('Tambah Riwayat'),
            )
          ],
        ),
      ),
    );
  }
}
