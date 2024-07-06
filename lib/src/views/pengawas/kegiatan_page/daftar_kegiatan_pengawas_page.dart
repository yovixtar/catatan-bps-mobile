import 'package:catatan_harian_bps/src/models/kegiatan.dart';
import 'package:catatan_harian_bps/src/views/pengawas/home_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:catatan_harian_bps/src/widgets/cari_kegiatan_modal.dart';
import 'package:catatan_harian_bps/src/widgets/kegiatan_card.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';

class DaftarKegiatanPengawasPage extends StatefulWidget {
  final int? id_laporan;
  final String bulan_laporan;
  final String? keyword;
  final bool? is_cari;
  final bool? is_no_reporting;
  final String? nip_pengguna_kegiatan;

  DaftarKegiatanPengawasPage({
    this.id_laporan,
    required this.bulan_laporan,
    this.keyword,
    this.is_cari = false,
    this.is_no_reporting,
    this.nip_pengguna_kegiatan = '',
  });

  @override
  _DaftarKegiatanPengawasPageState createState() =>
      _DaftarKegiatanPengawasPageState();
}

class _DaftarKegiatanPengawasPageState
    extends State<DaftarKegiatanPengawasPage> {
  late Future<List<Kegiatan>?> _futureKegiatan;
  bool isLoading = false;
  bool isCeklistAllClear = false;
  List<Map<String, dynamic>> kegiatanToAPI = [];

  String? keteranganVerifikasi = '';
  late TextEditingController _keteranganVerifikasiController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _futureKegiatan = fetchData();
  }

  Future<List<Kegiatan>?> fetchData({String? cari}) async {
    try {
      List<Kegiatan>? data = await APIService()
          .getKegiatan(id_laporan: widget.id_laporan, cari: widget.keyword);
      List<Kegiatan> dataKegiatanToVerif = data ?? [];
      kegiatanToAPI = dataKegiatanToVerif.map((kegiatan) {
        return {
          'id_kegiatan': kegiatan.id,
          'id_laporan': widget.id_laporan,
          'approval': true,
          'keterangan': '',
        };
      }).toList();
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
          "Verifikasi ${widget.bulan_laporan}",
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
                        SizedBox(
                          width: 10,
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
                                bool is_rejection =
                                    daftarKegiatan[index].is_rejection ?? false;
                                return Row(
                                  children: [
                                    Expanded(
                                      child: KegiatanCard(
                                        kegiatan: daftarKegiatan[index],
                                        id_laporan: widget.id_laporan,
                                        bulan_laporan: widget.bulan_laporan,
                                        is_no_reporting: widget.is_no_reporting,
                                        is_rejection: is_rejection,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          if (is_rejection) {
                                            daftarKegiatan[index].is_rejection =
                                                false;
                                            kegiatanToAPI[index]['approval'] =
                                                true;
                                          } else {
                                            daftarKegiatan[index].is_rejection =
                                                true;
                                            kegiatanToAPI[index]['approval'] =
                                                false;
                                          }
                                        });
                                      },
                                      icon: Icon(is_rejection
                                          ? Icons.close
                                          : Icons.block),
                                      iconSize: 30,
                                    ),
                                  ],
                                );
                              },
                            ),
                          )
                        : Center(
                            child: Text(
                              'No Data Found',
                            ),
                          ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: isCeklistAllClear,
                              onChanged: (newValue) {
                                setState(() {
                                  isCeklistAllClear = newValue!;
                                });
                              },
                            ),
                            Expanded(
                              child: Text(
                                'Seluruh kegiatan telah diverifikasi',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: isLoading || !isCeklistAllClear
                              ? null
                              : () {
                                  _showVerificationConfirmation(context);
                                },
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: isLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  'Verifikasi Sekarang',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _showVerificationConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: false,
          title: Text('Konfirmasi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  text: 'Apakah Anda yakin ingin ',
                  style: TextStyle(color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'memverifikasi',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.blueAccent),
                    ),
                    TextSpan(
                      text: ' laporan ini ?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Pastikan seluruh kegiatan telah diperiksa.",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 14,
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _keteranganVerifikasiController,
                maxLines: null,
                onChanged: (value) {
                  setState(() {
                    keteranganVerifikasi = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Keterangan Verifikasi',
                  labelStyle: TextStyle(color: Colors.black54),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return TextButton(
                  child: isLoading ? CircularProgressIndicator() : Text('Ya'),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            isLoading = true;
                          });
                          try {
                            final result = await APIService()
                                .VerifikasiPengawas(
                                    kegiatanToAPI,
                                    widget.id_laporan!,
                                    keteranganVerifikasi!,
                                    widget.nip_pengguna_kegiatan!);
                            if (result.containsKey('success')) {
                              SnackbarUtils.showSuccessSnackbar(
                                  context, result['success']);
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePengawas(
                                          pageType: 'laporan',
                                        )),
                              );
                            } else {
                              Navigator.pop(context);
                              SnackbarUtils.showErrorSnackbar(
                                  context, result['error']);
                            }
                          } catch (e) {
                            Navigator.pop(context);
                            SnackbarUtils.showErrorSnackbar(
                                context, 'Gagal menghapus laporan.');
                          } finally {
                            setState(() {
                              isLoading = false;
                            });
                          }
                        },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
