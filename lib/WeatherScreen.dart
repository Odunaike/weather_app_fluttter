import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_fluttter/WeatherModel.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'api_string.dart';
import 'network/network_call.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  late Future<WeatherModel> weatherData;
  late String date;

  @override
  void initState() {
    NetworkHelper networkHelper = NetworkHelper(url);
    weatherData = networkHelper.fetchWeatherMap();
    initializeDateFormatting();
    date = DateFormat.yMMMMEEEEd("en").format(DateTime.now());
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: weatherData,
      builder: (context, snapshot) {

        if(snapshot.hasData){
          return Scaffold(
              body: Stack(
                children: [
                  SpecialBackGround(),
                  Center(
                      child: Container(
                        width: 330,
                        height: 700,
                        decoration: BoxDecoration(
                          //color: Colors.white.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(30)
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 7.0, sigmaY: 7.0),
                          child: Container(
                            color: Colors.white.withOpacity(0.7),
                            child: WeatherDataDisplay(
                              location: snapshot.data?.wLocation ?? "--",
                              atmosphereMain: snapshot.data?.wAtmosphereMain ?? "--",
                              atmosphereDescription: snapshot.data?.wAtmosphereDescription ?? "--",
                              temp: snapshot.data?.wTemp ?? 0.0,
                              icon: snapshot.data?.wIcon,
                              date: date,
                            ),
                          ),
                        ),
                      )
                  )
                ],
              )
          );
        }else if(snapshot.hasError){
          return Scaffold(body: Center(child: Text("loading failed")));
        }else{
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        }

      }
    );
  }
}

class SpecialBackGround extends StatelessWidget {
  const SpecialBackGround({super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Expanded(
          flex: 3,
            child: Container(
              color: Colors.white,
            ),
        ),
        Expanded(
          flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.elliptical(90, 60),
                  topRight: Radius.elliptical(90, 60)
                )
              ),
            )
        )
      ],
    );
  }
}

class WeatherDataDisplay extends StatelessWidget {
  final String location;
  final String atmosphereMain;
  final String atmosphereDescription;
  final String? icon;
  final double temp;
  final String date;
  WeatherDataDisplay({
    required this.location,
    required this.atmosphereMain,
    required this.atmosphereDescription,
    required this.temp,
    required this.icon,
    required this.date,
    super.key});

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(location, style: TextStyle(fontSize: 30, color: Colors.indigo)),
            Text(date , style: TextStyle(fontSize: 15, color: Colors.indigo),)
          ],
        ),
        Image.network(iconUrl + icon! + ".png",
          width: 300,
          height: 300,
          fit: BoxFit.fill
        ),
        Text( (temp.toInt() - 273).toString() + "°" , style: TextStyle(fontSize: 100,color: Colors.indigo)),
        Column(
            children: [
              Text(atmosphereMain, style: TextStyle(fontSize: 30, color: Colors.indigo),),
              Text(atmosphereDescription , style: TextStyle(fontSize: 18, color: Colors.indigo),)
            ]
        )
      ],
    );;
  }
}

