import 'package:flutter/material.dart';
import 'package:weather_app_fluttter/WeatherModel.dart';
import 'package:weather_app_fluttter/api_string.dart';
import 'package:weather_app_fluttter/network/network_call.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeScreen()
    );
  }
}
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<WeatherModel> weatherData;

  @override
  void initState() {
    NetworkHelper networkHelper = NetworkHelper(url);
    weatherData = networkHelper.fetchWeatherMap();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: weatherData,
        builder: (context, snapshot){
          if(snapshot.hasData){
            return Scaffold(body: Center(child: Text(snapshot.data!.wAtmosphere)));
          }else if(snapshot.hasError){
            return Scaffold(body: Center(child: Text("loading failed")));
          }else{
            return Scaffold(body: Center(child: CircularProgressIndicator()));
          }
        }
    );
  }

}


