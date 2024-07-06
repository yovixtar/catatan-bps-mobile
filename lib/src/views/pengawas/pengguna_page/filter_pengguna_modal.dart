import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';

class FilterPenggunaModal extends StatefulWidget {
  final void Function(String role) onFilterSelected;

  FilterPenggunaModal({required this.onFilterSelected});

  @override
  _FilterPenggunaModalState createState() => _FilterPenggunaModalState();
}

class _FilterPenggunaModalState extends State<FilterPenggunaModal> {
  String? role = '';
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
                    'Filter Pengguna',
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
                                widget.onFilterSelected(role!);

                                Navigator.of(context).pop();
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
