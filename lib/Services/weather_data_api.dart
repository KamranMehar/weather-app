
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'package:weather/Pages/home.dart';
import 'package:weather/Services/base_url.dart';
import 'package:flutter/foundation.dart';


class WeatherService {

  List<dynamic> weeklyList=[];
  List<dynamic> hourlyList=[];


Future<List<dynamic>>  getWeeklyData(double lat,double lon)async{
 // await  getLatLon();
  final response = await http.get(Uri.parse("http://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=${WeatherAPIUrl.apiKey}"));

  var data = jsonDecode(response.body);
  if (response.statusCode == 200) {
    print("Response Successful");

   List tempList=data['list'];
    weeklyList.clear();
    for(int i=0;i<tempList.length;i++){
      if((i*8)<tempList.length){
        weeklyList.add(tempList[i*8]);
      }else{
        weeklyList.add(tempList[i]);
      }
    }
    HomeScreen.cityStrm.sink.add(data['city']['name']);

    return weeklyList;
  } else {
    throw Exception();
  }
  }

  Future<List<dynamic>>  getHourlyData(double lat,double lon)async{

    final response = await http.get(Uri.parse("http://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=${WeatherAPIUrl.apiKey}"));

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print("Response Successful");
      }

      List tempList=data['list'];
      hourlyList.clear();
      for(int i=0;i<8;i++){
      hourlyList.add(tempList[i]);
      }
      return hourlyList;
    } else {
      throw Exception();
    }
  }


}