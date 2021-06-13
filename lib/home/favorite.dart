import 'dart:convert';

import 'package:Weather/models/weather.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../color_constants.dart';
import 'home.dart';

class FavoritePage extends StatefulWidget {
  FavoritePage({Key key}) : super(key: key);

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<FavoritePage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc;
  var weatherList;

  @override
  void initState() {
    super.initState();
  }

  @override
  didChangeDependencies(){
    super.didChangeDependencies();
    init();
  }

  init()async{
    homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.add(GetFavoriteCities());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeStates>(
        listener: (context, state) {
          if(state is FavoriteSuccessState){
            final weather = state.favoriteSuccessStateResponseData.map(
                  (e) => Weather(
                date: e["date"],
                cityName: e["city"],
                description: e["description"],
                weatherIcon: e["weather_icon"],
                main: WeatherMain(temp: e["temp"]),
              ),
            ).toList();
            weatherList = weather.reversed.toList();
          }
          if(state is NetworkErrorState){
          }
        },
        child: BlocBuilder<HomeBloc, HomeStates>(builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.lightPink),
              body: weatherList != null ? Container(
                child: ListView.builder(
                  itemCount: weatherList.length,
                  itemBuilder: (context, index) {
                    final weather = weatherList[index];
                    return Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Card(
                        child: ListTile(
                          title: Text(weather.cityName),
                          leading: Image.network("http://openweathermap.org/img/w/${weather.weatherIcon}.png"),
                          subtitle: Text(weather.description),
                          trailing: Text("${weather.main.temp}°C"),
                        ),
                      ),
                    );
                  },
                ),
              ) : Center(
                child: Text('No Fav City'),
              ),
          );
        }));
  }
}
