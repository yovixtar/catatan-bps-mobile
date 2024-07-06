class Kegiatan {
  int? id;
  String? tanggal;
  String? target;
  String? nama;
  String? nip_pengguna;
  String? nama_pengguna;
  String? realisasi;
  String? keterangan;
  String? status;
  bool? is_rejection;

  Kegiatan({
    this.id,
    this.tanggal,
    this.target,
    this.nama,
    this.nip_pengguna,
    this.nama_pengguna,
    this.realisasi,
    this.keterangan,
    this.status,
    this.is_rejection = false,
  });

  Kegiatan.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'] ?? '');
    tanggal = json['tanggal'];
    target = json['target'];
    nama = json['nama'];
    nip_pengguna = json['nip_pengguna'];
    nama_pengguna = json['nama_pengguna'];
    realisasi = json['realisasi'];
    keterangan = json['keterangan'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tanggal': tanggal,
      'target': target,
      'nama': nama,
      'nip_pengguna': nip_pengguna,
      'nama_pengguna': nama_pengguna,
      'realisasi': realisasi,
      'keterangan': keterangan,
      'status': status,
    };
  }
}
