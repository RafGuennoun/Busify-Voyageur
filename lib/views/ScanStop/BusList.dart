import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/ScanStop/ResultETA.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BusList extends StatefulWidget {
  final List<Map<String, dynamic>> busesData;
  final Map<String, dynamic> tripData;
  const BusList({ required this.busesData, required this.tripData });

  @override
  State<BusList> createState() => _BusListState();
}

class _BusListState extends State<BusList> {

  

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Liste des bus"),
          centerTitle: true,
        ),

        body: SizedBox(
          width: width,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Liste des bus disponibles :",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 20,),

                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.busesData.length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 5),
                        child: InkWell(
                          onTap: (){


                            Node dep = widget.tripData["depart"];
                            Node dest = widget.tripData["dest"];

                            Map<String, dynamic> data = {
                              "depart" : dep,
                              "dest" : dest,
                              "bus" : {
                                "webId" : "https://bus1.solidcommunity.net"
                              }
                            };


                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ResultETA(data: data)),
                            );

                          },

                          child: Card(
                            // child: Text((widget.busesData[index]['bus'] as Bus).toString()),
                            child: Column(
                              children: [
                                ListTile(
                                  title: Text(
                                    (widget.busesData[index]['bus'] as Bus).name,
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  subtitle: Text(
                                    "${(widget.busesData[index]['bus'] as Bus).name}.solidcommunity.net",
                                  ),
                                  leading: Icon(
                                    CupertinoIcons.bus,
                                    color: Theme.of(context).primaryColor
                                  ),
                        
                                ),
                        
                                ListTile(
                                  title: Text(
                                    '''${Duration(
                                      seconds: (widget
                                      .busesData[index]["duration"] 
                                      as double
                                      ).round() 
                                    ).inMinutes.toString()} min ''',
                                    style: Theme.of(context).textTheme.titleMedium,
                                  ),
                                  // subtitle: Text(
                                  //   '''${Duration(
                                  //     seconds: (widget
                                  //     .busesData[index]["duration"] 
                                  //     as double
                                  //     ).round() 
                                  //   ).inSeconds.toString()} secondes ''',
                                  // ),
                                  leading: Icon(
                                    CupertinoIcons.timer,
                                    color: Theme.of(context).primaryColor
                                  ),
                                ),
                        
                              ],
                            ),
                          ),
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