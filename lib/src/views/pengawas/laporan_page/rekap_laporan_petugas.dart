import 'package:catatan_harian_bps/src/views/pengawas/laporan_page/daftar_laporan_pengawas_page.dart';
import 'package:flutter/material.dart';

class RekapLaporanPetugas extends StatefulWidget {
  
  final String petugas;

  RekapLaporanPetugas({required this.petugas});

  @override
  _RekapLaporanPetugasState createState() => _RekapLaporanPetugasState();
}

class _RekapLaporanPetugasState extends State<RekapLaporanPetugas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Rekap Laporan',
          style: TextStyle(
            color: Color(0xFF2D2B2C),
          ),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: Color(0xFF2D2B2C)),
      ),
      backgroundColor: Color(0xFFF7F7F7),
      body: DaftarLaporanPengawasPage(petugas: widget.petugas,),
    );
  }
}
