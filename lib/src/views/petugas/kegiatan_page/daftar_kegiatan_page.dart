import 'package:catatan_harian_bps/src/models/kegiatan.dart';
import 'package:catatan_harian_bps/src/widgets/cari_kegiatan_modal.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/tambah_target_kegiatan_modal.dart';
import 'package:catatan_harian_bps/src/widgets/kegiatan_card.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';

class DaftarKegiatanPage extends StatefulWidget {
  final int? id_laporan;
  final String bulan_laporan;
  final String? keyword;
  final bool? is_cari;
  final bool? is_no_reporting;

  DaftarKegiatanPage({
    this.id_laporan,
    required this.bulan_laporan,
    this.keyword,
    this.is_cari = false,
    this.is_no_reporting,
  });

  @override
  _DaftarKegiatanPageState createState() => _DaftarKegiatanPageState();
}

class _DaftarKegiatanPageState extends State<DaftarKegiatanPage> {
  late Future<List<Kegiatan>?> _futureKegiatan;

  @override
  void initState() {
    super.initState();
    _futureKegiatan = fetchData();
  }

  Future<List<Kegiatan>?> fetchData({String? cari}) async {
    try {
      List<Kegiatan>? data = await APIService()
          .getKegiatan(id_laporan: widget.id_laporan, cari: widget.keyword);
      return data;
    } catch (error) {
      print("Error: $error");
      return null;
    }
  }

  Future<void> _refreshData({String? cari}) async {
    setState(() {
      _futureKegiatan = fetchData(cari: widget.keyword);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          widget.bulan_laporan,
          style: TextStyle(
            color: Color(0xFF2D2B2C),
          ),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        actions: [
          if (widget.is_cari == true)
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (BuildContext context) {
                    if (widget.id_laporan != null) {
                      return CariKegiatanModal(
                        id_laporan: widget.id_laporan,
                      );
                    } else {
                      return CariKegiatanModal(
                        is_no_reporting: widget.is_no_reporting,
                      );
                    }
                  },
                );
              },
            ),
        ],
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
                  if (widget.is_cari == false)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (widget.is_no_reporting == true)
                          IconButton(
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (BuildContext context) {
                                  return TambahTargetKegiatanModal(
                                    id_laporan: widget.id_laporan,
                                    bulan_laporan: widget.bulan_laporan,
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.add),
                            iconSize: 30,
                          ),
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              builder: (BuildContext context) {
                                return CariKegiatanModal(
                                  id_laporan: widget.id_laporan,
                                  is_no_reporting: widget.is_no_reporting,
                                );
                              },
                            );
                          },
                          icon: Icon(Icons.search),
                          iconSize: 30,
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  Expanded(
                    child: (daftarKegiatan.isNotEmpty)
                        ? Padding(
                            padding: EdgeInsets.all(10),
                            child: ListView.builder(
                              itemCount: daftarKegiatan.length,
                              itemBuilder: (context, index) {
                                return KegiatanCard(
                                  kegiatan: daftarKegiatan[index],
                                  id_laporan: widget.id_laporan,
                                  bulan_laporan: widget.bulan_laporan,
                                  is_no_reporting: widget.is_no_reporting,
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
