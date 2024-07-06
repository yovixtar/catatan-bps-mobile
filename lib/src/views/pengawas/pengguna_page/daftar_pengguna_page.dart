import 'package:catatan_harian_bps/src/models/pengguna.dart';
import 'package:catatan_harian_bps/src/views/pengawas/pengguna_page/filter_pengguna_modal.dart';
import 'package:catatan_harian_bps/src/views/pengawas/pengguna_page/tambah_pengguna_modal.dart';
import 'package:catatan_harian_bps/src/widgets/pengguna_card.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';

class DaftarPenggunaPage extends StatefulWidget {
  @override
  _DaftarPenggunaPageState createState() => _DaftarPenggunaPageState();
}

class _DaftarPenggunaPageState extends State<DaftarPenggunaPage> {
  late Future<List<Pengguna>?> _dataPengguna;

  @override
  void initState() {
    super.initState();
    _dataPengguna = fetchData();
  }

  Future<List<Pengguna>?> fetchData({String? role}) async {
    try {
      List<Pengguna>? data = await APIService().getDataUser(role: role);
      return data;
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<void> _refreshData({String? role}) async {
    setState(() {
      _dataPengguna = fetchData(role: role);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<List<Pengguna>?>(
        future: _dataPengguna,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List<Pengguna> daftarPengguna = snapshot.data!;
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
                            return TambahPenggunaModal();
                          },
                        );
                      },
                      icon: Icon(
                        Icons.add,
                        size: 35,
                      ),
                    ),
                    SizedBox(width: 10),
                    IconButton(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return FilterPenggunaModal(
                              onFilterSelected: (role) {
                                _refreshData(role: role);
                              },
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
                  child: (daftarPengguna.isNotEmpty)
                      ? Padding(
                          padding: EdgeInsets.all(10),
                          child: ListView.builder(
                            itemCount: daftarPengguna.length,
                            itemBuilder: (context, index) {
                              return PenggunaCard(
                                pengguna: daftarPengguna[index],
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
