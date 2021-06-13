import 'package:Weather/geo_locator/geolocator_service.dart';
import 'package:Weather/models/city.dart';
import 'package:Weather/models/weather.dart';
import 'package:Weather/utils/utilities.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import '../color_constants.dart';
import 'home.dart';

class WeatherForecastPage extends StatefulWidget {
  WeatherForecastPage({Key key}) : super(key: key);

  @override
  _WeatherForecastState createState() => _WeatherForecastState();
}

class _WeatherForecastState extends State<WeatherForecastPage> {
  var scaffoldKey = GlobalKey<ScaffoldState>();
  HomeBloc homeBloc;
  List<City> cityList;
  Weather weather;
  List<Weather> weatherList;
  bool showDropDownText = true;

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
    homeBloc.add(GetCities());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeStates>(
        listener: (context, state) {

          if(state is CityLoaded){
            cityList = state.city;
            homeBloc.add(GetWeatherList(cityName: cityList.elementAt(0).city, lat: cityList.elementAt(0).lat, long: cityList.elementAt(0).lng));
          }

          if(state is WeatherLoaded){
            showDropDownText = true;
            weather = state.weather;
            weatherList = state.weatherList;
          }

          if(state is WeatherLoadedFromGeo){
            showDropDownText = false;
            weather = state.weather;
            weatherList = state.weatherList;
          }

          if(state is FavCityInserted){
            Utilities.alertMessage(context, 'Favorite City Successfully inserted');
          }

          if(state is NetworkErrorState){
            debugPrint('statetemp'+state.error.toString());
          }
        },
        child: BlocBuilder<HomeBloc, HomeStates>(builder: (context, state) {
          return Scaffold(
            key: scaffoldKey,
            backgroundColor: Color(ColorConstants.lightPink),
              body: Container(
                child: weather != null ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: DropdownButtonFormField(
                            value: showDropDownText ? weather.cityName : null,
                            onChanged: (value) {
                              homeBloc.add(GetWeatherList(cityName: value));
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            items: cityList
                                .map((c) => DropdownMenuItem(
                                value: c.city, child: Text(c.city)))
                                .toList(),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.my_location),
                          onPressed: ()async{
                            final GeolocatorService instanceGeolocation =
                            new GeolocatorService();
                            try {
                              final getCurrentLocation = await instanceGeolocation.determinePosition();
                              final lat = getCurrentLocation.latitude;
                              final long = getCurrentLocation.longitude;
                              homeBloc.add(GetGeoWeatherList(lat: lat, long: long));
                            } catch (err) {
                              await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                  title: Text("Cannot access your location"),
                                  content: Text(err.toString()),
                                  actions: [
                                    FlatButton(
                                      onPressed: () {
                                        instanceGeolocation.openAppSettings();
                                      },
                                      child: Text("Open location setting"),
                                    ),
                                  ]),
                            );
                          }
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            weather.cityName,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "${weather.main.temp.toString()}°C",
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "${weather.description.toString()}",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: weatherList.length,
                              itemBuilder: (context, index) {
                                final weather = weatherList[index];

                                return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        children: [
                                          Text(
                                            "${weather.description}",
                                            style: TextStyle(fontSize: 30),
                                          ),
                                          SizedBox(height: 10),
                                          Text(
                                            "${weather.main.temp}°C",
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          Text(
                                            weather.formatDate,
                                            style: TextStyle(fontSize: 20),
                                          ),
                                          SizedBox(height: 10),
                                          Image.network("http://openweathermap.org/img/w/${weather.weatherIcon}.png", width: 90),
                                        ],
                                      ),
                                    ));
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                  ],
                ):Center(
                  child: Text('Loading...'),
                ),
              ),
            floatingActionButton: weather != null ? SimpleTooltip(
              ballonPadding: EdgeInsets.all(1),
              borderColor: Color(ColorConstants.toolTip),
              backgroundColor: Color(ColorConstants.toolTip),
              animationDuration: Duration(seconds: 1),
              show: true,
              tooltipDirection: TooltipDirection.left,
              child: FloatingActionButton(
                backgroundColor: Color(ColorConstants.babyPink),
                child: Icon(
                  Icons.add,
                  size: 40.0,
                ),
                onPressed: () => plusButtonClicked(),
              ),
              content: Text(
                'Click here to save in Favorite',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  decoration: TextDecoration.none,
                ),
              ),
            ) : Container(),
          );
        }));
  }

  plusButtonClicked() {
    homeBloc.add(InsertFavoriteCity(data: {
      "city": weather.cityName,
      "weather_icon": weather.weatherIcon,
      "description": weather.description,
      "temp": weather.main.temp,
      "date": weather.date
    }));
  }
}
