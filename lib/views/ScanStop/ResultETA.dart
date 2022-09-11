import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/ScanStop/CounterPage.dart';
import 'package:busify_voyageur/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class ResultETA extends StatefulWidget {
  final Map<String, dynamic> data;
  const ResultETA({required this.data});

  @override
  State<ResultETA> createState() => _ResultETAState();
}

class _ResultETAState extends State<ResultETA> {

  Future<LocationModel>? busLoc;
  LocationController locController = LocationController();

  MapController? controller ;

  bool bus = false;
  bool arr = false;
  bool show = false;
  bool reverse = false;
  
  @override
  void initState() {
    super.initState();
    busLoc = locController.getLocation(widget.data['bus']);
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
        latitude: (widget.data['depart'] as Node).lat, 
        longitude: (widget.data['depart'] as Node).lon
      ),
    
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  String dureeBusDepart = "";
  String distBusDepart = "";
  
  String dureeDepDest = "";
  String distDepDest = "";


  MarkerIcon markerDepart = const MarkerIcon(
    icon: Icon(
      CupertinoIcons.location_solid,
      color: Colors.red,
    ),
  );

  MarkerIcon markerDest = const MarkerIcon(
    icon: Icon(
      CupertinoIcons.location_fill,
      color: Colors.green,
      size: 100,
    ),
  );

  MarkerIcon markerBus = const MarkerIcon(
    icon: Icon(
      CupertinoIcons.bus,
      color: Colors.red,
      size: 100,
    ),
  );
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Temps d'arrivé"),
        centerTitle: true,
        actions: [

          IconButton(
            icon: const Icon(CupertinoIcons.chevron_right_2),
            onPressed: (){
              if (dureeBusDepart.isEmpty) {
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text("Oups !"),
                      content: const Text("Cliquez d'abord sur BUS pour voir le temps d'arrivée."),
                      actions: [

                        CupertinoDialogAction(
                          child: Text(
                            "Retour",
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
                
                Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => CounterPage(
                  min: int.parse(dureeBusDepart),
                ))
              );
            }
            
            }, 
          ),

          
        ],
      ),
      
