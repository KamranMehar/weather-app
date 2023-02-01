import 'package:flutter/material.dart';
import 'package:weather/ModelClasses/weather_info.dart';
import 'package:weather/Services/weather_data_api.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController=TextEditingController();
  WeatherService weatherService=WeatherService();
  double? lat;
  double? lon;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Weather"),
        centerTitle: true,
      ),
      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
            child: TextFormField(
              controller: textEditingController,
              onChanged: (v){
                setState(() {});
              },
            ),
          ),

          Expanded(child: FutureBuilder(
              future: weatherService.getWeatherData(textEditingController.text.toLowerCase()),
              builder: (context,AsyncSnapshot<WeatherInfo?> snap){
                if(snap.hasData) {
                   lat=snap.data!.coord!.lat;
                  lon=snap.data!.coord!.lon;

                  var temperature= ((snap.data!.main!.temp)!-273.15).ceil();
                  var feelsLike= ((snap.data!.main!.feelsLike)!-273.15).ceil();

                  return Column(
                    children: [
                      Text("Temperature: ${temperature} C\°" ?? "",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold),),
                      Text("feels like: ${feelsLike} C\°" ?? "",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
                      Text("Sky: ${snap.data!.weather![0].description}" ?? "",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
                      Text("Humidity: ${snap.data!.main!.humidity.toString()}" ?? "",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
                      Text("Country: ${snap.data!.sys!.country.toString()}" ?? "",style: TextStyle(fontSize: 21,fontWeight: FontWeight.bold)),
                      SizedBox(height: 50,),
                    ],
                  );
                }else{
                  return Text("Loading..");
                }
          })),
        ],
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
}
