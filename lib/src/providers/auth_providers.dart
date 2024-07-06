import 'package:catatan_harian_bps/src/models/pengguna.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  Pengguna? _user;

  Pengguna get user => _user!;

  set user(Pengguna _user) {
    _user = user;
    notifyListeners();
  }

  Future<bool> login({
    String? nip,
    String? password,
  }) async {
    try {
      Pengguna? user = await APIService().login(nip: nip, password: password);

      _user = user;

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
