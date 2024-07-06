import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/daftar_kegiatan_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';

class UpdateRealisasiKegiatanModal extends StatefulWidget {
  final int? id_kegiatan;
  final int? id_laporan;
  final String? bulan_laporan;

  UpdateRealisasiKegiatanModal({
    required this.id_kegiatan,
    required this.id_laporan,
    required this.bulan_laporan,
  });

  @override
  _UpdateRealisasiKegiatanModalState createState() =>
      _UpdateRealisasiKegiatanModalState();
}

class _UpdateRealisasiKegiatanModalState
    extends State<UpdateRealisasiKegiatanModal> {
  int? realisasi = 1;
  String? keterangan = '';

  late TextEditingController _realisasiController = TextEditingController();
  late TextEditingController _keteranganController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Realisasi Kegiatan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: _realisasiController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        realisasi = int.tryParse(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Realisasi Kegiatan',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _keteranganController,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        keterangan = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Keterangan Realisasi',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () async {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                final result = await APIService().addRealisasi(
                                  widget.id_kegiatan!.toString(),
                                  realisasi.toString(),
                                  keterangan.toString(),
                                );
                                if (result.containsKey('success')) {
                                  SnackbarUtils.showSuccessSnackbar(
                                      context, result['success']);
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DaftarKegiatanPage(
                                        id_laporan: widget.id_laporan,
                                        bulan_laporan: widget.bulan_laporan!,
                                        is_no_reporting: true,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.of(context).pop();
                                  SnackbarUtils.showErrorSnackbar(
                                      context, result['error']);
                                }
                              } catch (e) {
                                Navigator.of(context).pop();
                                SnackbarUtils.showErrorSnackbar(
                                    context, "Gagal menambahkan laporan.");
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            },
                      child: isLoading
                          ? CircularProgressIndicator()
                          : Text('Simpan'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
          ],
        ),
      ),
    );
  }
}
