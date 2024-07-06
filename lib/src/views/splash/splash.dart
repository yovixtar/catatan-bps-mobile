import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

import '../../services/session.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var durtion = Duration(seconds: 5);
    return new Timer(durtion, loginRoute);
  }

  loginRoute() async {
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

  @override
  Widget build(BuildContext context) {
    return initWidget();
  }

  Widget initWidget() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
            child: Image.asset(
          "assets/images/MyLogo.png",
          scale: 4,
        )),
      ),
    );
  }
}
