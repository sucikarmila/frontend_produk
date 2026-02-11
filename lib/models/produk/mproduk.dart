class Mproduk {
  final String id, kodeElektro, namaElektro, foto;
  final int harga;

  Mproduk({required this.id, required this.kodeElektro, required this.namaElektro, required this.harga, required this.foto});

  factory Mproduk.fromJson(Map<String, dynamic> json) {
    return Mproduk(
      id: json['id'].toString(),
      kodeElektro: json['kode_elektro'] ?? '',
      namaElektro: json['nama_elektro'] ?? '',
      harga: int.tryParse(json['harga'].toString()) ?? 0,
      foto: json['foto'] ?? '',
    );
  }
}