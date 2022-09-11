import 'dart:convert';

import 'package:busify_voyageur/controllers/Bus_controller.dart';
import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/services/LocalNotifications.dart';
import 'package:busify_voyageur/views/ScanBus/UpdateBusLocation.dart';
import 'package:busify_voyageur/views/ScanStop/StartStop.dart';
import 'package:busify_voyageur/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Emulator extends StatefulWidget {
  const Emulator({Key? key}) : super(key: key);

  @override
  State<Emulator> createState() => _EmulatorState();
}

class _EmulatorState extends State<Emulator> {
 
  SharedPreferences? prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  late final LocalNotificationService service;


  @override
  void initState() {
    initPrefs();
    service = LocalNotificationService();
    service.initalize();
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

  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
  
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Page de test"),
          centerTitle: true,
        ),
        body: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: width*0.4,
                  height: width*0.4,
                  child: Image.asset("assets/voyageur.png"),
                ),
    
    
                const SizedBox(height: 30,),

                const Text(
                  "Afin de changer la localisation de l'emulateur pour tester les fonctions",
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: 30,),
    
                loading ?
                const Loading()
                : Column(
                  children: [
                    // ! Arret
                    CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      child: const Text("Scan Arret"),
                      onPressed: () async {
    
                        print("Scan arret");

                        setState(() {
                          loading = true;
                        });
        
    
                        Map<String, dynamic> scan = {
                          "scan" : "stop",
                          "depart" : 3122540287
                        };
                        
                        prefs!.setInt('lastDep', scan['depart']);
    
                        Node arret = await nodeController.getNodeOSM(scan["depart"]);

                        Map<String, dynamic> lastStop = {
                          "nom" : arret.name,
                          "id" : arret.id
                        };

                        prefs!.setString('lastStop', jsonEncode(lastStop));
    
                        Map<String, dynamic> depart = arret.toJson(arret) as Map<String, dynamic> ;
    
    
                        Map<String, dynamic> stop = {
                          "ligne" : 7996451,
                          "depart" : depart
                        };
    
    
                        setState(() {
                          loading = false;
                        });
        
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => StartStop(data: stop) ),
                        );
                      }, 
                    ),

                    const SizedBox(height: 15,),
    
                    // ! BS
                    CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      child: const Text("Scan Bus"),
                      onPressed: () async {

                        setState(() {
                          loading = true;
                        });
        
                        print("Scan bus");
        
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

                        setState(() {
                          loading = false;
                        });
        
        
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => UpdateBusLocation(
                            bus: bus ,
                            loc: busOldloc,
                            pod: pod,
                          )),
                        );
                      }, 
                    ),

                    const SizedBox(height: 30,),

                    Text(
                      "Les notifications",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),

                    const SizedBox(height: 30,),

                    CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      child: const Text("Envoyer"), 
                      onPressed: () async {
                        await service.showNotification(
                          id: 0, 
                          title: "Busify Voyageur", 
                          body: "Une notifications est arrivée"
                        );
                      }
                    ),

                    const SizedBox(height: 15,),

                    CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      child: const Text("Programmer"), 
                      onPressed: () async {
                        await service.showScheduledNotification(
                          id: 0, 
                          title: "Busify Voyageur", 
                          body: "Votre bus arrive dans 1 minutes, ne le ratez pas.", 
                          seconds: const Duration(seconds: 5).inSeconds
                        );

                      }
                    ),
                    
                 
                  ],
                ),
    
               
              ],
            ),
          ),
        ),
      ),
    );
  }
}