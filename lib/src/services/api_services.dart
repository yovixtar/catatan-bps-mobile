import 'dart:convert';

import 'package:catatan_harian_bps/src/models/laporan.dart';
import 'package:catatan_harian_bps/src/models/kegiatan.dart';
import 'package:catatan_harian_bps/src/models/pengguna.dart';
import 'package:catatan_harian_bps/src/services/session.dart';
import 'package:http/http.dart' as http;

class APIService {
  String baseUrl = "https://dskripsi.iyabos.com/api";

  Future<Pengguna?> login({
    String? nip,
    String? password,
  }) async {
    var response = await http.post(
      Uri.parse("$baseUrl/login"),
      body: {
        'nip': nip,
        'password': password,
      },
    );
    var responseData = jsonDecode(response.body);
    if (responseData['code'] == 200) {
      var token = responseData['token'];
      await SessionManager.saveToken(token);
      return Pengguna.fromJson(responseData);
    } else {
      throw Exception('Login Gagal');
    }
  }

  Future<List<Pengguna>?> getDataUser({String? role}) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      if (bearerToken != null) {
        String queryParams = '';
        if (role != null && role.isNotEmpty) {
          queryParams += '${queryParams.isEmpty ? '?' : '&'}role=$role';
        }

        var response = await http.get(
          Uri.parse("$baseUrl/pengguna$queryParams"),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );
        var responseData = jsonDecode(response.body);
        if (responseData['code'] == 200) {
          List<dynamic> data = responseData['data'];
          List<Pengguna> userList =
              data.map((item) => Pengguna.fromJson(item)).toList();
          return userList;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> addUser(String name, String nip, String password,
      String role, String bagian) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/pengguna"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'nama': name,
          'nip': nip,
          'password': password,
          'role': role,
          'bagian': bagian,
        },
      );
      var responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> changePass(String nip, String password) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/pengguna/ganti-password"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'nip': nip,
          'password-baru': password,
        },
      );
      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> changeNameUser(String nip, String nama) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/pengguna/ganti-nama"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'nip': nip,
          'nama-baru': nama,
        },
      );
      var responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        var session = await SessionManager.saveToken(responseData['token']);
        // var data = await SessionManager.saveData(responseData);

        if (session) {
          return {'success': "${responseData['message']}"};
        } else {
          return {'error': "Gagal menyimpan access token!"};
        }
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> switchPengguna(String nip) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/pengguna/switch-status"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'nip': nip,
        },
      );
      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> deleteUser(String nip) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.delete(
        Uri.parse("$baseUrl/pengguna/$nip"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );
      var responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> addKegiatan(
      String? id_laporan, String? tanggal, String? nama, String? target) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/kegiatan/target"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'id_laporan': id_laporan,
          'tanggal': tanggal,
          'nama': nama,
          'target': target,
        },
      );
      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 201) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<List<Kegiatan>?> getKegiatan({int? id_laporan, String? cari}) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      if (bearerToken != null) {
        String queryParams = '';
        if (id_laporan != null) {
          queryParams += '?id_laporan=$id_laporan';
        }
        if (cari != null && cari.isNotEmpty) {
          queryParams += '${queryParams.isEmpty ? '?' : '&'}keyword=$cari';
        }

        var response = await http.get(
          Uri.parse("$baseUrl/kegiatan$queryParams"),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        var responseData = jsonDecode(response.body);

        if (responseData['code'] == 200) {
          try {
            List<dynamic> data = responseData['data'];

            List<Kegiatan> kegiatanList =
                data.map((item) => Kegiatan.fromJson(item)).toList();
            return kegiatanList;
          } catch (e) {
            // throw Exception('Gagal mapping data kegiatan');
            return null;
          }
        } else {
          // throw Exception('Gagal Load Data');
          return null;
        }
      } else {
        // throw Exception('Token tidak tersedia');
        return null;
      }
    } catch (e) {
      // throw Exception('Gagal mendapatkan token');
      return null;
    }
  }

  Future<Map<String, dynamic>> addRealisasi(
      String? id_kegiatan, String? realisasi, String? keterangan) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/kegiatan/realisasi"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'id': id_kegiatan,
          'realisasi': realisasi,
          'keterangan': keterangan,
        },
      );
      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> deleteKegiatan(int id) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.delete(
        Uri.parse("$baseUrl/kegiatan/$id"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<List<Laporan>?> getLaporan({String? tahun, String? status}) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();
      String queryParams = '';
      if (tahun != null) {
        queryParams += '?tahun=$tahun';
      }
      if (status != null && status.isNotEmpty) {
        queryParams += '${queryParams.isEmpty ? '?' : '&'}status=$status';
      }

      if (bearerToken != null) {
        var response = await http.get(
          Uri.parse("$baseUrl/laporan$queryParams"),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        var responseData = jsonDecode(response.body);

        if (responseData['code'] == 200) {
          try {
            List<dynamic> data = responseData['data'];

            List<Laporan> laporanList =
                data.map((item) => Laporan.fromJson(item)).toList();
            return laporanList;
          } catch (e) {
            throw Exception('Gagal mapping data kegiatan');
          }
        } else {
          // throw Exception('Gagal Load Data');
          return null;
        }
      } else {
        // throw Exception('Token tidak tersedia');
        return null;
      }
    } catch (e) {
      // throw Exception('Gagal mendapatkan token');
      return null;
    }
  }

  Future<Map<String, dynamic>> addLaporan(
      String bulan, String tahun, String keterangan) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/laporan"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'bulan': bulan,
          'tahun': tahun,
          'keterangan': keterangan,
        },
      );
      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 201) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> deleteLaporan(int id_laporan) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.delete(
        Uri.parse("$baseUrl/laporan/$id_laporan"),
        headers: {'Authorization': 'Bearer $bearerToken'},
      );

      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> switchLaporan(String id) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/laporan/switch-status"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'id': id,
        },
      );
      var responseData = jsonDecode(response.body);

      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<Map<String, dynamic>> verifikasi(
      String id_laporan, String status, String keterangan) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/verifikasi"),
        headers: {'Authorization': 'Bearer $bearerToken'},
        body: {
          'id_laporan': id_laporan,
          'status': status,
          'keterangan': keterangan,
        },
      );
      var responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  // Admin

  Future<List<Laporan>?> getLaporanPengawas(
      {String? tahun, String? status, String? petugas,}) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      String queryParams = '';
      if (tahun != null) {
        queryParams += '?tahun=$tahun';
      }
      if (status != null && status.isNotEmpty) {
        queryParams += '${queryParams.isEmpty ? '?' : '&'}status=$status';
      }
      if (petugas != null && petugas.isNotEmpty) {
        queryParams += '${queryParams.isEmpty ? '?' : '&'}petugas=$petugas';
      }
