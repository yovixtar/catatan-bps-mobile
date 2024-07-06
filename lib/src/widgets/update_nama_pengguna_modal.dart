import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';

class UpdateNamaPenggunaModal extends StatefulWidget {
  final String? nip;
  final String? nama;

  UpdateNamaPenggunaModal({
    required this.nip,
    required this.nama,
  });

  @override
  _UpdateNamaPenggunaModalState createState() =>
      _UpdateNamaPenggunaModalState();
}

class _UpdateNamaPenggunaModalState extends State<UpdateNamaPenggunaModal> {
  String? namaPengguna = '';
  late TextEditingController _namaPenggunaController = TextEditingController();
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
                    'Ganti Nama Pengguna',
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
                    controller: _namaPenggunaController,
                    maxLines: null,
                    onChanged: (value) {
                      setState(() {
                        namaPengguna = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Pengguna',
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
                                String? nama_pengguna = (namaPengguna != '')
                                    ? namaPengguna
                                    : widget.nama;
                                final result =
                                    await APIService().changeNameUser(
                                  widget.nip!.toString(),
                                  nama_pengguna.toString(),
                                );
                                if (result.containsKey('success')) {
                                  SnackbarUtils.showSuccessSnackbar(
                                      context, result['success']);
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacementNamed(
                                      context, '/petugas-home');
                                } else {
                                  Navigator.of(context).pop();
                                  SnackbarUtils.showErrorSnackbar(
                                      context, result['error']);
                                }
                              } catch (e) {
                                Navigator.of(context).pop();
                                SnackbarUtils.showErrorSnackbar(
                                    context, "Gagal mengupdate Nama pengguna.");
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
