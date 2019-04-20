import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'dart:async';

import 'package:jaguar_resty/jaguar_resty.dart';

class TodayWeather {
  Position position;
  String todayWeather = WAITING;
  String response = "";

  String _OWM_API_KEY = "0a09112840d8c1ce2c6b44fef107af0a";
  static final String WAITING = "Waiting...";
  TodayWeather instance;
  
  TodayWeather getInstance(){
    if(instance == null){
      instance = new TodayWeather();

      _getCurrentPosition();

      _getWeather();
    }
    return instance;
  }


  void _getCurrentPosition() async {
    Position pos;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      pos = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on Exception {
      pos = null;
    }

    position = pos;

    debugPrint('$position');
  }

  Future<void> _getWeather() async {
    if (position == null) {
      return;
    }

    globalClient = IOClient();
    final api = OpenWeatherApi(_OWM_API_KEY);

    Coord coord = new Coord();
    coord.latitude = position.latitude;
    coord.longitude = position.longitude;

    response = (await api.byCoordinate(coord)).simplified().toString();

    // example of _response
    /*{id: 7870922, name: Seaton Village, coord: {lon: -79.41, lat: 43.66},
       temp: 279.34, humidity: 93, wind: {speed: 6.7, deg: 60.0}, snow: null,
       rain: null, condition: {id: 500, main: Rain, description: light rain,
       icon: 10d}
      }*/
    debugPrint('$response');

    recognizeWeather();
  }

  void recognizeWeather() {

    if(0 ==response.compareTo("")){
      return ;
    }

    List<String> temp1 = response.split("main: ");
    List<String> temp2 = temp1[1].split(',');
    todayWeather = temp2[0];

    debugPrint('$todayWeather');
  }


}
