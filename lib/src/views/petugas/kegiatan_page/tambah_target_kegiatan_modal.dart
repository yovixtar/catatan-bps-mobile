import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/daftar_kegiatan_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';

class TambahTargetKegiatanModal extends StatefulWidget {
  final int? id_laporan;
  final String? bulan_laporan;

  TambahTargetKegiatanModal(
      {required this.id_laporan, required this.bulan_laporan});

  @override
  _TambahTargetKegiatanModalState createState() =>
      _TambahTargetKegiatanModalState();
}

class _TambahTargetKegiatanModalState extends State<TambahTargetKegiatanModal> {
  late DateTime selectedDate = DateTime.now();
  String? namaKegiatan = '';
  int? target = 1;
  late TextEditingController _tanggalController = TextEditingController();
  late TextEditingController _namaKegiatanController = TextEditingController();
  late TextEditingController _targetController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _updatetanggalController(selectedDate);
  }

  void _updatetanggalController(DateTime date) {
    _tanggalController.text = DateFormat('dd MMMM yyyy', 'id').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      locale: Locale('id'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _updatetanggalController(selectedDate);
      });
    }
  }

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
                    'Tambah Kegiatan',
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: Icon(Icons.calendar_today),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _tanggalController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Tanggal Kegiatan',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _namaKegiatanController,
                    onChanged: (value) {
                      setState(() {
                        namaKegiatan = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Kegiatan',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _targetController,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        target = int.tryParse(value);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Target Kegiatan',
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
                              setState(() {
                                isLoading = true;
                              });
                              String tanggal =
                                  DateFormat('yyyy-MM-dd').format(selectedDate);
                              try {
                                final result = await APIService().addKegiatan(
                                  widget.id_laporan!.toString(),
                                  tanggal,
                                  namaKegiatan!,
                                  target!.toString(),
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
