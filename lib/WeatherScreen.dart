import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:weather_app_fluttter/WeatherModel.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'api_string.dart';
import 'network/network_call.dart';

late Future<WeatherModel> weatherData;
late NetworkHelper networkHelper;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});
  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  late String date;

  @override
  void initState() {
    networkHelper = NetworkHelper();
    weatherData = networkHelper.fetchWeatherMapByGeo();
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
                        height: 750,
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
                              requestByLocation: (value){
                                setState(() {
                                  weatherData = networkHelper.fetchWeatherMapByLoc(value);
                                });
                              },
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

//I had to dlete the old widget to make it stateful as it is now since we would want to change the state of weatherModel when a search query is made
class WeatherDataDisplay extends StatefulWidget {
  final String location;
  final String atmosphereMain;
  final String atmosphereDescription;
  final String? icon;
  final double temp;
  final String date;
  void Function(String) requestByLocation;
  WeatherDataDisplay({
    required this.location,
    required this.atmosphereMain,
    required this.atmosphereDescription,
    required this.temp,
    required this.icon,
    required this.date,
    required this.requestByLocation,
    super.key});

  @override
  State<WeatherDataDisplay> createState() => _WeatherDataDisplayState();
}

class _WeatherDataDisplayState extends State<WeatherDataDisplay> {

  String location = "";

  @override
  Widget build(BuildContext context) {
    return  Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5), // shadow color
                spreadRadius: 2, // spread radius
                blurRadius: 10, // blur radius
                offset: Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: Container(
            width: 300,
            child: TextField(
              decoration: InputDecoration(
                  hintText: "Search by location",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: (){
                      widget.requestByLocation(location);
                      location = "";
                    },
                  )
              ),
              onChanged: (value){
                location = value;
              },
            ),
          ),
        ),
        Column(
          children: [
            Text(widget.location, style: TextStyle(fontSize: 30, color: Colors.indigo)),
            Text(widget.date , style: TextStyle(fontSize: 15, color: Colors.indigo),)
          ],
        ),
        Image.network(iconUrl + widget.icon! + ".png",
            width: 300,
            height: 300,
            fit: BoxFit.fill
        ),
        Text( (widget.temp.toInt() - 273).toString() + "°" , style: TextStyle(fontSize: 100,color: Colors.indigo)),
        Column(
            children: [
              Text(widget.atmosphereMain, style: TextStyle(fontSize: 30, color: Colors.indigo),),
              Text(widget.atmosphereDescription , style: TextStyle(fontSize: 18, color: Colors.indigo),)
            ]
        )
      ],
    );;
  }
}

