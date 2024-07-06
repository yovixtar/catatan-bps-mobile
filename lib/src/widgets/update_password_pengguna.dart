import 'package:catatan_harian_bps/src/services/session.dart';
import 'package:flutter/material.dart';
import 'package:catatan_harian_bps/src/services/api_services.dart';
import 'package:catatan_harian_bps/src/views/petugas/kegiatan_page/daftar_kegiatan_page.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';

class UpdatePasswordPenggunaModal extends StatefulWidget {
  final String? nip;

  UpdatePasswordPenggunaModal({
    required this.nip,
  });

  @override
  _UpdatePasswordPenggunaModalState createState() =>
      _UpdatePasswordPenggunaModalState();
}

class _UpdatePasswordPenggunaModalState
    extends State<UpdatePasswordPenggunaModal> {
  String? password = '';
  String? repassword = '';
  bool passwordsMatch = true;

  late TextEditingController _passwordController = TextEditingController();
  late TextEditingController _repasswordController = TextEditingController();

  bool isLoading = false;

  bool obscurePassword = true;

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
                    'Ganti Password',
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
                  if (!passwordsMatch)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text(
                        "Pastikan Password dan Re-password baru sama !",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  TextFormField(
                    controller: _passwordController,
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        if (repassword != '') {
                          passwordsMatch = password == repassword;
                        }
                      });
                    },
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      labelStyle: TextStyle(color: Colors.black54),
                      border: OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _repasswordController,
                    onChanged: (value) {
                      setState(() {
                        repassword = value;
                        passwordsMatch = password == repassword;
                      });
                    },
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Re-Password Baru',
                      labelStyle: TextStyle(color: Colors.black54),
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
                                if (passwordsMatch) {
                                  final result = await APIService().changePass(
                                      widget.nip!.toString(),
                                      password.toString());
                                  if (result.containsKey('success')) {
                                    SnackbarUtils.showSuccessSnackbar(
                                        context, result['success']);
                                    await SessionManager.clearToken();
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    Navigator.pushReplacementNamed(
                                        context, '/login');
                                  } else {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                    SnackbarUtils.showErrorSnackbar(
                                        context, result['error']);
                                  }
                                } else {
                                  passwordsMatch = false;
                                }
                              } catch (e) {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                                SnackbarUtils.showErrorSnackbar(
                                    context, "Gagal mengupdate password.");
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
