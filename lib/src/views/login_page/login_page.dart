import 'package:catatan_harian_bps/src/providers/auth_providers.dart';
import 'package:catatan_harian_bps/src/services/session.dart';
import 'package:catatan_harian_bps/src/views/utils/snackbar_utils.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _loginMessage = '';
  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    // checkTokenAndNavigate();
  }

  Future<void> checkTokenAndNavigate() async {
    if (await SessionManager.hasToken()) {
      String? tokenData = await SessionManager.getBearerToken();
      if (tokenData != null) {
        Map<String, dynamic> token = JwtDecoder.decode(tokenData);
        if (token['role'] == 'pengawas') {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/pengawas-home');
        } else {
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/petugas-home');
        }
      } else {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      Navigator.pop(context);
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  void _login() {
    setState(() {
      _loginMessage = 'Login Gagal. NIP atau Password salah.';
    });
  }

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    handleLogin() async {
      setState(() {
        isLoading = true;
      });

      if (await authProvider.login(
        nip: _nipController.text,
        password: _passwordController.text,
      )) {
        if (await SessionManager.hasToken()) {
          Map<String, dynamic>? getData = await SessionManager.getData();
          if (getData != null) {
            if (getData['role'] == 'pengawas') {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/pengawas-home');
            } else {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/petugas-home');
            }
          } else {
            SnackbarUtils.showErrorSnackbar(context, "Data tidak ada");
          }
        } else {
          SnackbarUtils.showErrorSnackbar(context, "Token tidak ada");
        }
      } else {
        setState(() {
          _loginMessage = 'NIP atau password anda masukan salah.';
          SnackbarUtils.showErrorSnackbar(context, _loginMessage);
        });
      }

      setState(() {
        isLoading = false;
      });
    }

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Logo
                Image.asset('assets/images/MyLogo.png', height: 100),
                SizedBox(height: 30),
                // Form Login
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      // Text "Selamat Datang"
                      Text(
                        'Selamat Datang',
                        style: Theme.of(context)
                            .textTheme
                            .headline6
                            ?.copyWith(fontSize: 24),
                      ),
                      SizedBox(height: 20),
                      // NIP TextField
                      _buildTextField(
                        _nipController,
                        'NIP',
                        Icons.person,
                        isNumeric: true,
                      ),
                      SizedBox(height: 10),
                      // Password TextField
                      _buildTextField(
                        _passwordController,
                        'Password',
                        Icons.lock,
                        isPassword: true,
                      ),
                      SizedBox(height: 20),
                      // Login Button
                      ElevatedButton(
                        child: isLoading
                            ? CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              )
                            : Text('LOGIN'),
                        onPressed: isLoading ? null : handleLogin,
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      // Error Message
                      _loginMessage.isNotEmpty
                          ? Text(
                              _loginMessage,
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, IconData icon,
      {bool isPassword = false, bool isNumeric = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        suffixIcon: (isPassword)
            ? IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              )
            : null,
      ),
      obscureText: (isPassword) ? obscurePassword : false,
      keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
    );
  }
}
