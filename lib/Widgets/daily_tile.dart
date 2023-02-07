import 'dart:ui';

import 'package:flutter/material.dart';



class DailyTile extends StatelessWidget {
  int temperature;
  String dateDay;
  String dateMonth;
  String dateYear;
  String icon;
  String day;
  String weatherStatus;
  double borderRadius;
  double blur;
  Color borderColor;
  double borderWidth;
   DailyTile({Key? key,
     required this.temperature,
      required this.dateDay,
     required this.dateMonth,
     required this.dateYear,
     required this.icon,
     required this.day,
     required this.weatherStatus,
     this.borderRadius=50,
     this.borderColor=Colors.white,
     this.blur=8,
     this.borderWidth=2,
   }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child:
        Stack(
          children: [
            //Blur Effect
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
                  child: Container(
                    decoration: BoxDecoration(
                    //  border: Border.all(color: Colors.white,width: 0.3),
                      borderRadius: BorderRadius.circular(borderRadius),
                      gradient: LinearGradient(colors: [
                        const Color(0xff4B3EAE).withOpacity(0.5),
                        const Color(0xff4B3EAE).withOpacity(0.9),
                      ],
                     begin: Alignment.topCenter,
                        end: Alignment.bottomRight
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FittedBox(
                          fit: BoxFit.fill,
                            child: SizedBox(
                                height: 150,
                                width: 150,
                                child: Image.asset('lib/icons/$icon.png',
                                fit: BoxFit.scaleDown,
                                ))),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                            child: Text("${temperature.ceil()}°C",style:  const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,
                                fontSize:50),)),
                       FittedBox(
                           fit: BoxFit.scaleDown,
                           child: Text(weatherStatus,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 20),)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: const EdgeInsets.all(5),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                  ),
                  child: Text("$day, $dateDay $dateMonth $dateYear",
                    style: const TextStyle(color: Colors.black,fontSize: 13,fontWeight: FontWeight.bold),)),
            )
          ],
        ),

      ),
    );
  }
}
