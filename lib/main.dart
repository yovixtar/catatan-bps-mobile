import 'package:catatan_harian_bps/src/providers/auth_providers.dart';
import 'package:catatan_harian_bps/src/views/login_page/login_page.dart';
import 'package:catatan_harian_bps/src/views/pengawas/home_page.dart';
import 'package:catatan_harian_bps/src/views/petugas/home_page.dart';
import 'package:catatan_harian_bps/src/views/splash/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Catatan Harian BPS',
        localizationsDelegates: [
          GlobalWidgetsLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          MonthYearPickerLocalizations.delegate,
        ],
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            headline6: TextStyle(color: Colors.blue),
            bodyText2: TextStyle(color: Colors.black87),
          ),
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blue),
            ),
            labelStyle: TextStyle(color: Colors.blue),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            textTheme: ButtonTextTheme.primary,
          ),
        ),
        initialRoute: '/intro',
        routes: {
          '/': (context) => LoginPage(),
          '/intro': (context) => SplashScreen(),
          '/login': (context) => LoginPage(),
          '/petugas-home': (context) => HomePetugas(),
          '/pengawas-home': (context) => HomePengawas(),
        },
        locale: Locale('id', 'ID'),
      ),
    );
  }
}
