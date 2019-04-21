import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/io_client.dart';
import 'package:open_weather_api/open_weather_api.dart';
import 'dart:async';

import 'package:jaguar_resty/jaguar_resty.dart';

class FivieForecast extends StatefulWidget {
  Position _position;

  FivieForecast(Position position) {
    _position = position;
  }

  @override
  _FivieForecastState createState() => _FivieForecastState(_position);
}

class _FivieForecastState extends State<FivieForecast> {
  Position _position;
  String _OWM_API_KEY = "0a09112840d8c1ce2c6b44fef107af0a";
  static final String WAITING = "Waiting...";
  String _todayWeather = WAITING;
  String _response = '';
  List<HourlyForecast> _forecasts;
  List<String> _dailyForecasts;

  final textStyle = new TextStyle(
      fontSize: 25.0,
      color: const Color(0xFF000000),
      fontWeight: FontWeight.w200,
      fontFamily: "Roboto");

  _FivieForecastState(Position position) {
    if (position != null) {
      _position = position;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('5일 날씨'),
        ),
        body: Column(
          children: <Widget>[
            FutureBuilder(
              future: _showTodayWeather(),
              builder: (context, _response) {
                return Expanded(
                  child: ListView.builder(
                    itemCount:
                        (_dailyForecasts) != null ? _dailyForecasts.length : 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (_dailyForecasts != null) {
                        return _showDailyForecast(index);
                      }else
                        return Text(WAITING);
                    },
                  ),
                );
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
    _showTodayWeather();
  }

  Future<void> _showTodayWeather() async {
    if (_position == null) {
      return;
    }

    globalClient = IOClient();
    final api = OpenWeatherApi(_OWM_API_KEY);

    Coord coord = new Coord();
    coord.latitude = _position.latitude;
    coord.longitude = _position.longitude;

    _forecasts = (await api.hourlyForecastsByCoordinate(coord)).forecasts;

    recognizeWeather();
  }

  void recognizeWeather() {
    HourlyForecast temp;
    int k = 0;
    _dailyForecasts = new List<String>();
    for (int i = 0; i < _forecasts.length; i = 8 * k) {
      temp = _forecasts[i];
      _dailyForecasts.add(temp.conditions[0].main);

      k++;
    }
  }

  Widget _showDailyForecast(int index) {
    String str = "";

    if (index == 0) {
      str = "오늘의 날씨 : ";
      str += _dailyForecasts[index];
      return Text(
        str,
        style: textStyle,
      );
    } else {
      str = "오늘 +$index 일의 날씨 : ";
      str += _dailyForecasts[index];
      return Text(
        str,
        style: textStyle,
      );
    }
  }
}
