import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';

class AddItemPage extends StatefulWidget {
  final Map<String, dynamic>? item;
  AddItemPage({Key? key, this.item}) : super(key: key);
  @override
  _AddItemPageState createState() => _AddItemPageState();
  }
  class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  File? _selectedImage;

@override
  void initState() {
    super.initState();
    if (widget.item != null) {
      // Isi data jika item tidak null (edit mode)
      _nameController.text = widget.item!['name'];
      _descriptionController.text = widget.item!['description'];
      _categoryController.text = widget.item!['category'];
      _priceController.text = widget.item!['price'].toString();
      _quantityController.text = widget.item!['quantity'].toString();
      if (widget.item!['imagePath'] != null) {
        _selectedImage = File(widget.item!['imagePath']);
      }
    }
  }

Future<void> _pickImage() async {
  final image = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (image != null) {
    setState(() {
      _selectedImage = File(image.path);
    });
  }
}
  void _saveItem(BuildContext context) async {
  if (_formKey.currentState!.validate()) {
    final item = {
      'name': _nameController.text,
      'description': _descriptionController.text,
      'category': _categoryController.text,
      'price': double.tryParse(_priceController.text) ?? 0.0,
      'quantity': int.tryParse(_quantityController.text) ?? 0,
      'imagePath': _selectedImage?.path
    };
    try {
      print('Menyimpan item: $item');
      await DatabaseHelper.instance.insert(item);
      print('Item berhasil disimpan');
      Navigator.pop(context);
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan data: $e')),
      );
    }
  } else {
    print('Form tidak valid');
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Nama Barang'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Deskripsi'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(labelText: 'Kategori'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16.0),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover)
                  : Text('No Image Selected'),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _saveItem(context),
                child: Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}