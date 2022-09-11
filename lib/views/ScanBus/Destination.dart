
import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Emulator/Testing.dart';
import 'package:busify_voyageur/views/Maps/StopLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Destination extends StatefulWidget {
  final Bus bus;
  final Map<String, dynamic> pod;
  final Map<String, dynamic> stops;
  const Destination({required this.bus, required this.pod, required this.stops});

  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {

  Location location = Location();
  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final bool _isListenLocation = false;
  final bool _isGetLocation = false;

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

  LocationModel? busLoc;

  participer(LocationData locationData, double destLat, double destLon) async {

    print("---------------------------------------------------------------------------");
    print("1. Participer");

    double lat = double.parse(locationData.latitude!.toStringAsFixed(4));
    print("lat = $lat");
    double lon = double.parse(locationData.longitude!.toStringAsFixed(4));
    print("lon = $lon");

    print("---------------------------------------------------------------------------");



    if (lat != destLat && lon != destLon) {
      print("2. Pas egales await delayed");
      print("---------------------------------------------------------------------------");

      await Future.delayed(
        const Duration(seconds: 10),
        () async {
      
          print("3. Get loc");
          print("---------------------------------------------------------------------------");
          LocationData newLoc = await location.getLocation();

          print("4. Relancer");
          print("---------------------------------------------------------------------------");
          print("---------------------------------------------------------------------------");
          participer(newLoc, destLat, destLon);
        }
      );
    } else {

      print("OUI C'est egale");
      
    }

  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    List<Node> dests = widget.stops['destinations'] as List<Node>;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Destination"),
          centerTitle: true,
        ),
    
        body: SingleChildScrollView(
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  SizedBox(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: dests.length,
                      itemBuilder:(context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Card(
                            child : RadioListTile(
                              title: Text(
                                " ${dests[index].name.toString()}",
                                style: Theme.of(context).textTheme.bodyMedium
                              ),
                              subtitle: Text(
                                " ${dests[index].network.toString()}",
                                style: Theme.of(context).textTheme.bodySmall,                    
                              ),
                              activeColor: Theme.of(context).primaryColor,
                              secondary: IconButton(
                                icon: Icon(
                                  CupertinoIcons.location_solid,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: (){
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => StopLocation(arret: dests[index]))
                                  );
                                }, 
                              ),
                              value: index,
                              groupValue: value,
                              onChanged: (ind){
                                setState(() {
                                  value = ind as int;
                                  dest = dests[index];
                                });
                                  print("value = $value / index = $index");
                                  print(dests[index].toString());
    
                              },
        
                            )
                          ),
                        );
                      },
                    ),
                  ),
        
                  const SizedBox(height: 10,),
        
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text("Participer"),
                    onPressed: () async {
    
                      if (value == -1) {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Oups !"),
                              content: const Text("Veuillez choisir une destination"),
                              actions: [
    
                                CupertinoDialogAction(
                                  child: Text(
                                    "OK",
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                  onPressed: (){ 
                                    Navigator.pop(context);
                                  }
                                ),
                              ],
                            );
                          },
                        );
                      } else {
    
                      //  print("ebda tserbi");

                      //  // Demander 
    
                      //   _serviceEnabled = await location.serviceEnabled();
                      //   if (!_serviceEnabled!) {
                      //     _serviceEnabled = await location.requestService();
                      //     if (_serviceEnabled!) {
                      //       return;
                      //     }
                      //   } 
    
                      //   _permissionGranted = await location.hasPermission();
                      //   if (_permissionGranted == PermissionStatus.denied ) {
                      //     _permissionGranted = await location.requestPermission();
                      //     if (_serviceEnabled == PermissionStatus.granted) {
                      //       return;
                      //     }
                      //   } 
    
                      //   _locationData = await location.getLocation();
                      //   setState(() {
                      //     _isGetLocation = true;
                      //   });

                      //   Map<String, dynamic> webId = {
                      //     "webId" : widget.pod["webId"]
                      //   };

                      //   busLoc = await locationController.getLocation(webId);

                      //   print(busLoc.toString()); 
                        
                      //   double lat = 0;
                      //   double lon = 0;

            
                        // double destLat = double.parse(dests[value].lat.toStringAsFixed(4));
                        // double destLon = double.parse(dests[value].lon.toStringAsFixed(4));

                      //   participer(_locationData!, destLat, destLon);
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Testing(
                          bus: widget.bus, 
                          pod: widget.pod,
                          dest: dests[value],
                        ))
                      );


                        
                      }
                    }
                  ),
    
                  const SizedBox(height: 15,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}