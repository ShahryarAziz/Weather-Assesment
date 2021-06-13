import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

abstract class HomeEvents extends Equatable{
  HomeEvents([List props = const []]);
}

class GetFavoriteCities extends HomeEvents {

  @override
  List<Object> get props => [];

  String toString() => 'GetFavoriteCities';
}

class GetCities extends HomeEvents {

  @override
  List<Object> get props => [];

  String toString() => 'GetCities';
}

class GetWeatherList extends HomeEvents {
  String cityName;
  double lat;
  double long;
  GetWeatherList({@required this.cityName, @required this.lat, @required this.long});
  @override
  List<Object> get props => [cityName, lat, long];
  String toString() => 'GetWeatherList';
}

class GetGeoWeatherList extends HomeEvents {
  String cityName;
  double lat;
  double long;
  GetGeoWeatherList({@required this.cityName, @required this.lat, @required this.long});
  @override
  List<Object> get props => [cityName, lat, long];
  String toString() => 'GetGeoWeatherList';
}

class InsertFavoriteCity extends HomeEvents {
  Map<String, Object> data;

  InsertFavoriteCity({@required this.data});

  @override
  List<Object> get props => [data];

  String toString() => 'InsertFavoriteCity';
}