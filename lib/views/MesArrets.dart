import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Maps/StopLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MesArrets extends StatefulWidget {
  const MesArrets({Key? key}) : super(key: key);

  @override
  State<MesArrets> createState() => _MesArretsState();
}

class _MesArretsState extends State<MesArrets> {

  List<Map<String, dynamic>> arrets = [
    {
      "arret" : "Vieux Kouba",
      "id" : 326421421,
    },

    {
      "arret" : "Vieux Kouba",
      "id" : 326421421,
    },

    {
      "arret" : "Vieux Kouba",
      "id" : 326421421,
    },

    {
      "arret" : "Vieux Kouba",
      "id" : 326421421,
    },
   
  ];

  NodeController nodeController = NodeController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mes arrêts"),
          centerTitle: true,
        ),

        body: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: Column(
              children: [
                Text(
                  "Liste des arrêts scannées",
                  style: Theme.of(context).textTheme.titleMedium,
                ),

                const SizedBox(
                  height: 10,
                ),

                ListView.builder(
                  shrinkWrap: true,
                  itemCount: arrets.length,
                  itemBuilder: (BuildContext ctx, index){
                    return Card(
                      child: ListTile(
                        leading: IconButton(
                          icon: Icon(
                            CupertinoIcons.location_solid,
                            color: Theme.of(context).primaryColor,
                          ),
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });

                            Node arret = await nodeController.getNodeOSM(arrets[index]["id"]).whenComplete((){
                              Future.delayed(
                                const Duration(seconds: 1),
                                (){
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              );
                            });

                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StopLocation(arret: arret) ),
                              // (Route<dynamic> route) => false,
                            );
                          }, 
                        ),
                        title: Text(
                          arrets[index]["arret"] as String,
                          style: Theme.of(context).textTheme.bodyMedium ,
                        ),
                    
                      ),
                    );
                  }
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}