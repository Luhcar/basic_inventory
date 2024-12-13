import 'package:basic_inventory/add_item.dart';
import 'package:basic_inventory/item_detail.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  late Future<List<Map<String, dynamic>>> _items;

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  void _fetchItems() {
    setState(() {
      _items = DatabaseHelper.instance.queryAllRows();
    });
  }

  void _navigateToAddItem() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddItemPage()),
    );
    _fetchItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _items,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: item['imagePath'] != null
                    ? Image.file(File(item['imagePath']),
                        width: 50, height: 50, fit: BoxFit.cover)
                    : Icon(Icons.image),
                title: Text(item['name']),
                subtitle: Text(
                    'Kategori: ${item['category']} \nStok: ${item['quantity']}'),
                trailing: Text('Rp${item['price']}'),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ItemDetailPage(
                        item: item,
                      ),
                  ),
                )..then((_) {
                    setState(() {
                      _fetchItems();
                    });
                  })
              );
            }
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddItem,
        child: Icon(Icons.add),
      ),
    );
  }
}
