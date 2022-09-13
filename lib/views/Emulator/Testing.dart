import 'dart:convert';

import 'package:busify_voyageur/controllers/Bus_controller.dart';
import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/services/LocalNotifications.dart';
import 'package:busify_voyageur/views/Main_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
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

  MapController? controller ;
  
  late final LocalNotificationService service;

  @override
  void initState() {
    initPrefs();
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
        latitude: 36.7135, 
        longitude: 6.0473
      ),
    );
    service = LocalNotificationService();
    service.initalize();
    super.initState();
    
  }

  int value = -1;

  Node? dest;

  bool start = false;

  LocationController locationController = LocationController();
  BusController busController = BusController();

  LocationModel? busLoc;

  LocationModel keepTrack = LocationModel("0", "0", "");

  participer(
    LocationData locationData, 
    double destLat, 
    double destLon, 
    List<Map<String, dynamic>> participations,
    bool start,
    LocationModel keepTrack 
    ) async {

    double lat = double.parse(locationData.latitude!.toStringAsFixed(4));
    double lon = double.parse(locationData.longitude!.toStringAsFixed(4));

    if (lat != destLat && lon != destLon) {

      await Future.delayed(
        const Duration(seconds: 10),
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

          Map<String, dynamic> webId = 
          {
            "webId" : "https://bus1.solidcommunity.net"
          };

          LocationModel busLoc = await locationController.getLocation(webId);
          if (busLoc.lat.isEmpty) {
            Map<String, dynamic> json = {
              "login" : widget.pod['login'],
              "webId" : widget.pod['webId'],
              "location" : {
                "lat" : newLat.toString(),
                "lon" : newLon.toString(),
                "track" : ""
              }
            };

            bool initGeo = await locationController.setLocation(json);

            debugPrint("init geo = $initGeo");
          }


          bool ajoute = await locationController.addTrack(widget.pod, participation);
          print("ajouté = $ajoute");

          if (start == false) {
            
            setState(() {
              keepTrack = LocationModel(newLat.toString(), newLon.toString(),""); 
              participations.add(participation);
            });

            participer(newLoc, destLat, destLon, participations, true, keepTrack);
  
          } else {
            GeoPoint oldTrackPoint = GeoPoint(
              latitude: double.parse(keepTrack.lat), 
              longitude: double.parse(keepTrack.lon)
            );

            GeoPoint newTrackPoint = GeoPoint(
              latitude: newLat, 
              longitude: newLon
            );

            GeoPoint destPoint = GeoPoint(
              latitude: destLat, 
              longitude: destLon
            );

            RoadInfo oldRoadInfo = await controller!.drawRoad( 
              oldTrackPoint, 
              destPoint,
              roadType: RoadType.car,
            ); 

            double oldDistance = oldRoadInfo.distance!;

            RoadInfo newRoadInfo = await controller!.drawRoad( 
              newTrackPoint, 
              destPoint,
              roadType: RoadType.car,
            );
            double newDistance = newRoadInfo.distance!;

            debugPrint("${oldDistance-newDistance} km");

            if (oldDistance >= newDistance) {
              debugPrint("Continuer");

              setState(() {
                keepTrack = LocationModel(
                  newLat.toString(), newLon.toString(), "");
                participations.add(participation);
              });
          
              participer(newLoc, destLat, destLon, participations, true, keepTrack);

            } else {

              debugPrint("Tester la marge d'erreur");
              int marge = 100;

              if ((newDistance - oldDistance) > marge) {
       
                await service.showNotification(
                  id: 0, 
                  title: "Participation", 
                  body: "Votre participation s'est arreté, vous vos etes éloignés du chemin du bus."
                );

                showCupertinoDialog(
                  context: context, 
                  builder:(context) {
                    return CupertinoAlertDialog(
                      title: const Text("Participation"),
                      content: const Text("Votre participation s'est arreté, vous vos etes éloignés du chemin du bus."),
                      actions: [
                        CupertinoButton(
                          child:const Text("D'accord"), 
                          onPressed: (){
                            Navigator.pushAndRemoveUntil(
                              context, 
                              MaterialPageRoute(builder: (context) => MainView(prefs: prefs!)), 
                              (route) => false
                            );
                          
                          }
                        )
                      ],
                    );
                  }
                );
              } else {

                debugPrint("Dans la marge d'erreur");
                setState(() {
                  keepTrack = LocationModel(
                  newLat.toString(), newLon.toString(), "");
                  participations.add(participation);
                });
          
                participer(newLoc, destLat, destLon, participations, true, keepTrack);

              }
              
            }
            
          }

        }
      );
    } else {

      debugPrint("Destination");

      await service.showNotification(
        id: 0, 
        title: "Merci pour votre participation", 
        body: "Votre participation s'est arreté, vous etes arrivés a destination."
      ); 

      showCupertinoDialog(
        context: context, 
        builder:(context) {
          return CupertinoAlertDialog(
            title: const Text("Participation"),
            content: const Text("Votre participation s'est arreté, vous etes arrivé a destination"),
            actions: [
              CupertinoButton(
                child:const Text("D'accord"), 
                onPressed: (){
                  Navigator.pop(context);
                }
              ),

              CupertinoButton(
                child:const Text("Continuer"), 
                onPressed: (){
                  Navigator.pop(context);
                }
              ),
            ],
          );
        }
      );
      
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
                  MaterialPageRoute(builder: (context) => MainView(prefs: prefs!)), 
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

                  SizedBox(
                    width: 1,
                    height: 1,
                    child: OSMFlutter( 
                      controller: controller!,
                      trackMyPosition: false,
                        initZoom: 16,
                    ),
                  ),

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

                      LocationModel t = LocationModel("", "", "");
                    

                      participer(_locationData!, destLat, destLon, participations, false, t);


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