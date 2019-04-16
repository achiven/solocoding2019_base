import 'package:flutter/material.dart';
import 'todayWeather.dart';

void main() => runApp(MyApp());

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: StartPage('Hello World'));
//        home: CupertinoPage());
  }
}

class StartPage extends StatefulWidget {
  final String title;

  StartPage(this.title) : super();

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<StartPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Flutter 날씨'), // app bar title
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text('오늘의 날씨'),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TodayWeather()) );
                },
              ),
            ],
          )
        ),
      );


  }
}

