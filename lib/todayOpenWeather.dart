import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'dart:async';

import 'package:jaguar_resty/jaguar_resty.dart';

class TodayWeather extends StatefulWidget {
  @override
  _TodayWeatherState createState() => _TodayWeatherState();
}

class _TodayWeatherState extends State<TodayWeather> {
  Position _position;
  String _OWM_API_KEY = "0a09112840d8c1ce2c6b44fef107af0a";
  static final String WAITING = "Waiting...";
  String _todayWeather = WAITING;
  String _response = '';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('오늘의 날씨'),
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder(
              future: _showTodayWeather(),
              builder: (context, _response){
                return Text(_todayWeather);
              },
            ),
          ],
        ),
      ),
    );
  }


  @override
  void initState() {
    super.initState();
    _initPlatformState();
  }

  void _initPlatformState() {

    _getCurrentPosition();

    _showTodayWeather();
  }

  void _getCurrentPosition() async {

    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = true;
      position = await geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.bestForNavigation);
    } on Exception {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _position = position;
    });

    debugPrint('$_position');
  }


  Future<void> _showTodayWeather() async {

    if(_position == null){
      return ;
    }

    globalClient = IOClient();
    final api = OpenWeatherApi(_OWM_API_KEY);

    Coord coord = new Coord();
    coord.latitude = _position.latitude;
    coord.longitude = _position.longitude;

    _response = (await api.byCoordinate(coord)).simplified().toString();

    // example of _response
    /*{id: 7870922, name: Seaton Village, coord: {lon: -79.41, lat: 43.66},
       temp: 279.34, humidity: 93, wind: {speed: 6.7, deg: 60.0}, snow: null,
       rain: null, condition: {id: 500, main: Rain, description: light rain,
       icon: 10d}
      }*/
    debugPrint('$_response');

    recognizeWeather();
  }

  void recognizeWeather() {

    List<String> temp1 = _response.split("main: ");
    List<String> temp2 = temp1[1].split(',');
    _todayWeather = temp2[0];

    debugPrint('$_todayWeather');
//    Navigator.pop(context, _todayWeather);
  }
}
