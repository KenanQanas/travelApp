import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fourth_year/my_flights.dart';
import 'package:fourth_year/network/response/dio_helpers.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'log_in_state.dart';
import 'package:fourth_year/profile_state.dart';
import 'package:fourth_year/sign_up_state.dart';

// @dart=2.9
//for certification to get "from" and "to" countries api
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


void main() async {
  DioHelpers.init();

  //for certification to get "from" and "to" countries api
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences _data = await SharedPreferences.getInstance();
  var email = _data.getString('e');
  var password = _data.getString('p');
  runApp(
    OKToast(
      child: MaterialApp(
        routes: {
          'log_in': (ctx) {
            return Log_In();
          },
          'sign_up': (ctx) {
            return const sign_up();
          },
          'profile': (ctx) {
            return Profile();
          },

        },
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(
            centerTitle: true,
          ),
          primarySwatch: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        home: (email != null && password != null) ? Profile() : const sign_up(),

      ),
    ),
  );
}


