import 'dart:async';
import 'dart:ui';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:weather/Pages/weely_list.dart';
import 'package:weather/Services/weather_data_api.dart';
import 'package:weather/Widgets/daily_tile.dart';
import 'package:weather/Widgets/hourly_tile.dart';
import 'package:weather/util/custom_toast.dart';

class HomeScreen extends StatefulWidget {
  static StreamController<String> cityStrm = StreamController<String>.broadcast();
  double lat;
  double lon;
   HomeScreen({Key? key,required this.lat,required this.lon}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static StreamController<String> humidityStrm = StreamController<String>.broadcast();
  static StreamController<String> windStrm = StreamController<String>.broadcast();
  static StreamController<String> airPressureStrm = StreamController<String>.broadcast();
  static StreamController<String> visibilityStrm = StreamController<String>.broadcast();

  static StreamController<String> timeStrm = StreamController<String>.broadcast();

  WeatherService weatherService = WeatherService();
 // String cityName = 'Weather';
  String time = '';

 // int _index = 0;
  List weeklyList = [];
  List hourlyList=[];

  @override
  Widget build(BuildContext context) {
    print("build");
   return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            Color(0xff4B3EAE),
            Colors.white,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 50.0, sigmaY: 50.0),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            systemOverlayStyle: const SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness: Brightness.dark,
              statusBarBrightness:
              Brightness.dark, //or set color with: Color(0xFF0000FF)
            ),
            automaticallyImplyLeading: false,
            centerTitle: true,
            title:  Column(children: [
                StreamBuilder(
                  stream: HomeScreen.cityStrm.stream,
                  builder: (context,snap) {
                    return Text(snap.data??"",style: const TextStyle(fontSize: 21,color: Colors.black,fontWeight: FontWeight.bold),);
                  }
                ),
                StreamBuilder(
                  stream: timeStrm.stream,
                  builder: (context,snap) {
                    return Text(snap.data??"",style: const TextStyle(fontSize: 18,color: Colors.black,),);
                  }
                ),
              ],
            ),
          ),
          backgroundColor: Colors.white.withOpacity(0.5),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                   SizedBox(
                      height: MediaQuery.of(context).size.height *4/12,
                      child:
                  FutureBuilder(
                      future:weatherService.getWeeklyData(widget.lat,widget.lon),
                      builder: (context, snap) {
                        if (snap.hasData) {
                        weeklyList = snap.data!;
                          return CarouselSlider.builder(
                              itemCount: (weeklyList.length)~/8,
                              itemBuilder: (context, index, realIndex) {

                                double temperature = ((weeklyList[index]['main']['temp']) - 273.15);
                                var date = DateTime.fromMillisecondsSinceEpoch(weeklyList[index]['dt'] * 1000);
                                time = DateFormat('h:mma').format(date);
                                var day = DateFormat('EEEE').format(date);
                                var dateDay = DateFormat('d').format(date);
                                var dateMonth = DateFormat('LLL').format(date);
                                var dateYear = DateFormat('y').format(date);


                                humidityStrm.sink.add("${weeklyList[index]['main']['humidity']}%");
                                windStrm.sink.add("${weeklyList[index]['wind']['speed']}m/sec");
                                airPressureStrm.sink.add("${weeklyList[index]['main']['pressure']}hPa");
                                visibilityStrm.sink.add("${weeklyList[index]['visibility'] / 1000}km");
                                timeStrm.sink.add(time);

                                return DailyTile(
                                  temperature: temperature.toInt(),
                                  dateDay: dateDay,
                                  day: day,
                                  dateMonth: dateMonth,
                                  dateYear: dateYear,
                                  weatherStatus: weeklyList[index]['weather'][0]['description'],
                                  icon: weeklyList[index]['weather'][0]['icon'],
                                );
                              },
                              options: CarouselOptions(
                                scrollPhysics:
                                const BouncingScrollPhysics(),
                                height: MediaQuery.of(context).size.height * 4 / 12,
                                viewportFraction: 0.7,
                                aspectRatio: 16 / 16,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                reverse: false,
                                autoPlay: false,
                                enlargeCenterPage: false,
                                onPageChanged: (index, reason){
                                  print("onChange:index: $index ReasonIndex: ${reason.index}");
                                  humidityStrm.sink.add("${weeklyList[index]['main']['humidity']}%");
                                  windStrm.sink.add("${weeklyList[index]['wind']['speed']}m/sec");
                                  airPressureStrm.sink.add("${weeklyList[index]['main']['pressure']}hPa");
                                  visibilityStrm.sink.add("${weeklyList[index]['visibility'] / 1000}km");

                                  var date = DateTime.fromMillisecondsSinceEpoch(weeklyList[index]['dt'] * 1000);
                                 var time = DateFormat('h:mma').format(date);
                                 timeStrm.sink.add(time);

                                },
                                scrollDirection: Axis.horizontal,
                              ));

                        } else {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: Colors.deepPurple,
                          ));
                        }
                      }),
                   ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white),
                    child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceAround,
                            children: [
                              StreamBuilder(
                                stream: humidityStrm.stream,
                                builder: (context,snap) {
                                  return ReuseIcon(
                                      value: snap.data??"",
                                      icon: Icons.water_drop,
                                      title: "Humidity");
                                }
                              ),
                              StreamBuilder(
                                  stream: windStrm.stream,
                                  builder: (context,snap) {
                                    return ReuseIcon(
                                        value: snap.data??"",
                                        icon: Icons.air_outlined,
                                        title: "Wind");
                                  }
                              ),
                      StreamBuilder(
                          stream: airPressureStrm.stream,
                          builder: (context,snap) {
                            return ReuseIcon(
                                value: snap.data??"",
                                icon: Icons.speed_rounded,
                                title: "Air Pressure");
                          }
                      ),
                    StreamBuilder(
                        stream: visibilityStrm.stream,
                        builder: (context,snap) {
                          return ReuseIcon(
                              value: snap.data??"",
                              icon: Icons.visibility,
                              title: "Visibility");
                        }
                    ),
                            ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children:  [
                        const Text(
                          "Today",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>FutureWeather(weeklyList:weeklyList,)));
                          },
                          child: const Text(
                            "Next 7 Days >",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height *3/12,
                    child: FutureBuilder(
                        future: weatherService.getHourlyData(widget.lat,widget.lon),
                        builder: (context,snap){
                      if(snap.connectionState==ConnectionState.waiting){
                        return const Center(
                            child: CircularProgressIndicator(color: Colors.deepPurple,));
                      }else if(snap.hasData){
                        hourlyList=snap.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            itemCount: hourlyList.length,
                            itemBuilder: (context,index){
                          var date = DateTime.fromMillisecondsSinceEpoch(hourlyList[index]['dt'] * 1000);
                          var time = DateFormat('h:mma').format(date);
                          double temperature = ((hourlyList[index]['main']['temp']) - 273.15);
                          return HourlyTile(
                              colorText: index==0?Colors.white:Colors.black,
                              colorTile: index==0?Colors.deepPurple:Colors.white,
                              time: time,
                              image: hourlyList[index]['weather'][0]['icon'],
                              temperature: temperature.toInt());
                        });
                      }else{
                       return const Text("No Data",style: TextStyle(color: Colors.black,fontSize: 15),);
                      }
                    }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    //getLatLong();
    // TODO: implement initState
    super.initState();
  }
}

class ReuseIcon extends StatelessWidget {
  ReuseIcon(
      {Key? key, required this.value, required this.icon, required this.title})
      : super(key: key);
  String value;
  String title;
  IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(
          icon,
          color: Colors.deepPurple,
          size: 30,
        ),
        Text(
          value,
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
        Text(
          title,
          style: TextStyle(color: Colors.grey[400], fontSize: 14),
        ),
      ],
    );
  }
}
