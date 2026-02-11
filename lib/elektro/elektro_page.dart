import 'package:frontend_biodata/elektro/elektro_detail.dart';
import 'package:frontend_biodata/elektro/elektro_form.dart';
import 'package:frontend_biodata/models/produk/api.dart';
import 'package:frontend_biodata/models/produk/mproduk.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ElektroPage extends StatefulWidget {
  const ElektroPage({super.key});

  @override
  State<ElektroPage> createState() => _ElektroPageState();
}

class _ElektroPageState extends State<ElektroPage> {
  Future<List<Mproduk>> getData() async {
    final response = await http.get(Uri.parse(BaseUrl.list));
    if (response.statusCode == 200) {
      List jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Mproduk.fromJson(data)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  Future _deleteData(String id) async {
    try {
      final response = await http.post(Uri.parse(BaseUrl.delete), body: {"id": id});
      if (response.statusCode == 200) {
        setState(() {});
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text("Hapus Barang"),
        content: const Text("Yakin ingin menghapus barang ini?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Batal")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              _deleteData(id);
            },
            child: const Text("Hapus", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Elektronik', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ElektroForm())).then((_) => setState(() {})),
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Tambah Produk", style: TextStyle(color: Colors.white)),
      ),
      body: FutureBuilder<List<Mproduk>>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Mproduk produk = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: SizedBox(
                        width: 60, height: 60,
                        child: (produk.foto.isNotEmpty)
                            ? Image.network("${BaseUrl.baseUrl}/uploads/${produk.foto}", fit: BoxFit.cover)
                            : const Icon(Icons.image, size: 40),
                      ),
                    ),
                    title: Text(produk.namaElektro, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text("Rp ${produk.harga}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElektroForm(
                            id: produk.id,
                            kodeElektro: produk.kodeElektro,
                            namaElektro: produk.namaElektro,
                            harga: produk.harga.toString(),
                            foto: produk.foto,
                          ))).then((_) => setState(() {})),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _confirmDelete(produk.id),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ElektroDetail(
                      kodeElektro: produk.kodeElektro, namaElektro: produk.namaElektro, harga: produk.harga, foto: produk.foto,
                    ))),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Data Kosong"));
        },
      ),
    );
  }
}