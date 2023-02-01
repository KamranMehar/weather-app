
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:weather/ModelClasses/weather_info.dart';
import 'package:weather/Services/base_url.dart';

class WeatherService {


Future<WeatherInfo?> getWeatherData(String city)async{

  final response=await http.get(Uri.parse("https://api.openweathermap.org/data/2.5/weather?q=${city}&appid=${WeatherAPIUrl.apiKey}"));
  
  var data=jsonDecode(response.body);
  if(response.statusCode==200){
    print("Successful");
    WeatherInfo weatherInfo=WeatherInfo.fromJson(data);
    return weatherInfo;

  }else{
   throw Exception();
  }
  
}
}