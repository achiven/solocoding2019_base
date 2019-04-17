import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:open_weather_api/open_weather_api.dart';

import 'package:jaguar_resty/jaguar_resty.dart';

class TodayWeather extends StatefulWidget {
  @override
  _TodayWeatherState createState() => _TodayWeatherState();
}

class _TodayWeatherState extends State<TodayWeather> {
  Position _position;
  String _OWM_API_KEY = "0a09112840d8c1ce2c6b44fef107af0a";
  String _todayWeather = 'waiting...';
  String _response = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('오늘의 날씨'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(_todayWeather),
              onPressed:() {
                recognizeWeather(_response);
              },
            )
          ],
        )
    );
  }

  Future<String> _showTodayWeather() async{
    globalClient = IOClient();
    final api = OpenWeatherApi(_OWM_API_KEY);

    Coord coord = new Coord();
    coord.latitude = 37.251487;
    coord.longitude = 127.071351;

    _response = (await api.byCoordinate(coord) ).simplified().toString();
    print(_response);

    return _response;
  }

  @override
  void initState() {
    super.initState();
    _initPlatformState();

  }




  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initPlatformState() async {
//    Position position;
//    // Platform messages may fail, so we use a try/catch PlatformException.
//    try {
//      final Geolocator geolocator = Geolocator()
//        ..forceAndroidLocationManager = true;
//      position = await geolocator.getCurrentPosition(
//          desiredAccuracy: LocationAccuracy.bestForNavigation);
//    } on Exception {
//      position = null;
//    }
//
//    // If the widget was removed from the tree while the asynchronous platform
//    // message was in flight, we want to discard the reply rather than calling
//    // setState to update our non-existent appearance.
//    if (!mounted) {
//      return;
//    }
//
//    setState(() {
//      _position = position;
//    });
    _showTodayWeather();
  }

  String recognizeWeather(String response) {
    final NO_RAIN = 'rain: null';
    final NO_SNOW = 'snow: null';

    String _ret = 'waiting...';

    if(response.contains(NO_RAIN)
        && response.contains(NO_SNOW)){
      _ret = 'Sunny';
    } else if(response.contains(NO_SNOW)){
      _ret = 'Rainy';
    } else if(response.contains(NO_RAIN)){
      _ret = 'Snowy';
    }
    _todayWeather = _ret;

    return _ret;

  }


}