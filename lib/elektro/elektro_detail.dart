import 'package:flutter/material.dart';
import 'package:frontend_biodata/models/produk/api.dart';

class ElektroDetail extends StatelessWidget {
  final String? kodeElektro, namaElektro, foto;
  final int? harga;

  const ElektroDetail({Key? key, this.kodeElektro, this.namaElektro, this.harga, this.foto}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Barang'), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 300, width: double.infinity,
            color: Colors.white,
            child: (foto != null && foto!.isNotEmpty)
                ? Image.network("${BaseUrl.baseUrl}/uploads/$foto", fit: BoxFit.contain)
                : const Icon(Icons.image, size: 100),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(namaElektro ?? "-", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("Rp $harga", style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                const Divider(height: 30),
                Text("Kode Produk: $kodeElektro", style: const TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}