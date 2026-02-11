import 'dart:io';
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:frontend_biodata/models/produk/api.dart';

class ElektroForm extends StatefulWidget {
  final String? id, kodeElektro, namaElektro, harga, foto;
  const ElektroForm({Key? key, this.id, this.kodeElektro, this.namaElektro, this.harga, this.foto}) : super(key: key);

  @override
  _ElektroFormState createState() => _ElektroFormState();
}

class _ElektroFormState extends State<ElektroForm> {
  final _formKey = GlobalKey<FormState>();
  final _kodeController = TextEditingController();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  XFile? _pickedFile;

  @override
  void initState() {
    super.initState();
    if (widget.id != null) {
      _kodeController.text = widget.kodeElektro ?? "";
      _namaController.text = widget.namaElektro ?? "";
      _hargaController.text = widget.harga ?? "";
    }
  }

  Future _pickImage() async {
    final result = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (result != null) setState(() => _pickedFile = result);
  }

  Future _simpanData() async {
    if (!_formKey.currentState!.validate()) return;

    var request = http.MultipartRequest('POST', Uri.parse(widget.id == null ? BaseUrl.create : BaseUrl.update));
    request.fields['kode_elektro'] = _kodeController.text;
    request.fields['nama_elektro'] = _namaController.text;
    request.fields['harga'] = _hargaController.text;
    if (widget.id != null) request.fields['id'] = widget.id!;

    if (_pickedFile != null) {
      final bytes = await _pickedFile!.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('foto', bytes, filename: _pickedFile!.name));
    }

    showDialog(context: context, barrierDismissible: false, builder: (c) => const Center(child: CircularProgressIndicator()));
    
    try {
      await request.send();
      Navigator.pop(context);  
      Navigator.pop(context); 
    } catch (e) {
      Navigator.pop(context);
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? 'Tambah Barang' : 'Edit Barang'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 250, width: double.infinity,
                  color: Colors.grey[200],
                  child: _pickedFile != null 
                    ? (kIsWeb 
                        ? Image.network(_pickedFile!.path, fit: BoxFit.contain) 
                        : Image.file(File(_pickedFile!.path), fit: BoxFit.contain))
                    : (widget.foto != null && widget.foto != "" 
                        ? Image.network("${BaseUrl.baseUrl}/uploads/${widget.foto}", fit: BoxFit.contain) 
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.camera_alt, size: 50, color: Colors.indigo),
                              Text("Pilih Foto Barang", style: TextStyle(color: Colors.indigo)),
                            ],
                          )),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _kodeController,
                      decoration: const InputDecoration(labelText: "Kode", border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? "Kosong" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _namaController,
                      decoration: const InputDecoration(labelText: "Nama", border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? "Kosong" : null,
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _hargaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: "Harga", border: OutlineInputBorder()),
                      validator: (v) => v!.isEmpty ? "Kosong" : null,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                        onPressed: _simpanData,
                        child: const Text("SIMPAN", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}