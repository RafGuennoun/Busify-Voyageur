import 'package:busify_voyageur/models/Node_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class StopLocation extends StatefulWidget {
  final Node arret;
  const StopLocation({required this.arret});

  @override
  State<StopLocation> createState() => _StopLocationState();
}

class _StopLocationState extends State<StopLocation> {

  MapController? controller ;
  // MapController controller = MapController(
  //   initMapWithUserPosition: false,
  //   // initPosition: GeoPoint(latitude: 36.71703716216408, longitude: 4.04339239415392),
  //   initPosition: GeoPoint(latitude: 36.709364979370584, longitude: 4.053224426128724),
   
  // );

  @override
  void initState() {
    super.initState();
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
        latitude: widget.arret.lat, 
        longitude: widget.arret.lon
      ),
    
    );
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
        centerTitle: true,
      ),

      body: Stack(
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
                      CupertinoIcons.bus,
                      color: Colors.blue,
                      size: 100,
                    ),
                  ), 
                  [ 
                    GeoPoint(
                      latitude: widget.arret.lat, 
                      longitude: widget.arret.lon
                    )
                  ]
                )
              ],
            ),
          ),

          
          Container(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: ListTile(
                  onTap: () {

                    controller!.goToLocation(GeoPoint(
                      latitude: widget.arret.lat, 
                      longitude: widget.arret.lon
                    ));
                  },
                  title: Text(
                    widget.arret.name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    "ID : ${widget.arret.id.toString()}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  leading: Icon(
                    CupertinoIcons.bus,
                    color: Theme.of(context).primaryColor
                  ),
                ),
              ),
            ),
          ),

        ],
      ),

      
    );
  }
}