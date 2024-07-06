import 'package:catatan_harian_bps/src/widgets/filter_laporan_modal.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/widgets/laporan_card.dart';
import 'package:catatan_harian_bps/src/models/laporan.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';

class DaftarLaporanPage extends StatefulWidget {
  @override
  _DaftarLaporanPageState createState() => _DaftarLaporanPageState();
}

class _DaftarLaporanPageState extends State<DaftarLaporanPage> {
  late Future<List<Laporan>?> _futureLaporan;

  @override
  void initState() {
    super.initState();
    _futureLaporan = fetchData();
  }

  Future<List<Laporan>?> fetchData({String? tahun, String? status}) async {
    try {
      List<Laporan>? data =
          await APIService().getLaporan(tahun: tahun, status: status);
      return data;
    } catch (error) {
      print("Error: $error");
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
                              is_pengawas: false,
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
                          child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                            ),
                            itemCount: daftarLaporan.length,
                            itemBuilder: (context, index) {
                              return LaporanCard(laporan: daftarLaporan[index]);
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
