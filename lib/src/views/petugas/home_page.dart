import 'package:catatan_harian_bps/src/widgets/cari_kegiatan_modal.dart';
import 'package:catatan_harian_bps/src/widgets/about_apps_modal.dart';
import 'package:catatan_harian_bps/src/widgets/my_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/session.dart';
import 'package:catatan_harian_bps/src/views/petugas/laporan_page/daftar_laporan_page.dart';
import 'package:catatan_harian_bps/src/views/petugas/laporan_page/tambah_laporan_modal.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class HomePetugas extends StatefulWidget {
  @override
  _HomePetugasState createState() => _HomePetugasState();
}

class _HomePetugasState extends State<HomePetugas> {
  late String _nip = '';
  late String _nama = '';
  late String _role = '';

  @override
  void initState() {
    super.initState();
    _decodeToken();
  }

  Future<void> _decodeToken() async {
    String? token = await SessionManager.getToken();
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      setState(() {
        _nip = decodedToken['nip'] ?? '';
        _nama = decodedToken['nama'] ?? '';
        _role = decodedToken['role'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          DateFormat('EEEE, dd MMMM yyyy', 'id_ID').format(DateTime.now()),
          style: TextStyle(
            color: Color(0xFF2D2B2C),
          ),
        ),
        toolbarHeight: 80,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () => {},
          ),
        ],
        iconTheme: IconThemeData(color: Color(0xFF2D2B2C)),
      ),
      backgroundColor: Color(0xFFF7F7F7),
      body: DaftarLaporanPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (BuildContext context) {
              return TambahLaporanModal();
            },
          );
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 5,
        height: 60,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.group, color: Colors.black),
                onPressed: () {},
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.account_circle, color: Colors.black),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return MyProfileModal(
                        nip: _nip,
                        nama: _nama,
                        role: _role,
                      );
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.search, color: Colors.black),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return CariKegiatanModal();
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.info_outline, color: Colors.black),
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return AboutAppsModal();
                    },
                  );
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: SizedBox(),
            )
          ],
        ),
      ),
    );
  }
}
