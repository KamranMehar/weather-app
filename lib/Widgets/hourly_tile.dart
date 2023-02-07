import 'package:flutter/material.dart';

class HourlyTile extends StatelessWidget {
  HourlyTile({Key? key,
  required this.time,required this.image,required this.temperature,
    this.colorTile=Colors.white,this.colorText=Colors.black}) : super(key: key);
String image;
String time;
int temperature;
Color colorTile;
Color colorText;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal:15,vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        //  color: colorTile
          gradient:colorTile==Colors.deepPurple? LinearGradient(colors: [
      const Color(0xff4B3EAE).withOpacity(0.5), const Color(0xff4B3EAE).withOpacity(0.9),
      ],):const LinearGradient(colors: [
     Colors.white, Colors.white,
    ])
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
          Text(time,style: TextStyle(fontSize: 15,color:colorText),),
          SizedBox(height: 70,width: 70,
          child: Image.asset('lib/icons/$image.png',
            fit: BoxFit.scaleDown,
          ),),
          Text("$temperature °C",style: TextStyle(fontSize: 21,color: colorText,fontWeight: FontWeight.bold),)
        ],),
      ),
    );
  }
}
