import 'package:catatan_harian_bps/src/models/laporan.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/pengawas/kegiatan_page/daftar_kegiatan_pengawas_page.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/daftar_kegiatan_page.dart';
import 'package:catatan_harian_bps/src/views/petugas/verifikasi_page/verifikasi_kegiatan_page.dart';
import 'package:catatan_harian_bps/src/views/petugas/verifikasi_page/verifikasi_laporan_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:catatan_harian_bps/src/views/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaporanCard extends StatefulWidget {
  final Laporan laporan;
  final bool is_pengawas;
  final bool is_verifikasi;

  LaporanCard(
      {required this.laporan,
      this.is_pengawas = false,
      this.is_verifikasi = false});

  @override
  _LaporanCardState createState() => _LaporanCardState();
}

class _LaporanCardState extends State<LaporanCard> {
  String? keterangan = '';
  bool isLoading = false;

  late TextEditingController _keteranganController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    bool isNotReporting = (widget.laporan.status_laporan == 'inputing' ||
            widget.laporan.status_laporan == 'rejection')
        ? true
        : false;

    return InkWell(
      onTap: () => {
        if (widget.laporan.active! &&
            !widget.is_pengawas &&
            widget.is_verifikasi)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DaftarVerifikasiKegiatanPage(
                  id_verifikasi_laporan: widget.laporan.id!,
                  tanggal_verifikasi: widget.laporan.tanggal,
                ),
              ),
            )
          }
        else if (widget.laporan.active! && !widget.is_pengawas)
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DaftarKegiatanPage(
                  id_laporan: widget.laporan.id!,
                  bulan_laporan:
                      '${DateFormat('MMMM yyyy', 'id_ID').format(DateTime(int.parse(widget.laporan.tahun!), int.parse(widget.laporan.bulan!)))}',
                  is_no_reporting: isNotReporting,
                ),
              ),
            )
          }
        else
          {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DaftarKegiatanPengawasPage(
                  id_laporan: widget.laporan.id!,
                  bulan_laporan:
                      '${DateFormat('MMMM yyyy', 'id_ID').format(DateTime(int.parse(widget.laporan.tahun!), int.parse(widget.laporan.bulan!)))}',
                  is_no_reporting: isNotReporting,
                  nip_pengguna_kegiatan: widget.laporan.nip_pengguna,
                ),
              ),
            )
          }
      },
      child: Card(
        margin: EdgeInsets.all(10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: (widget.laporan.active == false)
                ? Color(0xFFD4CCC9)
                : (widget.laporan.status_laporan == 'reporting')
                    ? Color(0xFFE2EFE3)
                    : (widget.laporan.status_laporan == 'rejection')
                        ? Color(0xFFFFDADA)
                        : (widget.laporan.status_laporan == 'approval')
                            ? Color(0xFFDAE5FF)
                            : Color(0xFFD9F1F4),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 12.0, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (widget.is_pengawas || widget.is_verifikasi)
                  SizedBox(
                    height: 6,
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        (!widget.is_verifikasi)
                            ? "${DateFormat('MMMM yyyy', 'id_ID').format(DateTime(int.parse(widget.laporan.tahun!), int.parse(widget.laporan.bulan!)))}"
                            : "${DateFormat('dd MMMM yyyy', 'id_ID').format(DateTime.parse(widget.laporan.tanggal!))}",
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isLoading) CircularProgressIndicator(),
                    if (!isLoading &&
                        !widget.is_pengawas &&
                        !widget.is_verifikasi)
                      PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'detail') {
                            _showDetailsDialog(context, widget.laporan);
                          }
                          if (value == 'disable' || value == 'enable') {
                            try {
                              setState(() {
                                isLoading = true;
                              });
                              final result = await APIService()
                                  .switchLaporan(widget.laporan.id!.toString());
                              if (result.containsKey('success')) {
                                SnackbarUtils.showSuccessSnackbar(
                                    context, result['success']);
                                Navigator.pop(context);
                                Navigator.pushNamed(context, '/petugas-home');
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
                          } else if (value == 'hapus') {
                            _showDeleteConfirmation(context);
                          } else if (value == 'riwayat verifikasi') {
                            // Navigator.pushNamed(
                            //     context, '/riwayat-verifikasi-laporan',
                            //     arguments: {'id_laporan': widget.laporan.id});
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DaftarVerifikasiLaporanPage(
                                  id_laporan: widget.laporan.id,
                                ),
                              ),
                            );
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return <PopupMenuEntry<String>>[
                            if (widget.laporan.active!)
                              const PopupMenuItem<String>(
                                value: 'detail',
                                child: Row(
                                  children: [
                                    Icon(Icons.info, color: Color(0xFFD4CCC9)),
                                    SizedBox(width: 8),
                                    Text('Detail'),
                                  ],
                                ),
                              ),
                            if (widget.laporan.status_laporan != 'inputing')
                              const PopupMenuItem<String>(
                                value: 'riwayat verifikasi',
                                child: Row(
                                  children: [
                                    Icon(Icons.history,
                                        color: Colors.blueAccent),
                                    SizedBox(width: 8),
                                    Text('Riwayat Verifikasi'),
                                  ],
                                ),
                              ),
                            if (widget.laporan.active! && isNotReporting)
                              const PopupMenuItem<String>(
                                value: 'disable',
                                child: Row(
                                  children: [
                                    Icon(Icons.block, color: Color(0xFFD4CCC9)),
                                    SizedBox(width: 8),
                                    Text('Disable'),
                                  ],
                                ),
                              ),
                            if (!widget.laporan.active!)
                              const PopupMenuItem<String>(
                                value: 'enable',
                                child: Row(
                                  children: [
                                    Icon(Icons.check_circle,
                                        color: Colors.greenAccent),
                                    SizedBox(width: 8),
                                    Text('Enable'),
                                  ],
                                ),
                              ),
                            if (!widget.laporan.active!)
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
                SizedBox(
                  height: 10,
                ),
                if (widget.is_pengawas)
                  Text(
                      "Petugas : ${widget.laporan.nama_pengguna} (${widget.laporan.nip_pengguna})"),
                if (widget.is_pengawas)
                  SizedBox(
                    height: 10,
                  ),
                if (!widget.is_pengawas)
                  RichText(
                    text: TextSpan(
                      text: 'Status : ',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: (!widget.is_verifikasi)
                              ? widget.laporan.status_laporan!.capitalize()
                              : widget.laporan.status_verifikasi!.capitalize(),
                          style: TextStyle(
                            color: (!widget.laporan.active!)
                                ? Colors.black
                                : (widget.laporan.status_laporan! == 'inputing')
                                    ? Colors.blue
                                    : (widget.laporan.status_laporan! ==
                                            'rejection')
                                        ? Colors.red
                                        : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.is_pengawas || widget.is_verifikasi)
                  SizedBox(
                    height: 5,
                  ),
                if (widget.is_pengawas || widget.is_verifikasi)
                  RichText(
                    text: TextSpan(
                      text: 'Keterangan : ',
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                          text: (widget.laporan.keterangan_verifikasi != null ||
                                  widget.laporan.keterangan_verifikasi != '')
                              ? widget.laporan.keterangan_verifikasi
                              : '-',
                        ),
                      ],
                    ),
                  ),
                SizedBox(
                  height: 5,
                ),
                if (widget.laporan.active! &&
                    !widget.is_pengawas &&
                    !widget.is_verifikasi)
                  TextButton(
                    onPressed: () {
                      if (widget.laporan.status_laporan == 'inputing' ||
                          widget.laporan.status_laporan == 'rejection') {
                        _showVerificationConfirmation(context, 'reporting');
                      }
                    },
                    style: TextButton.styleFrom(
                      primary: Colors.blue,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        (widget.laporan.status_laporan == 'inputing' ||
                                widget.laporan.status_laporan == 'rejection')
                            ? Icon(Icons.verified,
                                color: const Color.fromRGBO(68, 138, 255, 1))
                            : SizedBox(),
                        Flexible(
                          child: Text(
                            (widget.laporan.status_laporan == 'approval')
                                ? 'Terverifikasi'
                                : (widget.laporan.status_laporan == 'reporting')
                                    ? 'Proses Verifikasi'
                                    : 'Verifikasi',
                            style: TextStyle(
                              color: Colors.blueAccent,
                            ),
                            textAlign:
                                TextAlign.center, // Pusatkan teks dalam kotak
                            overflow: TextOverflow
                                .visible, // Tampilkan teks di luar kotak jika overflow
                          ),
                        ),
                      ],
                    ),
                  ),
                if (widget.is_pengawas || widget.is_verifikasi)
                  SizedBox(
                    height: 12,
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Laporan laporan) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              '${DateFormat('MMMM yyyy', 'id_ID').format(DateTime(int.parse(widget.laporan.tahun!), int.parse(widget.laporan.bulan!)))}'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildDetailItem(
                  'Status',
                  widget.laporan.status_laporan!.capitalize(),
                ),
                SizedBox(
                  height: 10,
                ),
                _buildDetailItem(
                    'Keterangan',
                    widget.laporan.keterangan_laporan!.isNotEmpty
                        ? widget.laporan.keterangan_laporan!
                        : '-'),
                SizedBox(
                  height: 10,
                ),
                _buildDetailItem(
                  'Petugas',
                  "${widget.laporan.nama_pengguna} (${widget.laporan.nip_pengguna})",
                ),
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
                  text: 'menghapus permanen',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
                TextSpan(
                  text: ' laporan ini?',
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
                            int? idDelete = widget.laporan.id;
                            final result =
                                await APIService().deleteLaporan(idDelete!);
                            if (result.containsKey('success')) {
                              SnackbarUtils.showSuccessSnackbar(
                                  context, result['success']);
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, '/petugas-home');
                            } else {
                              SnackbarUtils.showErrorSnackbar(
                                  context, result['error']);
                            }
                          } catch (e) {
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

  void _showVerificationConfirmation(
      BuildContext context, String status_change) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          scrollable: false,
          title: Text('Konfirmasi'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
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
                    "Pastikan seluruh kegiatan telah terrealisasi.",
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.left,
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
                      labelText: 'Keterangan Verifikasi',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              );
            },
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
                            int? id_laporan = widget.laporan.id;
                            final result = await APIService().verifikasi(
                              id_laporan.toString(),
                              status_change,
                              keterangan!,
                            );
                            if (result.containsKey('success')) {
                              SnackbarUtils.showSuccessSnackbar(
                                  context, result['success']);
                              Navigator.pop(context);
                              Navigator.pushReplacementNamed(
                                  context, '/petugas-home');
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
