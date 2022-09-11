


import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Main_view.dart';
import 'package:busify_voyageur/views/ScanBus/Destination.dart';
import 'package:busify_voyageur/widgets/Loading.dart';
import 'package:busify_voyageur/widgets/SimpleAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateBusLocation extends StatefulWidget {
  final Bus bus;
  final LocationModel loc;
  final Map<String, dynamic> pod;
  const UpdateBusLocation({required this.bus, required this.loc, required this.pod});

  @override
  State<UpdateBusLocation> createState() => _UpdateBusLocationState();
}

class _UpdateBusLocationState extends State<UpdateBusLocation> {

  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final bool _isListenLocation = false;
  final bool _isGetLocation = false;

  LocationController locController = LocationController();

  final _nomController = TextEditingController();
  final _marqueController = TextEditingController();
  final _matController = TextEditingController();

  NodeController nodeController = NodeController();
  Future<List<Node>>? nodes;

  bool read = true;

  SharedPreferences? prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
    nodes = nodeController.buildNodes(7996451);
    _nomController.text = widget.bus.name;
    _marqueController.text = widget.bus.marque;
    _matController.text = widget.bus.matricule;
  }

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
    _marqueController.dispose();
    _matController.dispose();
  }

  void showDialog(String title, String content){
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return SimpleAlertDialog(title: title, content: content,);
      },
    );
  }

  bool loading = false;

  void participer(int cpt,  Map<String, dynamic> webId, LocationData loc) async {
    if (cpt < 4) {
      LocationController locationController = LocationController();
      LocationModel busLoc= await locationController.getLocation(webId);

      String tracking = busLoc.getTrack();

      if (tracking.isEmpty) {
        List<String> temp = [];
        String userLoc = "[${loc.latitude.toString()},${loc.longitude.toString()}]";
        temp.add(userLoc);

        String newTrack = temp.toString();

        Map<String, dynamic> json = {
          "login" : {
            "idp" : "https://solidcommunity.net",
            "username" : "bus1",
            "password" : "bus1123456" 
          },
          "webId" : webId,
          "location" : {
            "lat" : busLoc.lat.toString(),
            "lon" : busLoc.lon.toString(),
            "track" : newTrack 
          }
        };

        print("Setting cas 0");
        await locController.setLocation(json).then((value){
          print("Setted from 0");
          cpt ++;
          participer(cpt, webId, loc);
        });

      } else {

        List<String> temp = tracking.split(','); 
        String userLoc = "[${loc.latitude},${loc.longitude}]";
        temp.add(userLoc);
        String newTrack = temp.toString();

        Map<String, dynamic> json = {
          "login" : {
            "idp" : "https://solidcommunity.net",
            "username" : "bus1",
            "password" : "bus1123456" 
          },
          "webId" : webId,
          "location" : {
            "lat" : busLoc.lat.toString(),
            "lon" : busLoc.lon.toString(),
            "track" : newTrack 
          }
        };

        print("Setting cas pas 0");
        await locController.setLocation(json).then((value){
          print("Setted from not 0");
          cpt ++;
          participer(cpt, webId, loc);
        });



      }



    } else {
      print("khlas");
    }
  }

  int cpt = 0;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Participation"),
          centerTitle: true,
        ),
    
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
        
                  Hero(
                    tag: 'bus',
                    child: Icon(
                      CupertinoIcons.bus,
                      color: Theme.of(context).primaryColor,
                      size: 150,
                    ),
                  ),
        
                  const SizedBox(height: 45,),
    
                  const Text("Informations du bus scanné"),
                  
                  const SizedBox(height: 20,),
        
                  
                  // NOM
                  TextField(
                    controller: _nomController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        CupertinoIcons.bus,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Nom",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                    
                  ),
        
                  const SizedBox(height: 20,),
        
                  // Marque
                  TextField(
                    controller: _marqueController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        CupertinoIcons.bookmark_fill,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Marque",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
        
                  const SizedBox(height: 20,),
        
                  // Matricule
                  TextField(
                    controller: _matController,
                    readOnly: read,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(
                        CupertinoIcons.number,
                        color: Theme.of(context).primaryColor,
                      ),
                      labelText: "Matricule",
                      labelStyle: Theme.of(context).textTheme.bodyMedium,
                      hintStyle: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
    
                  const SizedBox(height: 45,),
    
                  SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child : FutureBuilder(
                        future: nodes,
                        builder: ( context, snapshot) {
                          print(snapshot.connectionState);
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox(
                              height: 60,
                              child: Center(
                                child: Loading()
                              )
                            );
    
                          } else if (snapshot.connectionState == ConnectionState.done) {
                            if (snapshot.hasError) {
                              return const Text('Error');
                            } else if (snapshot.hasData) {
                              // ! C'est ici que ca se passe
    
                              List<Node> arrets = snapshot.data as List<Node>; 
                              // arrets.remove(Node.fromJson(widget.data['depart']));
    
                              Map<String, dynamic> dests = {
                                "destinations" : arrets // ! list of Nodes
                              };
    
                              return CupertinoButton(
                                color: Theme.of(context).primaryColor,
                                child: const Text("Choisir la destination"),
                                onPressed: (){
    
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Destination(
                                      bus: widget.bus,
                                      pod: widget.pod,
                                      stops: dests,
                                    ))
                                  );
                                }
                              );
                              
                              
                              // return Text(snapshot.data.toString());
                            } else {
                              return const Text('Empty data');
                            }
                          } else {
                            return Text('State: ${snapshot.connectionState}');
                          }
                        },
                      ),
                    ),
                  ),
    
                  // loading  
                  // ? const SizedBox(
                  //   width: 50,
                  //   height: 50,
                  //   child: Center(child: CircularProgressIndicator()),
                  // )
                  // : Column(
                  //   children: [
                  //     CupertinoButton(
                  //       color: Theme.of(context).primaryColor,
                  //       child: const Text("Participer"), 
                  //       onPressed: ()async {
    
                  //         // setState(() {
                  //         //   loading = true;
                  //         // });
                  //         _serviceEnabled = await location.serviceEnabled();
                  //         if (!_serviceEnabled!) {
                  //           _serviceEnabled = await location.requestService();
                  //           if (_serviceEnabled!) {
                  //             return;
                  //           }
                  //         } 
    
                  //         _permissionGranted = await location.hasPermission();
                  //         if (_permissionGranted == PermissionStatus.denied ) {
                  //           _permissionGranted = await location.requestPermission();
                  //           if (_serviceEnabled == PermissionStatus.granted) {
                  //             return;
                  //           }
                  //         } 
    
                  //         _locationData = await location.getLocation();
                  //         setState(() {
                  //           _isGetLocation = true;
                  //           loading = true;
                  //         });
    
                  //         int? nbScans = prefs!.getInt("nbScans");
    
                  //         if (nbScans == null) {
                  //           prefs!.setInt("nbScans", 1);
                  //         } else {
                  //           int nb = nbScans + 1;
                  //           prefs!.setInt("nbScans", nb);
                            
                  //         }
    
                  //         Map<String, dynamic> busData = {
                  //           "nom" : widget.bus.name,
                  //           "marque" : widget.bus.marque,
                  //           "matricule" : widget.bus.matricule
                  //         };
    
                  //         prefs!.setString("lastBus", jsonEncode(busData));
                  //         print("Encode = ${ jsonEncode(busData)}");
    
                  //         print("BISMALLA");
                  //         // participer(0, widget.data, _locationData!);
                  //         // print("AL HAMDOU LILLAH");
    
                  //         Map<String, dynamic> webID = {
                  //           "webId" : "https://bus1.solidcommunity.net",
                  //         };
    
                  //         // Map<String, dynamic> json = {
                  //         //   "login" : widget.data['login'],
                  //         //   "webId" : widget.data['webId'],
                  //         //   "location" : {
                  //         //     "lat" : widget.loc.lat,
                  //         //     "lon" : widget.loc.lon
                  //         //   }
                  //         // };
    
                  //         // locController.setLocation(json).whenComplete((){
                  //         //   Future.delayed(
                  //         //     const Duration(seconds: 1),
                  //         //     (){
                  //         //       setState(() {
                  //         //         loading = false;
                  //         //       });
                  //         //     }
                  //         //   );
                  //         // });
    
                  //         showCupertinoDialog(
                  //           context: context,
                  //           builder: (context) {
                  //             return CupertinoAlertDialog(
                  //               title: const Text("Merci !"),
                  //               content: const Text("Vous avez mis à jour la localisation de ce bus."),
                  //               actions: [
    
                  //                 CupertinoDialogAction(
                  //                   child: Text(
                  //                     "Retour",
                  //                     style: TextStyle(color: Theme.of(context).primaryColor),
                  //                   ),
                  //                   onPressed: (){ 
                  //                     Navigator.pushAndRemoveUntil(
                  //                       context, 
                  //                       MaterialPageRoute(builder: (context) => MainView(prefs: prefs!,)), 
                  //                       (route) => false
                  //                     );
                  //                   }
                  //                 ),
                  //               ],
                  //             );
                  //           },
                  //         );
                  //       }
                  //     ),
    
    
                      
                  //   ],
                  // ),
                    // const SizedBox(height: 10,),
                    
                    
                    CupertinoButton(
                      child: const Text("Annuler"), 
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => MainView(prefs: prefs!,)), 
                          (route) => false
                        );
                      }, 
                    )
          
    
                 
                
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}