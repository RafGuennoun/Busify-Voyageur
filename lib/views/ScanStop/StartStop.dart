import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/ScanStop/ChooseDest.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class StartStop extends StatefulWidget {
  final Map<String, dynamic> data;
  const StartStop({required this.data});

  @override
  State<StartStop> createState() => _StartStopState();
}

class _StartStopState extends State<StartStop> {

  MapController? controller ;

  NodeController nodeController = NodeController();
  Future<List<Node>>? nodes;

  @override
  void initState() {
    super.initState();
    nodes = nodeController.buildNodes(widget.data['ligne']);
    controller = MapController(
      initMapWithUserPosition: false,
      initPosition: GeoPoint(
        latitude: Node.fromJson(widget.data['depart']).lat, 
        longitude: Node.fromJson(widget.data['depart']).lon
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
        title: const Text("Arret actuel"),
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
                      latitude: Node.fromJson(widget.data['depart']).lat, 
                      longitude: Node.fromJson(widget.data['depart']).lon
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
                      latitude: Node.fromJson(widget.data['depart']).lat,
                      longitude: Node.fromJson(widget.data['depart']).lon
                    ));
                  },
                  title: Text(
                    Node.fromJson(widget.data['depart']).name,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  subtitle: Text(
                    Node.fromJson(widget.data['depart']).network,
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

          Container(
            alignment: Alignment.bottomCenter,
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
                        child: CircularProgressIndicator()
                      )
                    );

                  } else if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasError) {
                      return const Text('Error');
                    } else if (snapshot.hasData) {
                      // ! C'est ici que ca se passe

                      List<Node> arrets = snapshot.data as List<Node>; 
                      // arrets.remove(Node.fromJson(widget.data['depart']));

                      Map<String, dynamic> data = {
                        "depart" : Node.fromJson(widget.data['depart']), // ! as Node
                        "destinations" : arrets // ! list of Nodes
                      };

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 20),
                        child: Card(
                          child: CupertinoButton(
                            color: Theme.of(context).primaryColor,
                            child: const Text("Choisir la destination"),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ChooseDest(data: data))
                              );
                            }
                          ),
                        ),
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

        ],
      ),

      
    );
  }
}