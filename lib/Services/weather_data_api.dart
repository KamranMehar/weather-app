
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:weather/Services/base_url.dart';

class WeatherService {

  double? lat;
  double? lon;

Future<dynamic> getWeatherData(String city)async {
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
}

Future<dynamic>  getData(double lat,double lon)async{
    final response = await http.get(Uri.parse("http://api.openweathermap.org/data/2.5/forecast?lat=${lat}&lon=${lon}&appid=0adc9508600058dfc5cce552a10735e6"));

    var data = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print("Successful");
     // print(data);
      return data;
    } else {
      print("Failed");
    }
  }


}