import 'package:busify_voyageur/controllers/Bus_controller.dart';
import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/ScanBus/UpdateBusLocation.dart';
import 'package:busify_voyageur/views/ScanStop/StartStop.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
 
  SharedPreferences? prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }


  NodeController nodeController= NodeController();
  LocationModel? loc;
  LocationController locController = LocationController();
  BusController busController = BusController();



  bool loading = false;

  double count = 153;

  double devide(double count){
    return count/2;
  }

  void funct(double count){
    double nc = devide(count);
    print(nc);
    Future.delayed(
      const Duration(seconds: 1),
      (){
        if (nc > 10) {
          funct(nc);
        } else {
          print("Stop");
        }
      }
    );
  } 

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
    return Scaffold(
      body: SizedBox(
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: width*0.4,
              height: width*0.1,
              child: ElevatedButton(
                child: const Text("Start"),
                onPressed: (){
                  funct(15377);
                }, 
              ),
            ),

            const SizedBox(height: 30,),

            SizedBox(
              width: width*0.4,
              height: width*0.1,
              child: ElevatedButton(
                child: const Text("ARRET"),
                onPressed: () async {

                  print("ARRET ---------------------------------");

                  Map<String, dynamic> scan = {
                    "scan" : "stop",
                    "depart" : 5394260858
                  };
                  
                  prefs!.setInt('lastDep', scan['depart']);

                  Node arret = await nodeController.getNodeOSM(scan["depart"]);

                  Map<String, dynamic> depart = arret.toJson(arret) as Map<String, dynamic> ;


                  Map<String, dynamic> stop = {
                    "ligne" : 7996451,
                    "depart" : depart
                  };



                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StartStop(data: stop) ),
                  );
                }, 
              ),
            ),

            const SizedBox(height: 30,),

            SizedBox(
              width: width*0.4,
              height: width*0.1,
              child: ElevatedButton(
                child: const Text("Crowd"),
                onPressed: () async {

                  print("Crowd ---------------------------------");

                  Map<String, dynamic> data = {
                    "scan" : "bus",
                    "qr" : {
                      "login" : {
                        "idp" : "https://solidcommunity.net",
                        "username" : "bus1",
                        "password" : "bus1123456"
                      },
                      "webId" : "https://bus1.solidcommunity.net"
                    }
                  };


                  Map<String, dynamic> pod = {
                    'login' : data['qr']['login'],
                    'webId' : data['qr']['webId'],
                  };


                  Map<String, dynamic> webId = {
                    "webId" : data['qr']['webId']
                  };

                  LocationModel busOldloc = await locController.getLocation(webId);
                  Bus bus = await busController.getBus(webId);

                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UpdateBusLocation(
                      bus: bus ,
                      loc: busOldloc,
                      data: pod,
                    )),
                  );
                }, 
              ),
            ),
          ],
        ),
      ),
    );
  }
}