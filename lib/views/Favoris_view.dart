import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/ScanStop/StartStop.dart';
import 'package:busify_voyageur/widgets/Loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavorisView extends StatefulWidget {
  SharedPreferences prefs;
  FavorisView({required this.prefs});

  @override
  State<FavorisView> createState() => _FavorisViewState();
}

class _FavorisViewState extends State<FavorisView> {

  List<Map<String, dynamic>> favoris = [
    {
      "arret" : "Vieux Kouba",
      "id" : 326421421,
      "fav" : true
    },

    {
      "arret" : "Fréres El Selami",
      "id" : 5394260858,
      "fav" : true
    },

  ];

  NodeController nodeController = NodeController();

  bool loading = false;

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20 ),
            child: Column(
              children: [
                Text(
                  "Mes arrêts favoris",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                
                const SizedBox(height: 10,),

                widget.prefs.getStringList("favs") == null 
                ? Padding(
                  padding: const EdgeInsets.all(10),
                  child: Text(
                    "Vous n'avez pas encore d'arrêt favoris",
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                )
                : loading ? 
                const SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(child: Loading())
                ) :
                SizedBox(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: favoris.length,
                    itemBuilder: ( BuildContext ctx, index){
                      return Card(
                        child: ListTile(
                          leading: IconButton(
                            icon: Icon(
                              CupertinoIcons.location_fill,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: () async {
                              setState(() {
                              loading = true;
                            });

                            Node arret = await nodeController.getNodeOSM(favoris[index]["id"]).whenComplete((){
                              Future.delayed(
                                const Duration(seconds: 1),
                                (){
                                  setState(() {
                                    loading = false;
                                  });
                                }
                              );
                            });

                            Map<String, dynamic> depart = arret.toJson(arret) as Map<String, dynamic> ;


                            Map<String, dynamic> stop = {
                              "ligne" : 7996451,
                              "depart" : depart
                            };

                            // ignore: use_build_context_synchronously
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => StartStop(data: stop) ),
                              // (Route<dynamic> route) => false,
                            );
                            }, 
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              CupertinoIcons.delete,
                              color: Theme.of(context).primaryColor,
                            ),
                            onPressed: (){
                              showCupertinoDialog(
                              context: context,
                              builder: (context) {
                                return CupertinoAlertDialog(
                                  title: const Text("Attention !"),
                                  content: Text("Voulez vous vraiment supprimer l'arret -${favoris[index]["arret"] as String}- de vors favoris ?"),
                                  actions: [

                                    CupertinoDialogAction(
                                      child: Text(
                                        "Oui",
                                        style: TextStyle(color: Theme.of(context).primaryColor),
                                      ),
                                      onPressed: (){ 
                                        Navigator.pop(context);
                                      }
                                    ),

                                    CupertinoDialogAction(
                                      child: Text(
                                        "Non",
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
                            },
                          ),
                          title: Text(
                            favoris[index]["arret"] as String,
                            style: Theme.of(context).textTheme.bodyMedium ,
                          ),
                      
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),        ),
      ),
    );
  }
}