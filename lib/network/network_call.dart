import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app_fluttter/WeatherModel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app_fluttter/api_string.dart';

class NetworkHelper{
  //removed the old method here since I didn't a String object variable

  //changed name of this function so there can be two functions for location and geoLocation
  Future<WeatherModel> fetchWeatherMapByGeo() async{
    //get longitude and latitude of user current location
    await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition();
    String lon = position.longitude.toString();
    String lat = position.latitude.toString();
    String geoLocationUrl = "https://api.openweathermap.org/data/2.5/weather?lat=$lat&lon=$lon&appid=$openweather_api_key";
    http.Response response = await http.get(Uri.parse(geoLocationUrl));
    if(response.statusCode == 200){
      return WeatherModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load album");
    }
  }
  Future<WeatherModel> fetchWeatherMapByLoc(String location) async{
    String geoLocationUrl = "https://api.openweathermap.org/data/2.5/weather?q=$location&appid=$openweather_api_key";
    http.Response response = await http.get(Uri.parse(geoLocationUrl));
    if(response.statusCode == 200){
      return WeatherModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load album");
    }
  }

}