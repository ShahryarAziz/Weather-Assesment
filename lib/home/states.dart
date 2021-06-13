import 'package:Weather/models/city.dart';
import 'package:Weather/models/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'home.dart';

class HomeStates extends Equatable{
  @override
  List<Object> get props => [];
}

class HomeInitialState extends HomeStates {}

class FavoriteSuccessState extends HomeStates {
  final favoriteSuccessStateResponseData;
  FavoriteSuccessState({@required this.favoriteSuccessStateResponseData});

  @override
  List<Object> get props => [favoriteSuccessStateResponseData];

  @override
  String toString() => 'FavoriteSuccessState';
}

class WeatherLoaded extends HomeStates {
  final Weather weather;
  final List<Weather> weatherList;

  WeatherLoaded({this.weather, this.weatherList});

  @override
  List<Object> get props => [weather, weatherList];

}

class WeatherLoadedFromGeo extends HomeStates {
  final Weather weather;
  final List<Weather> weatherList;

  WeatherLoadedFromGeo({this.weather, this.weatherList});

  @override
  List<Object> get props => [weather, weatherList];

}

class WeatherError extends HomeStates {
  final FormatException error;

   WeatherError(this.error);

  @override
  List<Object> get props => [error];
}

class CityLoaded extends HomeStates {
  final List<City> city;
  CityLoaded(this.city);

  @override
  List<Object> get props => [city,];
}

class FavCityInserted extends HomeStates {
  @override
  List<Object> get props => [];
}

class CityError extends HomeStates {
  final FormatException error;

  CityError(this.error);

  @override
  List<Object> get props => [error];
}


class NetworkErrorState extends HomeStates {
  String error;
  int count;
  NetworkErrorState({@required this.error, @required this.count});

  @override
  List<Object> get props => [error, count];
}