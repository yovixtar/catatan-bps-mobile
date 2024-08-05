import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/pengawas/home_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/models/pengguna.dart';

class PenggunaCard extends StatefulWidget {
  final Pengguna pengguna;

  PenggunaCard({required this.pengguna});

  @override
  _PenggunaCardState createState() => _PenggunaCardState();
}

class _PenggunaCardState extends State<PenggunaCard> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: (widget.pengguna.active == false)
              ? Color(0xFFD4CCC9)
              : (widget.pengguna.role == 'pengawas')
                  ? Color(0xFFE2EFE3)
                  : Color(0xFFD9F1F4),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ListTile(
          title: Padding(
            padding: EdgeInsets.only(
              top: 10,
              left: 10,
            ),
            child: Text(
              widget.pengguna.nama.toString(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Padding(
            padding: EdgeInsets.only(
              bottom: 10,
              left: 10,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text('NIP. ${widget.pengguna.nip.toString()}'),
                Text('Bagian : ${widget.pengguna.bagian}'),
                Text(
                  "Sebagai : ${(widget.pengguna.role == 'pengawas') ? 'Pengawas' : 'Petugas'}",
                ),
              ],
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'detail') {}
                  if (value == 'hapus') {
                    _showDeleteConfirmation(context);
                  }
                  if (value == 'disable' || value == 'enable') {
                    try {
                      setState(() {
                        isLoading = true;
                      });
                      final result = await APIService()
                          .switchPengguna(widget.pengguna.nip!.toString());
                      if (result.containsKey('success')) {
                        SnackbarUtils.showSuccessSnackbar(
                            context, result['success']);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePengawas(
                                    pageType: 'pengguna',
                                  )),
                        );
                      } else {
                        SnackbarUtils.showErrorSnackbar(
                            context, result['error']);
                      }
                    } catch (e) {
                      SnackbarUtils.showErrorSnackbar(
                          context, 'Gagal mengswitch laporan.');
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  }
                },
                itemBuilder: (BuildContext context) {
                  return <PopupMenuEntry<String>>[
                    if (widget.pengguna.active!)
                      const PopupMenuItem<String>(
                        value: 'disable',
                        child: Row(
                          children: [
                            Icon(Icons.block, color: Colors.grey),
                            SizedBox(width: 8),
                            Text('Disable'),
                          ],
                        ),
                      ),
                    if (!widget.pengguna.active!)
                      const PopupMenuItem<String>(
                        value: 'enable',
                        child: Row(
                          children: [
                            Icon(Icons.check_circle, color: Colors.greenAccent),
                            SizedBox(width: 8),
                            Text('Enable'),
                          ],
                        ),
                      ),
                    if (!widget.pengguna.active!)
                      const PopupMenuItem<String>(
                        value: 'hapus',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Hapus'),
                          ],
                        ),
                      ),
                  ];
                },
                icon: const Icon(Icons.more_vert),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi'),
          content: RichText(
            text: TextSpan(
              text: 'Apakah Anda yakin ingin ',
              style: TextStyle(color: Colors.black),
              children: <TextSpan>[
                TextSpan(
                  text: 'Menghapus Permanen',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                TextSpan(
                  text: ' Pengguna NIP. ${widget.pengguna.nip} ini?',
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tidak'),
              onPressed: () {
                setState(() {
                  isLoading = false;
                });
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
                                .deleteUser(widget.pengguna.nip!);
                            if (result.containsKey('success')) {
                              SnackbarUtils.showSuccessSnackbar(
                                  context, result['success']);
                              Navigator.pop(context);
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePengawas(
                                          pageType: 'pengguna',
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
