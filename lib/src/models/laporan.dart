class Laporan {
  int? id;
  String? nip_pengguna;
  String? nama_pengguna;
  String? tahun;
  String? bulan;
  String? keterangan_laporan;
  String? status_laporan;
  String? keterangan_verifikasi;
  String? status_verifikasi;
  bool? active;
  String? tanggal;

  Laporan({
    this.id,
    this.nip_pengguna,
    this.nama_pengguna,
    this.tahun,
    this.bulan,
    this.keterangan_laporan,
    this.status_laporan,
    this.keterangan_verifikasi,
    this.status_verifikasi,
    this.active,
    this.tanggal,
  });

  Laporan.fromJson(Map<String, dynamic> json) {
    id = json['id'] is int ? json['id'] : int.tryParse(json['id'] ?? '');
    nip_pengguna = json['nip_pengguna'];
    nama_pengguna = json['nama_pengguna'];
    tahun = json['tahun'];
    bulan = json['bulan'];
    keterangan_laporan = json['keterangan_laporan'];
    status_laporan = json['status_laporan'];
    keterangan_verifikasi = json['keterangan_verifikasi'];
    status_verifikasi = json['status_verifikasi'];
    active = json['active'];
    tanggal = json['tanggal'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nip_pengguna': nip_pengguna,
      'nama_pengguna': nama_pengguna,
      'tahun': tahun,
      'bulan': bulan,
      'keterangan_laporan': keterangan_laporan,
      'status_laporan': status_laporan,
      'keterangan_verifikasi': keterangan_verifikasi,
      'status_verifikasi': status_verifikasi,
      'active': active,
      'tanggal': tanggal,
    };
  }
}
