
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FutureWeather extends StatefulWidget {
  List weeklyList;
   FutureWeather({Key? key,required this.weeklyList}) : super(key: key);

  @override
  State<FutureWeather> createState() => _FutureWeatherState();
}

class _FutureWeatherState extends State<FutureWeather> {


  @override
  Widget build(BuildContext context) {
    int temperature = ((widget.weeklyList[0]['main']['temp']) - 273.15).toInt();
    var date = DateTime.fromMillisecondsSinceEpoch(widget.weeklyList[0]['dt'] * 1000);
    var day = DateFormat('EEEE').format(date);
    var dateDay = DateFormat('d').format(date);
    var dateMonth = DateFormat('LLL').format(date);
    var dateYear = DateFormat('y').format(date);
    return Container(
      decoration:  const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff4B3EAE),
            Colors.white,
            Color(0xff4B3EAE),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: Column(
            children:  [
            const Text("Toady's Weather",style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),),
            Text("$day, $dateDay $dateMonth $dateYear",style: const TextStyle(fontSize: 15,color: Colors.white,),),
          ],),
          leading: IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: const Icon(Icons.arrow_back_ios_new_outlined,color: Colors.white,)),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 10,
              width: MediaQuery.of(context).size.width,
            ),
            Container(
              height: MediaQuery.of(context).size.height* 2/11,
              width: MediaQuery.of(context).size.width* 9/10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                border: Border.all(color: Colors.white,width: 1),
                color: Colors.white.withOpacity(0.4)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                SizedBox(
                  height: 90,
                  width: 90,
                  child:Image.asset('lib/icons/${widget.weeklyList[0]['weather'][0]['icon']}.png'),
                ),
                  Text("$temperature°C",style: const TextStyle(fontSize: 50,color: Colors.white,fontWeight: FontWeight.bold),)
              ],),
            ),
           const SizedBox(height: 20,),
           Stack(
             children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
              child:  Container(
                height: MediaQuery.of(context).size.height *5/10,
                width: MediaQuery.of(context).size.width *9/10,
                decoration:  BoxDecoration(
                    borderRadius: BorderRadius.circular(45),
                    color: Colors.white.withOpacity(0.5)
                ),
              ),
              ),
               Padding(
                 padding: const EdgeInsets.only(top: 20),
                 child: Container(
                   decoration: BoxDecoration(
                     borderRadius: BorderRadius.circular(45),
                     color: Colors.white
                   ),
                   child: SizedBox(
                     height: MediaQuery.of(context).size.height *5/10,
                     width: MediaQuery.of(context).size.width *9/10,
                     child: Padding(
                       padding: const EdgeInsets.all(10),
                       child: ListView.builder(
                           itemCount: (widget.weeklyList.length)~/8,
                           itemBuilder: (context,index){
                             var date = DateTime.fromMillisecondsSinceEpoch(widget.weeklyList[index]['dt'] * 1000);
                             var day = DateFormat('EEEE').format(date);
                             var dateDay = DateFormat('d').format(date);
                             var dateMonth = DateFormat('LLL').format(date);
                             var dateYear = DateFormat('y').format(date);
                         return Padding(
                           padding: const EdgeInsets.symmetric(vertical: 10),
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.spaceAround,
                             children: [
                             SizedBox(height: 50,width: 50,
                               child: Image.asset('lib/icons/${widget.weeklyList[index]['weather'][0]['icon']}.png')),
                             Text("${((widget.weeklyList[index]['main']['temp']) - 273.15).toInt()}°C",style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Colors.black),),
                               Column(children: [
                                 Text(day,style: const TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.black),),
                                 Text("$dateDay $dateMonth $dateYear",style: const TextStyle(fontSize: 14,color: Colors.grey),),
                               ],)
                           ],),
                         );
                       }),
                     ),
                   ),
                 ),
               )
             ],
           )
          ],
        ),
      ),
    );
  }
}
