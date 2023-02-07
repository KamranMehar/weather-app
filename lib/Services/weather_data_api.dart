
import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart'as http;
import 'package:weather/Pages/home.dart';
import 'package:weather/Services/base_url.dart';
import 'package:flutter/foundation.dart';
import 'package:weather/util/custom_toast.dart';


class WeatherService {

  double? lat;
  double? lon;
  List<dynamic> weeklyList=[];
  List<dynamic> hourlyList=[];

 /* Future<dynamic> getWeatherData(String city)async {
  final LatLongResponse = await http.get(Uri.parse(
      "http://api.openweathermap.org/geo/1.0/direct?q=${city}&limit=5&appid=${WeatherAPIUrl
          .apiKey}"));

  var LatLondata = jsonDecode(LatLongResponse.body);

  if (LatLongResponse.statusCode == 200) {
    print("lat lon getted");
      lat=LatLondata![0]['lat'];
      lon=LatLondata![0]['lon'];
      print(lat);
      print(lon);
    return  getData(lat!,lon!);
  } else {
    throw Exception();
  }
}*/

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
      print("Response Successful");

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




  getLatLon(){
  Future<Position> locationData = _determinePosition();
  locationData.then((value) {
    if (kDebugMode) {
      print("value $value");
    }
    lat = value.latitude;
    lon = value.longitude;

  }).catchError((error) {
    if (kDebugMode) {
      print("Error $error");
    }
  });
}

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      UtilToast.showToast("Turn on your Location !");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        UtilToast.showToast("Location permissions are denied");
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      UtilToast.showToast("Location Permission is permanently disabled !");
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

}