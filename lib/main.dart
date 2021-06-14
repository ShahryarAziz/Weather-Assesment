import 'package:Weather/helpers/db_helper.dart';
import 'package:Weather/repo/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'color_constants.dart';
import 'home/bloc.dart';
import 'home/page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.white,
          canvasColor: Color(ColorConstants.babyPink),
          primaryIconTheme: IconThemeData(color: Colors.white),
          primaryTextTheme: TextTheme(
              title: TextStyle(color: Colors.white, fontFamily: 'Futura')),
          textTheme: TextTheme(title: TextStyle(color: Colors.white))),
      home: BlocProvider<HomeBloc>(
        create: (context) {
          return HomeBloc(networkRepository: WeatherRepository(),  dbHelper: DBHelper() );
        },
        child: HomePage(),
      ),
    );
  }
}