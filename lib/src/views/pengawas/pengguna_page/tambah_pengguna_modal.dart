import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/pengawas/home_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class TambahPenggunaModal extends StatefulWidget {
  @override
  _TambahPenggunaModalState createState() => _TambahPenggunaModalState();
}

class _TambahPenggunaModalState extends State<TambahPenggunaModal> {
  String? nama = '';
  String? nip = '';
  String? password = '';
  String? role = '';
  String? bagian = '';
  bool obscurePassword = true;

  late TextEditingController _nipController = TextEditingController();
  late TextEditingController _namaController = TextEditingController();
  late TextEditingController _passwordController = TextEditingController();
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
                    'Tambah Pengguna',
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
                    controller: _namaController,
                    onChanged: (value) {
                      setState(() {
                        nama = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Nama Pengguna',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nipController,
                    onChanged: (value) {
                      setState(() {
                        nip = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'NIP',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                      });
                    },
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: role,
                    onChanged: (value) {
                      setState(() {
                        role = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: '',
                        child: Text('Pilih Role'),
                      ),
                      DropdownMenuItem(
                        value: 'petugas',
                        child: Text('Petugas'),
                      ),
                      DropdownMenuItem(
                        value: 'pengawas',
                        child: Text('Pengawas'),
                      ),
                    ],
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  DropdownButtonFormField<String>(
                    value: bagian,
                    onChanged: (value) {
                      setState(() {
                        bagian = value!;
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: '',
                        child: Text('Pilih Bagian Petugas / Pengawas'),
                      ),
                      DropdownMenuItem(
                        value: 'Statistisi Ahli Muda',
                        child: Text('Statistisi Ahli Muda'),
                      ),
                      DropdownMenuItem(
                        value: 'Statistisi Ahli Pertama',
                        child: Text('Statistisi Ahli Pertama'),
                      ),
                      DropdownMenuItem(
                        value: 'Statistisi Penyelia',
                        child: Text('Statistisi Penyelia'),
                      ),
                      DropdownMenuItem(
                        value: 'Statistisi Mahir',
                        child: Text('Statistisi Mahir'),
                      ),
                      DropdownMenuItem(
                        value: 'Pranata Komputer Ahli Muda',
                        child: Text('Pranata Komputer Ahli Muda'),
                      ),
                      DropdownMenuItem(
                        value: 'Pelaksana',
                        child: Text('Pelaksana'),
                      ),
                      DropdownMenuItem(
                        value: 'Kepala Sub Bagian Umum',
                        child: Text('(Pengawas) Kepala Sub Bagian Umum'),
                      ),
                    ],
                    decoration: InputDecoration(
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
                                final result = await APIService().addUser(
                                  nama!,
                                  nip!,
                                  password!,
                                  role!,
                                  bagian!,
                                );
                                if (result.containsKey('success')) {
                                  SnackbarUtils.showSuccessSnackbar(
                                      context, result['success']);
                                  Navigator.of(context).pop();
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePengawas(
                                              pageType: 'pengguna',
                                            )),
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
