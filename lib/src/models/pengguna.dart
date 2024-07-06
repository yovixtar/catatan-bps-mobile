import 'package:flutter/src/widgets/container.dart';

class Pengguna {
  String? nama;
  String? nip;
  String? password;
  String? role;
  String? token;
  bool? active;

  Pengguna({
    this.nip,
    this.password,
    this.nama,
    this.role,
    this.token,
    this.active,
  });

  Pengguna.fromJson(Map<String, dynamic> json) {
    nama = json['nama'];
    nip = json['nip'];
    password = json['password'];
    role = json['role'];
    token = json['token'];
    active = json['active'];
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'nip': nip,
      'password': password,
      'role': role,
      'token': token,
      'active': active,
    };
  }

  map(Container Function(dynamic tes) param0) {}
}
