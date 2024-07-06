import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/widgets/laporan_card.dart';
import 'package:catatan_harian_bps/src/models/laporan.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';

class DaftarVerifikasiLaporanPage extends StatefulWidget {
  final int? id_laporan;

  DaftarVerifikasiLaporanPage({this.id_laporan});

  @override
  _DaftarVerifikasiLaporanPageState createState() =>
      _DaftarVerifikasiLaporanPageState();
}

class _DaftarVerifikasiLaporanPageState
    extends State<DaftarVerifikasiLaporanPage> {
  late Future<List<Laporan>?> _futureLaporan;

  @override
  void initState() {
    super.initState();
    _futureLaporan = fetchData();
  }

  Future<List<Laporan>?> fetchData() async {
    try {
      List<Laporan>? data = await APIService()
          .getVerifikasiLaporan(id_laporan: widget.id_laporan);
      return data;
    } catch (error) {
      return null;
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _futureLaporan = fetchData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Riwayat Verifikasi",
          style: TextStyle(
            color: Color(0xFF2D2B2C),
          ),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        iconTheme: IconThemeData(color: Color(0xFF2D2B2C)),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: FutureBuilder<List<Laporan>?>(
          future: _futureLaporan,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else {
              List<Laporan> daftarLaporan = snapshot.data ?? [];
              return Column(
                children: [
                  Expanded(
                    child: (daftarLaporan.isNotEmpty)
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: ListView.builder(
                              itemCount: daftarLaporan.length,
                              itemBuilder: (context, index) {
                                return LaporanCard(
                                  laporan: daftarLaporan[index],
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
