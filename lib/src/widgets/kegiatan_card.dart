import 'package:catatan_harian_bps/src/models/kegiatan.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/daftar_kegiatan_page.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/update_realisasi_kegiatan_modal.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class KegiatanCard extends StatefulWidget {
  final Kegiatan kegiatan;
  final int? id_laporan;
  final String? bulan_laporan;
  final bool? is_no_reporting;
  final bool? is_rejection;
  final bool? is_verifikasi;

  KegiatanCard(
      {required this.kegiatan,
      this.id_laporan,
      this.bulan_laporan,
      this.is_no_reporting,
      this.is_rejection = false,
      this.is_verifikasi = false});

  @override
  _KegiatanCardState createState() => _KegiatanCardState();
}

class _KegiatanCardState extends State<KegiatanCard> {
  bool isLoading = false;

  void _showDetailsDialog(BuildContext context, Kegiatan kegiatan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(kegiatan.nama.toString()),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDetailItem(
                  'Tanggal',
                  DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(DateTime.parse(kegiatan.tanggal!)),
                ),
                _buildDetailItem('Target', kegiatan.target!),
                if (kegiatan.realisasi != null)
                  _buildDetailItem('Realisasi', kegiatan.realisasi ?? '-'),
                if (kegiatan.realisasi != null)
                  _buildDetailItem('Keterangan', kegiatan.keterangan ?? '-'),
                _buildDetailItem('NIP Pencatat', kegiatan.nip_pengguna!),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(value),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _showDetailsDialog(context, widget.kegiatan),
      child: Card(
        elevation: 5,
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color:
                (widget.is_rejection! || widget.kegiatan.status == 'rejection')
                    ? Colors.red[200]
                    : (widget.kegiatan.realisasi != null)
                        ? Color(0xFFE2EFE3)
                        : Color(0xFFD9F1F4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.kegiatan.nama!,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    (isLoading)
                        ? CircularProgressIndicator()
                        : (widget.is_no_reporting == true ||
                                widget.kegiatan.status == 'rejection' ||
                                widget.kegiatan.status == 'inputing')
                            ? (!widget.is_verifikasi!)
                                ? PopupMenuButton<String>(
                                    onSelected: (value) async {
                                      if (value == "realisasi") {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          builder: (BuildContext context) {
                                            return UpdateRealisasiKegiatanModal(
                                              id_kegiatan: widget.kegiatan.id,
                                              id_laporan: widget.id_laporan,
                                              bulan_laporan:
                                                  widget.bulan_laporan,
                                            );
                                          },
                                        );
                                      } else if (value == "hapus") {
                                        _showDeleteConfirmation(context);
                                      }
                                    },
                                    itemBuilder: (BuildContext context) {
                                      return <PopupMenuEntry<String>>[
                                        if (widget.kegiatan.realisasi != null)
                                          const PopupMenuItem<String>(
                                            value: 'hapus',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.red),
                                                SizedBox(width: 8),
                                                Text('Hapus'),
                                              ],
                                            ),
                                          )
                                        else
                                          const PopupMenuItem<String>(
                                            value: 'realisasi',
                                            child: Row(
                                              children: [
                                                Icon(Icons.check_circle,
                                                    color: Colors.green),
                                                SizedBox(width: 8),
                                                Text('Realisasi'),
                                              ],
                                            ),
                                          ),
                                        if (widget.kegiatan.realisasi == null)
                                          const PopupMenuItem<String>(
                                            value: 'hapus',
                                            child: Row(
                                              children: [
                                                Icon(Icons.delete,
                                                    color: Colors.red),
                                                SizedBox(width: 8),
                                                Text('Hapus'),
                                              ],
                                            ),
                                          ),
                                      ];
                                    },
                                    icon: const Icon(Icons.more_vert),
                                  )
                                : SizedBox()
                            : SizedBox(),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  DateFormat('dd MMMM yyyy', 'id_ID')
                      .format(DateTime.parse(widget.kegiatan.tanggal!)),
                  style: const TextStyle(color: Colors.black),
                ),
                const Divider(color: Colors.black),
                IntrinsicHeight(
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Target',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(": " + widget.kegiatan.target!),
                      ),
                      const Expanded(
                        child: Text(
                          'Realisasi',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          ': ${widget.kegiatan.realisasi == null || widget.kegiatan.realisasi == "" ? '-' : widget.kegiatan.realisasi}',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                if (widget.kegiatan.realisasi != null)
                  Text(
                    'Keterangan: ${widget.kegiatan.keterangan}',
                    style: const TextStyle(color: Colors.black),
                  ),
              ],
            ),
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
          content: Text('Apakah Anda yakin ingin menghapus kegiatan ini?'),
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
                          try {
                            setState(() {
                              isLoading = true;
                            });
                            int? idDelete = widget.kegiatan.id;
                            final result =
                                await APIService().deleteKegiatan(idDelete!);
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
                                          is_no_reporting:
                                              widget.is_no_reporting,
                                        )),
                              );
                            } else {
                              SnackbarUtils.showErrorSnackbar(
                                  context, result['error']);
                            }
                          } catch (e) {
                            SnackbarUtils.showErrorSnackbar(
                                context, 'Gagal menghapus kegiatan');
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
