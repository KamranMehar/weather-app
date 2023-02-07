import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/Pages/home.dart';

import '../util/custom_toast.dart';

class GetLocation extends StatefulWidget {
  const GetLocation({Key? key}) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness:
        Brightness.dark, //or set color with: Color(0xFF0000FF)
      ),
    ),
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('lib/images/location_anim.gif',fit: BoxFit.scaleDown,),
          ),
        ),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      getLatLong();
      UtilToast.showToast("Turn on the Location !");
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        UtilToast.showToast("Location permission is denied !");
        getLatLong();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      UtilToast.showToast("Location permissions are permanently denied, we cannot request permissions !");
      getLatLong();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  getLatLong() {
    Future<Position> data = _determinePosition();
    data.then((value) {
      if (kDebugMode) {
        print("value $value");
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>
          HomeScreen(lat: value.latitude, lon: value.longitude,)));

    }).catchError((error) {
      UtilToast.showToast(error.toString());
      if (kDebugMode) {
        print("Error $error");
      }
    });
  }
@override
  void initState() {
    // TODO: implement initState
  getLatLong();
    super.initState();
  }
}
