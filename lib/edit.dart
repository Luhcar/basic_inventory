import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'database_helper.dart';
import 'dart:io';

class EditItemPage extends StatefulWidget {
  final Map<String, dynamic> item; // Data barang yang akan diedit

  EditItemPage({Key? key, required this.item}) : super(key: key);

  @override
  _EditItemPageState createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  final _formKey = GlobalKey<FormState>();
  // Controller untuk setiap field
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;
  late File _selectedImage;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data yang ada
    _nameController = TextEditingController(text: widget.item['name']);
    _descriptionController = TextEditingController(text: widget.item['description']);
    _categoryController = TextEditingController(text: widget.item['category']);
    _priceController = TextEditingController(text: widget.item['price'].toString());
    _quantityController = TextEditingController(text: widget.item['quantity'].toString());
    _selectedImage = File(widget.item['imagePath']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    _selectedImage = File(widget.item['imagePath']);
    super.dispose();
  }

  // menyimpan data setelah diedit
  Future<void> _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final updatedItem = {
        'id': widget.item['id'],
        'name': _nameController.text,
        'description': _descriptionController.text,
        'category': _categoryController.text,
        'price': double.parse(_priceController.text),
        'quantity': int.parse(_quantityController.text),
        'imagePath': _selectedImage.path
      };

      await DatabaseHelper.instance.update(updatedItem);
      Navigator.pop(context, true); 
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Barang'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nama Barang'),
                validator: (value) => value == null || value.isEmpty ? 'Nama barang wajib diisi' : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Deskripsi'),
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              TextFormField(
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Harga'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Harga wajib diisi' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Stok'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Stok wajib diisi' : null,
              ),
              SizedBox(height: 16.0),
              _selectedImage != null
                  ? Image.file(_selectedImage!, height: 150, width: 150, fit: BoxFit.cover)
                  : Text('No Image Selected'),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Pilih Gambar'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _saveItem,
                child: const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
