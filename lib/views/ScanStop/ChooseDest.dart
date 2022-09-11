
import 'package:busify_voyageur/controllers/Bus_controller.dart';
import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Maps/StopLocation.dart';
import 'package:busify_voyageur/views/ScanStop/BusList.dart';
import 'package:busify_voyageur/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChooseDest extends StatefulWidget {
  final Map<String, dynamic> data;
  const ChooseDest({required this.data});

  @override
  State<ChooseDest> createState() => _ChooseDestState();
}

class _ChooseDestState extends State<ChooseDest> {

  SharedPreferences? prefs;

  Future initPrefs() async {
    // instance
    prefs = await SharedPreferences.getInstance();
  }

  MapController? controller ;

  @override
  void initState() {
    initPrefs();
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
        latitude: (widget.data['depart'] as Node).lat, 
        longitude: (widget.data['depart'] as Node).lon
      ),
    );
    super.initState();
    
  }

  int value = -1;

  Node? dest;

  BusController busController = BusController();
  LocationController locationController = LocationController();

  bool loading = false;

  bool hide = true;


  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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

                  hide? 
                  SizedBox(
                    width: 1,
                    height: 1,
                    child: OSMFlutter( 
                      controller: controller!,
                      trackMyPosition: false,
                        initZoom: 16,
                    ),
                  ) : const Text("osm map"),
        
                  loading ?
                  const Loading()
                  : CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text("Trouver les bus"),
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

                        setState(() {
                          loading = true;
                        });

                        print("geopoint depart");

                        GeoPoint gd = GeoPoint(
                          latitude: (widget.data['depart'] as Node).lat, 
                          longitude: (widget.data['depart'] as Node).lon
                        );

                        print("geopoint dest");

                        GeoPoint gf = GeoPoint(
                          latitude: dests[value].lat, 
                          longitude: dests[value].lon,
                        );

                        List<Map<String, dynamic>> bus = [
                          { "webId" : "https://bus1.solidcommunity.net" },
                          { "webId" : "https://bus2.solidcommunity.net" },
                          { "webId" : "https://bus3.solidcommunity.net" }
                        ];

                        Bus bus1 = await busController.getBus(bus[0]); 
                    
                        Bus bus2 = await busController.getBus(bus[1]); 
                        
                        Bus bus3 = await busController.getBus(bus[2]);

                        print("buses : ");
                        print(bus1.toString());
                        print(bus2.toString());
                        print(bus3.toString());
                        print("---------------------------------------------");

                        LocationModel loc1 = await locationController.getLocation(bus[0]);
                        GeoPoint g1 = GeoPoint(
                          latitude: double.parse(loc1.lat), 
                          longitude: double.parse(loc1.lon)
                        );

                        LocationModel loc2 = await locationController.getLocation(bus[1]);
                        GeoPoint g2 = GeoPoint(
                          latitude: double.parse(loc2.lat), 
                          longitude: double.parse(loc2.lon)
                        );

                        LocationModel loc3 = await locationController.getLocation(bus[2]);
                        GeoPoint g3 = GeoPoint(
                          latitude: double.parse(loc3.lat), 
                          longitude: double.parse(loc3.lon)
                        );

                        print("locations done");

                        // dureeBusDepart = Duration(seconds: roadInfo.duration!.round()).inMinutes.round().toString();
                        // distBusDepart = roadInfo.distance!.toStringAsFixed(1).toString();
                        //
                        print("goinng to road infos ");
                        RoadInfo roadInfo1 = await controller!.drawRoad( 
                          g1, 
                          gd,
                          roadType: RoadType.car,
                        ); 
                        print("Road infos done ");


                        RoadInfo roadInfo2 = await controller!.drawRoad( 
                          g2, 
                          gd,
                          roadType: RoadType.car,
                        ); 

                        RoadInfo roadInfo3 = await controller!.drawRoad( 
                          g3, 
                          gd,
                          roadType: RoadType.car,
                        ); 

                        double dur1 = roadInfo1.duration!;
                        double dist1 = roadInfo1.distance!;

                        print("dur 1 $dur1 / $dist1");

                        double dur2 = roadInfo2.duration!;
                        double dist2 = roadInfo2.distance!;

                        print("dur 2 $dur2 / $dist2");

                        double dur3 = roadInfo3.duration!;
                        double dist3 = roadInfo3.distance!;

                        print("dur 3 $dur3 / $dist3");

                        List<double> eta = [
                          dur1,
                          dur2,
                          dur3
                        ];

                        Map<String, dynamic> infosBus1 = {
                          "bus" : bus1,
                          "loc" : loc1,
                          "duration" : dur1,
                          "distance" : dist1,
                        };

                        Map<String, dynamic> infosBus2 = {
                          "bus" : bus2,
                          "loc" : loc2,
                          "duration" : dur2,
                          "distance" : dist2,
                        };

                        Map<String, dynamic> infosBus3 = {
                          "bus" : bus3,
                          "loc" : loc3,
                          "duration" : dur3,
                          "distance" : dist3,
                        };

                       

                        print("ETA: ");
                        print(eta.toString());

                        eta.sort();

                        print("ETA sorted: ");
                        print(eta.toString());

                        List<Map<String, dynamic>> busesData = [];

                        for (double element in eta) {
                          if (element == dur1) {
                            busesData.add(infosBus1);
                          }

                          if (element == dur2) {
                            busesData.add(infosBus2);
                          }

                          if (element == dur3) {
                            busesData.add(infosBus3);
                          }
                        }


                        RoadInfo trip = await controller!.drawRoad( 
                          gd,
                          gf, 
                          roadType: RoadType.car,
                        ); 


                        double dur = trip.duration!;
                        double dist = trip.distance!;
                       
                        Map<String, dynamic> tripData = {
                          "depart" : widget.data['depart'],
                          "dest" : dests[value], 
                          "duration" : dur,
                          "distance" : dist
                        };

                        print(tripData.toString());
    
                   
                        setState(() {
                          loading = false;
                        });

                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => BusList(
                            busesData: busesData,
                            tripData: tripData,
                          )),
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