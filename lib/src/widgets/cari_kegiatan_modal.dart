import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/daftar_kegiatan_page.dart';

class CariKegiatanModal extends StatefulWidget {
  final int? id_laporan;
  final bool? is_no_reporting;

  CariKegiatanModal({
    this.id_laporan,
    this.is_no_reporting,
  });

  @override
  _CariKegiatanModalState createState() => _CariKegiatanModalState();
}

class _CariKegiatanModalState extends State<CariKegiatanModal> {
  String? keyword = '';

  late TextEditingController _keywordController = TextEditingController();

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
                    'Cari Kegiatan',
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
                    controller: _keywordController,
                    onChanged: (value) {
                      setState(() {
                        keyword = value;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: 'Cari kegiatan disini...',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (widget.id_laporan != null) {
                          Navigator.pop(context);
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DaftarKegiatanPage(
                              id_laporan: widget.id_laporan,
                              bulan_laporan: 'Cari : ${keyword}',
                              keyword: keyword.toString(),
                              is_cari: true,
                              is_no_reporting: widget.is_no_reporting,
                            ),
                          ),
                        );
                      },
                      child: Text('Cari'),
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