      body: SizedBox(
        width: width,
        height: height,
        child: FutureBuilder(
          future: busLoc,
          builder: ( context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: Loading()
              );
            } else if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Center(
                  child: Column(
                    children: [
                      const Text('Error'),

                      const SizedBox(height: 5,),

                      Text(snapshot.error.toString())
                    ],
                  )
                );
              } else if (snapshot.hasData) {

                // ! C'est ici que ca se passe

                LocationModel busLoc = snapshot.data as LocationModel;

                Node depart = widget.data['depart'] as Node;
                Node dest = widget.data['dest'] as Node;

                // ! Depart ____________________________________________________________
                GeoPoint geoDepart = GeoPoint(
                  latitude: depart.lat, 
                  longitude: depart.lon
                );
             
                // ! ___________________________________________________________________
                
                // ! Dest ______________________________________________________________
                GeoPoint geoDest = GeoPoint(
                  latitude: dest.lat, 
                  longitude: dest.lon
                );
                // ! ___________________________________________________________________

                // ! Bus _______________________________________________________________
                GeoPoint geoBus = GeoPoint(
                  latitude: double.parse(busLoc.lat), 
                  longitude: double.parse(busLoc.lon)
                );
                // ! ___________________________________________________________________

              

                return Stack(
                  children: [

                    SizedBox(
                      width: width,
                      height: height,
                      child: OSMFlutter( 
                        controller: controller!,
                        trackMyPosition: false,
                        initZoom: 16,
                        minZoomLevel: 14,
                        maxZoomLevel: 17,
                        stepZoom: 1.0,
                        staticPoints: [
                        StaticPositionGeoPoint(
                          "Node", 
                          const MarkerIcon(
                            icon: Icon(
                              CupertinoIcons.location_solid,
                              color: Colors.blue,
                              size: 100,
                            ),
                          ), 
                          [ 
                            geoDepart,
                          ]
                        )
                      ],
                      ),
                    ),

                    Container(
                      alignment: Alignment.topCenter,
                      child: SizedBox(
                        // color: Theme.of(context).primaryColor,
                        height: 65,
                        child: Row(
                          children: [
                            
                            // ! BUS
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 60,
                                child: Card(
                                  color: bus ? Colors.red : arr ? Colors.grey : Colors.grey ,
                                  child: ListTile(
                                    title: Text(
                                      "Bus",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.light 
                                        ?Colors.white
                                        : Colors.black87,
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    leading: Icon(
                                      CupertinoIcons.bus,
                                      color: Theme.of(context).brightness == Brightness.light 
                                      ?Colors.white
                                      : Colors.black87,
                                    ),
                                    onTap: () async {

                                      if (!show) {
                                        setState(() {
                                          show = true;
                                        });
                                      }

                                      if (!bus) {
                                        setState(() {
                                          bus = true;
                                          arr = false;
                                        });
                                        
                                        await controller!.addMarker(geoBus, markerIcon: markerBus);

                                      }

                                      setState(() {
                                        reverse = true;
                                      });

                                      RoadInfo roadInfo = await controller!.drawRoad( 
                                        geoBus,
                                        geoDepart,
                                        roadType: RoadType.car,
                                        roadOption: const RoadOption(
                                            roadWidth: 10,
                                            roadColor: Colors.red,
                                            showMarkerOfPOI: false,
                                            zoomInto: true,
                                        ),
                                      );

                                      setState(() {
                                        dureeBusDepart = Duration(seconds: roadInfo.duration!.round()).inMinutes.round().toString();
                                        distBusDepart = roadInfo.distance!.toStringAsFixed(1).toString(); 
                                      });
                                      print("${roadInfo.distance}km");
                                      print("${roadInfo.duration}sec");

                                    },
                                  )
                                ),
                              )
                            ),

                            const SizedBox(width: 5,),
                      
                            // ! DEST
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 60,
                                child: Card(
                                  color: arr ? Colors.green : bus ? Colors.grey : Colors.grey,
                                  child: ListTile(
                                    title: Text(
                                      "Voyage",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.light 
                                        ?Colors.white
                                        : Colors.black87,
                                        fontFamily: 'Poppins',
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    leading: Icon(
                                      CupertinoIcons.location_fill,
                                      color: Theme.of(context).brightness == Brightness.light 
                                      ?Colors.white
                                      : Colors.black87,
                                    ),
                                    onTap: () async {

                                       if (!show) {
                                        setState(() {
                                          show = true;
                                        });
                                      }

                                      if (!arr) {
                                        setState(() {
                                          arr = true;
                                          bus = false;
                                        });
                                      }

                                      setState(() {
                                        reverse = false;
                                      });

                                      await controller!.addMarker(geoDest, markerIcon: markerDest);

                                      RoadInfo roadInfo = await controller!.drawRoad( 
                                        geoDepart,
                                        geoDest,
                                        roadType: RoadType.car,
                                        roadOption: const RoadOption(
                                            roadWidth: 10,
                                            roadColor: Colors.green,
                                            showMarkerOfPOI: false,
                                            zoomInto: true,
                                        ),
                                      );


                                      setState(() {
                                        dureeDepDest = Duration(seconds: roadInfo.duration!.round()).inMinutes.round().toString();
                                        distDepDest = roadInfo.distance!.toStringAsFixed(1).toString(); 
                                      });

                                      print("${roadInfo.distance}km -----------------------------------");
                                      print("${roadInfo.duration}sec");

                                    },
                                  )
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),

                    !show ? const Text("") 
                    : Container(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        height: 80,
                        child: Row(
                          children: [
                            
                            // ! Temps
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 75,
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: ListTile(
                                    title: Text(
                                      reverse 
                                      ? "$dureeBusDepart min"
                                      : "$dureeDepDest min",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.light 
                                        ?Colors.white
                                        : Colors.black87,
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Durée",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.light 
                                        ?Colors.white
                                        : Colors.black87,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    leading: Icon(
                                      CupertinoIcons.timer,
                                      color: Theme.of(context).brightness == Brightness.light 
                                      ?Colors.white
                                      : Colors.black87,
                                    ),
                                  )
                                ),
                              )
                            ),

                            const SizedBox(width: 5,),
                      
                            // ! Distance
                            Expanded(
                              flex: 1,
                              child: SizedBox(
                                height: 75,
                                child: Card(
                                  color: Theme.of(context).primaryColor,
                                  child: ListTile(
                                    title: Text(
                                      reverse ? "$distBusDepart km"
                                      : "$distDepDest km",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.light 
                                        ?Colors.white
                                        : Colors.black87,
                                        fontFamily: 'Poppins',
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    subtitle: Text(
                                      "Distance",
                                      style: TextStyle(
                                        color: Theme.of(context).brightness == Brightness.light 
                                        ?Colors.white
                                        : Colors.black87,
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal
                                      ),
                                    ),
                                    leading: Icon(
                                      Icons.roundabout_right_outlined,
                                      color: Theme.of(context).brightness == Brightness.light 
                                      ?Colors.white
                                      : Colors.black87,
                                    ),
                                  )
                                ),
                              )
                            ),
                          ],
                        ),
                      ),
                    )

                  ],
                );

              } else {
                return const Text('Empty data');
              }
            } else {
              return Text('State: ${snapshot.connectionState}');
            }
          },
        ),
      ),
    );
  }
}