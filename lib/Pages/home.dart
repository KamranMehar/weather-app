import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/Services/base_url.dart';
import 'package:weather/Services/weather_data_api.dart';
import 'package:http/http.dart' as http;
import 'package:weather/Widgets/temperature_tile.dart';
class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController textEditingController=TextEditingController();
  WeatherService weatherService=WeatherService();
 //List tempData=[];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
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
            Expanded(
                child:FutureBuilder(
                      future: weatherService.getWeatherData(textEditingController.text.toLowerCase()),
                    builder: (context,snap){
                    if(snap.hasData){
                        List tempList=snap.data['list'];
                       // print(tempList);
                     /* for(int i=0;i<tempList.length;i++){
                        tempData.add(snap.data['list'][i]);
                      }*/

                      return ListView.builder(
                          itemCount: tempList.length,
                          itemBuilder: (context,index){
                            double temperature=((tempList[index]['main']['temp'])-273.15);
                           var time=DateFormat('h:mma').format(DateTime.fromMillisecondsSinceEpoch(tempList[index]['dt'] * 1000));
                           var day=DateFormat('EEEE').format(DateTime.fromMillisecondsSinceEpoch(tempList[index]['dt'] * 1000));
                           var date=DateFormat('ydM').format(DateTime.fromMillisecondsSinceEpoch(tempList[index]['dt'] * 1000));

                        return   TemperatureTile(temperature: temperature.toInt(),
                          date: date, time: time, day: day,);
                     /*   return ListTile(
                          title: Text("${temperature.ceil()}°C"),
                          subtitle:Text("${time}  ${date}") ,
                          trailing: Text(tempList[index]['weather'][0]['main'].toString()),
                          leading: Text(index.toString()),
                        );*/
                      });
                    }else{
                      return const Center(child: Text("Loading..."));
                    }
                }) )
        ],
      ),
    );
  }
  @override
  void initState() {
      super.initState();
  }

}
