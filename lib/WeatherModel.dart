class WeatherModel{
  String wAtmosphereMain = "--";
  String wAtmosphereDescription = "--";
  double wTemp = 0.00;
  String wLocation = "--";
  String? wIcon ;


  WeatherModel.fromJson(Map<String, dynamic> jsonData) :
      wAtmosphereMain = jsonData["weather"][0]["main"] as String,
      wAtmosphereDescription = jsonData["weather"][0]["description"] as String,
      wTemp = jsonData["main"]["temp"] as double,
      wLocation = jsonData["name"] as String,
      wIcon = jsonData["weather"][0]["icon"];
}