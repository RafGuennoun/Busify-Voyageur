import 'dart:convert';

import 'package:busify_voyageur/controllers/Bus_controller.dart';
import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Testing extends StatefulWidget {
  final Bus bus;
  final Map<String, dynamic> pod;
  final Node dest;
  const Testing({required this.bus, required this.pod, required this.dest});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {

  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final bool _isListenLocation = false;
  bool _isGetLocation = false;

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

  int value = -1;

  Node? dest;

  LocationController locationController = LocationController();
  BusController busController = BusController();

  LocationModel? busLoc;

  participer(LocationData locationData, double destLat, double destLon, List<Map<String, dynamic>> participations ) async {

    double lat = double.parse(locationData.latitude!.toStringAsFixed(4));
    double lon = double.parse(locationData.longitude!.toStringAsFixed(4));

    if (lat != destLat && lon != destLon) {

      await Future.delayed(
        const Duration(seconds: 20),
        () async {
      
          LocationData newLoc = await location.getLocation();

          double newLat = double.parse(newLoc.latitude!.toStringAsFixed(4));
          double newLon = double.parse(newLoc.longitude!.toStringAsFixed(4));

          Map<String, dynamic> participation = 
          {
            "latitude" : newLat,
            "longitude" : newLon,
          };

          LocationController locationController = LocationController();

          bool ajoute = await locationController.addTrack(widget.pod, participation);
          print("ajouté = $ajoute");

          setState(() {
            participations.add(participation);
          });

          
          participer(newLoc, destLat, destLon, participations);
        }
      );
    } else {

      print("c'est egale");
      
    }

  }

  List<Map<String, dynamic>> participations = [
    {
      "latitude" : "test",
      "longitude" : "test",
    }
  ];
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Page de test"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.dashboard,
              ),
              onPressed: (){
                Navigator.pushAndRemoveUntil(
                  context, 
                  MaterialPageRoute(builder: (context) => HomeView(prefs: prefs!)), 
                  (route) => false
                );
              }, 
            )
          ],
        ),

        body: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                children: [

                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text("Participer"), 
                    onPressed: () async {
                      print("Besmellah");

                      // Demander 

                      _serviceEnabled = await location.serviceEnabled();
                      if (!_serviceEnabled!) {
                        _serviceEnabled = await location.requestService();
                        if (_serviceEnabled!) {
                          return;
                        }
                      } 

                      _permissionGranted = await location.hasPermission();
                      if (_permissionGranted == PermissionStatus.denied ) {
                        _permissionGranted = await location.requestPermission();
                        if (_serviceEnabled == PermissionStatus.granted) {
                          return;
                        }
                      } 

                      _locationData = await location.getLocation();
                      setState(() {
                        _isGetLocation = true;
                      });

                      Map<String, dynamic> webId = {
                        "webId" : widget.pod["webId"]
                      };


                      busLoc = await locationController.getLocation(webId);
                      print(busLoc.toString()); 
                      
                      double lat = 0;
                      double lon = 0;

          
                      double destLat = double.parse(widget.dest.lat.toStringAsFixed(4));
                      double destLon = double.parse(widget.dest.lon.toStringAsFixed(4));

                      Bus bus = await busController.getBus(webId);

                      Map<String, dynamic> busData = {
                        "nom" : bus.name,
                        "marque" : bus.marque,
                        "matricule" : bus.matricule
                      };

                      String lastBus = jsonEncode(busData);

                      prefs!.setString('lastBus', lastBus);

                      if (prefs!.getInt("nbScan") == null) {
                        prefs!.setInt("nbScan", 1);
                      } else {
                        int nb = prefs!.getInt("nbScan")!;
                        prefs!.setInt("nbScan", nb+1);
                      }
                    

                      participer(_locationData!, destLat, destLon, participations);

                      // LocationController locationController = LocationController();

                      // bool add = await locationController.addTrack(widget.pod, part);
                      // print("add = $add");
                      

                      // print("tracking list : -------------------");
                      // List<String> trackingList = busLoc!.track.split(',');
                      // print(trackingList.toString());

                      // for (int i = 0; i < trackingList.length; i++) {
                      //   print("-------------------------------------------------------");
                      //   print("index : ${i+1}");
                      //   print("track : ${trackingList[i]}");

                      //   List<String> temp = trackingList[i].split(';');
                      //   print("temp = $temp"); 
                      //   print("temp 0 = ${temp[0].toString().replaceAll('[','')}"); 
                      //   print("temp 1 = ${temp[1].toString().replaceAll(']','')}"); 

                      //   print("-------------------------------------------------------");
                        
                      // }


                    }
                  ),

                  const SizedBox(height: 20,),

                  const Text("Liste des données"),

                  const SizedBox(height: 20,),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: participations.length,
                    itemBuilder: (context , index) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.number,
                                color: Theme.of(context).primaryColor,
                              ),

                              title: Text(
                                "Participation n° $index",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),

                            ListTile(
                              leading: Icon(
                                CupertinoIcons.location_solid,
                                color: Theme.of(context).primaryColor,
                              ),

                              title: Text(
                                "Latitude = ${participations[index]["latitude"]}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),

                            ListTile(
                              leading: Icon(
                                CupertinoIcons.location_solid,
                                color: Theme.of(context).primaryColor,
                              ),

                              title: Text(
                                "Longitude = ${participations[index]["longitude"]}",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  )

                  
                ],
              ),
            ),
          ),
        ),

      ),
    );
  }
}