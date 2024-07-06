import 'package:catatan_harian_bps/src/views/pengawas/laporan_page/daftar_laporan_pengawas_page.dart';
import 'package:catatan_harian_bps/src/views/pengawas/pengguna_page/daftar_pengguna_page.dart';
import 'package:catatan_harian_bps/src/widgets/cari_kegiatan_modal.dart';
import 'package:catatan_harian_bps/src/widgets/about_apps_modal.dart';
import 'package:catatan_harian_bps/src/widgets/my_profile_modal.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/session.dart';
import 'package:intl/intl.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

enum PageType {
  laporan,
  pengguna,
}

class HomePengawas extends StatefulWidget {
  final String? pageType;

  HomePengawas({this.pageType});

  @override
  _HomePengawasState createState() => _HomePengawasState();
}

class _HomePengawasState extends State<HomePengawas> {
  late String _nip = '';
  late String _nama = '';
  late String _role = '';

  PageType? _currentPage;

  @override
  void initState() {
    super.initState();
    _decodeToken();

    if (widget.pageType != null) {
      _currentPage =
          widget.pageType == 'pengguna' ? PageType.pengguna : PageType.laporan;
    } else {
      _currentPage = PageType.laporan;
    }
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
            onPressed: () async {
              // var bearerToken = await SessionManager.getBearerToken();
              // print(bearerToken);
            },
          ),
        ],
        iconTheme: IconThemeData(color: Color(0xFF2D2B2C)),
      ),
      backgroundColor: Color(0xFFF7F7F7),
      body: _buildBody(),
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
                icon: Icon(Icons.article, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _currentPage = PageType.laporan;
                  });
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: IconButton(
                icon: Icon(Icons.manage_accounts, color: Colors.black),
                onPressed: () {
                  setState(() {
                    _currentPage = PageType.pengguna;
                  });
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
                icon: Icon(Icons.group, color: Colors.black),
                onPressed: () {},
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
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_currentPage) {
      case PageType.laporan:
        return DaftarLaporanPengawasPage();
      case PageType.pengguna:
        return DaftarPenggunaPage();
      default:
        return DaftarLaporanPengawasPage();
    }
  }
}
