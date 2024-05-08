import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app_fluttter/WeatherModel.dart';

class NetworkHelper{
  String url;
  NetworkHelper(this.url);

  Future<WeatherModel> fetchWeatherMap() async{
    http.Response response = await http.get(Uri.parse(url));
    if(response.statusCode == 200){
      return WeatherModel.fromJson(jsonDecode(response.body));
    }else{
      throw Exception("Failed to load album");
    }
  }

}