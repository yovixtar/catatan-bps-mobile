import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/widgets/filter_laporan_modal.dart';
import 'package:catatan_harian_bps/src/widgets/laporan_card.dart';
import 'package:catatan_harian_bps/src/models/laporan.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';

class DaftarLaporanPengawasPage extends StatefulWidget {
  final String? petugas;

  DaftarLaporanPengawasPage({this.petugas});

  @override
  _DaftarLaporanPengawasPageState createState() =>
      _DaftarLaporanPengawasPageState();
}

class _DaftarLaporanPengawasPageState extends State<DaftarLaporanPengawasPage> {
  late Future<List<Laporan>?> _futureLaporan;

  @override
  void initState() {
    super.initState();
    _futureLaporan = fetchData();
  }

  Future<List<Laporan>?> fetchData({String? tahun, String? status}) async {
    try {
      List<Laporan>? data = await APIService().getLaporanPengawas(
        tahun: tahun,
        status: status,
        petugas: widget.petugas,
      );
      return data;
    } catch (error) {
      return null;
    }
  }

  Future<void> _refreshData({String? tahun, String? status}) async {
    setState(() {
      _futureLaporan = fetchData(tahun: tahun, status: status);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return FilterLaporanModal(
                              onFilterSelected: (tahun, status) {
                                _refreshData(tahun: tahun, status: status);
                              },
                              is_pengawas: true,
                              petugas: widget.petugas,
                            );
                          },
                        );
                      },
                      icon: Image.asset(
                        'assets/icons/filter.png',
                        width: 30,
                        height: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                  ],
                ),
                Expanded(
                  child: (daftarLaporan.isNotEmpty)
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: daftarLaporan.length,
                            itemBuilder: (context, index) {
                              return LaporanCard(
                                laporan: daftarLaporan[index],
                                is_pengawas: true,
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
    );
  }
}
