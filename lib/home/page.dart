import 'dart:convert';
import 'package:Weather/home/favorite.dart';
import 'package:Weather/home/weather_forecast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../color_constants.dart';
import 'home.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc;
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeStates>(
        listener: (context, state) {

        },
        child: BlocBuilder<HomeBloc, HomeStates>(builder: (context, state) {
          return DefaultTabController(
            length: 2,
            child: Scaffold(
                key: scaffoldKey,
                backgroundColor: Color(ColorConstants.lightPink),
                appBar: AppBar(
                  title: Text('Assessment', style: TextStyle(color: Colors.black),),
                  centerTitle: true,
                  backgroundColor: Color(ColorConstants.babyPink),
                  bottom: TabBar(
                    indicatorColor: Colors.white,
                    tabs: [
                      Tab(text: 'Weather Forecast'),
                      Tab(text: 'Favorite'),
                    ],
                  ),
                ),
                body: SafeArea(
                  child: TabBarView(
                    children: [
                      WeatherForecastPage(),
                      FavoritePage(),
                    ],
                  )
                )),
          );
        }));
  }
}
