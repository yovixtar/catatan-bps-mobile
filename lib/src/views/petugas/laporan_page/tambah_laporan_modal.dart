import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/petugas/home_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:month_year_picker/month_year_picker.dart';

class TambahLaporanModal extends StatefulWidget {
  @override
  _TambahLaporanModalState createState() => _TambahLaporanModalState();
}

class _TambahLaporanModalState extends State<TambahLaporanModal> {
  late DateTime selectedDate = DateTime.now();
  late String keterangan = '';
  late TextEditingController _bulanTahunController = TextEditingController();
  late TextEditingController _keteranganController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _updateBulanTahunController(selectedDate);
  }

  void _updateBulanTahunController(DateTime date) {
    _bulanTahunController.text = DateFormat('MMMM yyyy', 'id').format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showMonthYearPicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(DateTime.now().year - 5),
      lastDate: DateTime(DateTime.now().year + 5),
      locale: Locale('id'),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _updateBulanTahunController(selectedDate);
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
                    'Tambah Laporan',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Tutup modal
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
                        child: Text('Pilih Bulan'),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextFormField(
                            readOnly: true,
                            controller: _bulanTahunController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Bulan-Tahun',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _keteranganController,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        keterangan = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Keterangan',
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
                              String bulan =
                                  DateFormat('MM').format(selectedDate);
                              String tahun =
                                  DateFormat('yyyy').format(selectedDate);
                              try {
                                final result = await APIService().addLaporan(
                                  bulan,
                                  tahun,
                                  keterangan,
                                );
                                if (result.containsKey('success')) {
                                  SnackbarUtils.showSuccessSnackbar(
                                      context, result['success']);
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePetugas()),
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
                          : Text(
                              'Simpan'), // Tampilkan CircularProgressIndicator jika isLoading true
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
