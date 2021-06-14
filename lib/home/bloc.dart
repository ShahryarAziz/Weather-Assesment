import 'package:Weather/helpers/db_helper.dart';
import 'package:Weather/models/weather.dart';
import 'package:Weather/repo/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class HomeBloc extends Bloc<HomeEvents , HomeStates> {
  final WeatherRepository networkRepository;
  final DBHelper dbHelper;
  int count = 0;

  HomeBloc({@required this.networkRepository, this.dbHelper}) : assert (networkRepository != null);

  @override
  HomeStates get initialState => HomeInitialState();

  @override
  Stream<HomeStates> mapEventToState(HomeEvents event) async* {
    count = count + 1;
    final String _tableName = "favorite_city";
    if (event is GetFavoriteCities) {
      var response = await DBHelper.getData(_tableName);
      if (response.length > 0) {
        yield FavoriteSuccessState(favoriteSuccessStateResponseData: response);
      }
    }

    if (event is GetWeatherList) {
      try {
        Weather getCurrentWeather = await networkRepository.fetchWeather(
          cityName: event.cityName,
          lat: event.lat,
          long: event.long,
        );

        final List<Weather> getForecastWeather =
        await networkRepository.fetchFiveDaysForecastWeather(
          cityName: event.cityName,
          lat: event.lat,
          long: event.long,
        );
        yield WeatherLoaded(weather: getCurrentWeather, weatherList: getForecastWeather,
        );
      } on FormatException
      catch (err) {
        yield WeatherError(err);
      }
    }

    if (event is GetGeoWeatherList) {
      try {
        Weather getCurrentWeather = await networkRepository.fetchWeather(
          cityName: event.cityName,
          lat: event.lat,
          long: event.long,
        );

        final List<Weather> getForecastWeather =
        await networkRepository.fetchFiveDaysForecastWeather(
          cityName: event.cityName,
          lat: event.lat,
          long: event.long,
        );
        yield WeatherLoadedFromGeo(weather: getCurrentWeather, weatherList: getForecastWeather,
        );
      } on FormatException
      catch (err) {
        yield WeatherError(err);
      }
    }

    if (event is GetCities) {
      try {
        final city = await networkRepository.fetchCity();
        yield CityLoaded(city);
      } on FormatException
      catch (err) {
        CityError(err);
      }
    }

    if(event is InsertFavoriteCity){
      await DBHelper.insert(_tableName, event.data);
      yield FavCityInserted();
    }

  }
}