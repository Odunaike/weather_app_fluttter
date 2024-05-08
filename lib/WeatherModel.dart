class WeatherModel{
  String wAtmosphere = "--";
  double wTemp = 0.00;
  String wLocation = "--";

  WeatherModel();

  WeatherModel.fromJson(Map<String, dynamic> jsonData) :
      wAtmosphere = jsonData["weather"][0]["description"] as String,
      wTemp = jsonData["main"]["temp"] as double,
      wLocation = jsonData["name"] as String;
}