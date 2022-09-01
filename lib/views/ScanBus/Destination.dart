
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Maps/StopLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Destination extends StatefulWidget {
  final Map<String, dynamic> data;
  const Destination({required this.data});

  @override
  State<Destination> createState() => _DestinationState();
}

class _DestinationState extends State<Destination> {

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

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    List<Node> dests = widget.data['destinations'] as List<Node>;

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
    
                       print("ebda tserbi");

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

                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Merci !"),
                              content: const Text("Vous allez contribuer avec votre localisation jusqu'a votre destination"),
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