print(queryParams);
      if (bearerToken != null) {
        var response = await http.get(
          Uri.parse("$baseUrl/pengawas/laporan$queryParams"),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        var responseData = jsonDecode(response.body);

        if (responseData['code'] == 200) {
          try {
            List<dynamic> data = responseData['data'];

            List<Laporan> laporanList =
                data.map((item) => Laporan.fromJson(item)).toList();
            return laporanList;
          } catch (e) {
            return null;
          }
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<Map<String, dynamic>> VerifikasiPengawas(
      List<Map<String, dynamic>> kegiatan,
      int id_laporan,
      String keterangan,
      String nip_pengguna) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      var response = await http.post(
        Uri.parse("$baseUrl/pengawas/verifikasi"),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_laporan': id_laporan,
          'keterangan_verifikasi': keterangan,
          'list_kegiatan': kegiatan,
          'nip_pengguna': nip_pengguna,
        }),
      );
      print(jsonEncode({
        'id_laporan': id_laporan,
        'keterangan_verifikasi': keterangan,
        'list_kegiatan': kegiatan,
        'nip_pengguna': nip_pengguna,
      }));
      var responseData = jsonDecode(response.body);
      if (responseData['code'] == 200) {
        return {'success': "${responseData['message']}"};
      } else {
        return {'error': "${responseData['message']}"};
      }
    } catch (e) {
      return {'error': "Terjadi kendala, mohon tunggu sebentar lagi !"};
    }
  }

  Future<List<Laporan>?> getVerifikasiLaporan({int? id_laporan}) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      if (bearerToken != null) {
        var response = await http.get(
          Uri.parse("$baseUrl/verifikasi/laporan/$id_laporan"),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        var responseData = jsonDecode(response.body);
        if (responseData['code'] == 200) {
          try {
            List<dynamic> data = responseData['data'];

            List<Laporan> laporanList =
                data.map((item) => Laporan.fromJson(item)).toList();
            return laporanList;
          } catch (e) {
            // throw Exception('Gagal mapping data kegiatan');
            return null;
          }
        } else {
          // throw Exception('Gagal Load Data');
          return null;
        }
      } else {
        // throw Exception('Token tidak tersedia');
        return null;
      }
    } catch (e) {
      // throw Exception('Gagal mendapatkan token');
      return null;
    }
  }

  Future<List<Kegiatan>?> getVerifikasiKegiatan(
      {int? id_verifikasi_laporan}) async {
    try {
      var bearerToken = await SessionManager.getBearerToken();

      if (bearerToken != null) {
        var response = await http.get(
          Uri.parse("$baseUrl/verifikasi/kegiatan/$id_verifikasi_laporan"),
          headers: {'Authorization': 'Bearer $bearerToken'},
        );

        var responseData = jsonDecode(response.body);
        print(responseData);

        if (responseData['code'] == 200) {
          try {
            List<dynamic> data = responseData['data'];

            List<Kegiatan> kegiatanList =
                data.map((item) => Kegiatan.fromJson(item)).toList();
            return kegiatanList;
          } catch (e) {
            // throw Exception('Gagal mapping data kegiatan');
            return null;
          }
        } else {
          // throw Exception('Gagal Load Data');
          return null;
        }
      } else {
        // throw Exception('Token tidak tersedia');
        return null;
      }
    } catch (e) {
      // throw Exception('Gagal mendapatkan token');
      return null;
    }
  }
}
