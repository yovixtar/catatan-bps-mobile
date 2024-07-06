import 'package:catatan_harian_bps/src/models/kegiatan.dart';
import 'package:catatan_harian_bps/src/widgets/kegiatan_card.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:intl/intl.dart';

class DaftarVerifikasiKegiatanPage extends StatefulWidget {
  final int? id_verifikasi_laporan;
  final String? tanggal_verifikasi;

  DaftarVerifikasiKegiatanPage({
    required this.id_verifikasi_laporan,
    required this.tanggal_verifikasi,
  });

  @override
  _DaftarVerifikasiKegiatanPageState createState() =>
      _DaftarVerifikasiKegiatanPageState();
}

class _DaftarVerifikasiKegiatanPageState
    extends State<DaftarVerifikasiKegiatanPage> {
  late Future<List<Kegiatan>?> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    _futureKegiatan = fetchData();
  }

  Future<List<Kegiatan>?> fetchData() async {
    try {
      List<Kegiatan>? data = await APIService().getVerifikasiKegiatan(
          id_verifikasi_laporan: widget.id_verifikasi_laporan);
      return data;
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<void> _refreshData({String? cari}) async {
    setState(() {
      _futureKegiatan = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(widget.tanggal_verifikasi!))}",
          style: TextStyle(
            color: Color(0xFF2D2B2C),
          ),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0xFF2D2B2C)),
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Kegiatan>?>(
          future: _futureKegiatan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              List<Kegiatan> daftarKegiatan = snapshot.data ?? [];
              return Column(
                children: [
                  Expanded(
                    child: (daftarKegiatan.isNotEmpty)
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: ListView.builder(
                              itemCount: daftarKegiatan.length,
                              itemBuilder: (context, index) {
                                return KegiatanCard(
                                  kegiatan: daftarKegiatan[index],
                                  is_verifikasi: true,
                                );
                              },
                            ),
                          )
                        : Center(child: Text('No Data Found')),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
