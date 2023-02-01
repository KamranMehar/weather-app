import 'package:flutter/material.dart';



class TemperatureTile extends StatelessWidget {
  int temperature;
  String date;
  String time;
  String day;
   TemperatureTile({Key? key,
     required this.temperature,
      required this.date,
     required this.time,
     required this.day
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
       // height: 250,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          border: Border.all(color: Colors.white,width: 1),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
              SizedBox(
                height: 150,
                width: 150,
                child: Image.asset('Assets/moon_cloud_fast_wind.png'),
              ),
            Text("${temperature.ceil()}°C",style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 40),),
            Text(day,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 35),),
            Text(time,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 25),),
            Text(date,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),),
          ],
        ),
      ),
    );
  }
}
