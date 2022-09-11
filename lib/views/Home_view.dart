
import 'dart:convert';

import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Maps/StopLocation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  SharedPreferences prefs;
  HomeView({required this.prefs});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  NodeController nodeController = NodeController();
  

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;


    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.light ? const Color(0xfff5f5f5) :null,
      body: SingleChildScrollView(
        child: SizedBox(
          width: width,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children:  [
               
                // const Game(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Jeu Busify",
                        style: Theme.of(context).textTheme.titleMedium ,
                      ),
                    ),

                    const SizedBox(height: 10,),

                    Card(
                      child: Column(
                        children:  [
                          ListTile(
                            leading: Icon(
                              CupertinoIcons.game_controller_solid,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              "Niveau 1",
                              style: Theme.of(context).textTheme.titleMedium ,
                            ),
                          ),

                          ListTile(
                            leading: Icon(
                              Icons.qr_code_scanner_rounded,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              // "25 scans",
                              widget.prefs.getInt('nbScans') == null ?
                              "0 scans" :
                              "${widget.prefs.getInt('nbScans')} scans",
                              style: Theme.of(context).textTheme.titleMedium 
                            ),
                            subtitle: Text(
                              "Objectif 100 scans",
                              style: Theme.of(context).textTheme.bodyMedium 
                            ),
                          ),

                          ListTile(
                            leading: Icon(
                              CupertinoIcons.suit_diamond_fill,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: SizedBox(
                              height: 25,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: LiquidLinearProgressIndicator(
                                  value: widget.prefs.getInt('nbScans') == null 
                                  ? 0 
                                  : (widget.prefs.getInt('nbScans') as int )/100, 
                                  // value: 0.25, 
                                  valueColor: AlwaysStoppedAnimation(Theme.of(context).primaryColor), 
                                  backgroundColor: Theme.of(context).brightness == Brightness.light 
                                  ? Colors.white
                                  : Colors.grey[800], 
                                  borderColor: Theme.of(context).primaryColor,
                                  borderWidth: 2,
                                  borderRadius: 8,
                                  direction: Axis.horizontal, 
                                  // center: const Text("Loading..."),
                                  ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),

                const SizedBox(height: 15,),

                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    "Plus d'informations",
                    style: Theme.of(context).textTheme.titleMedium ,
                  ),
                ),
                Container(),
                const SizedBox(height: 10,),

                // ! Dernier voyage
                Card(
                  child: Column(
                    children: [
                      
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.ticket,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Dernier voyage",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      widget.prefs.getString("lastTrip") == null 
                      ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(
                          "Vous n'avez pas encore fait de voyage",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      )
                      : Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              CupertinoIcons.calendar,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              "07/08/2022",
                              style: Theme.of(context).textTheme.bodyMedium ,
                            ),
                          ),

                          ListTile(
                            leading: Icon(
                              CupertinoIcons.time,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              "13:46",
                              style: Theme.of(context).textTheme.bodyMedium ,
                            ),
                          ),

                          ListTile(
                            leading: Icon(
                              CupertinoIcons.location_solid,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              "Fréres el selami",
                              style: Theme.of(context).textTheme.bodyMedium ,
                            ),
                          ),

                          ListTile(
                            leading: Icon(
                              CupertinoIcons.location_fill,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                              "Jardin d'essai",
                              style: Theme.of(context).textTheme.bodyMedium ,
                            ),
                          ),
                        ],
                      ),

                      
                    ],
                  ),
                ),

                const SizedBox(height: 5,),

                // ! Dernier bus
                Card(
                  child: Column(
                    children: [
                      
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.bus,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Dernier Bus",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                      // widget.prefs.getString("lastBus") == null ?
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(
                          "Vous n'avez pas encore participé dans un bus",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      )
                      // : Column(
                      //   children: [
                      //     ListTile(
                      //       leading: Icon(
                      //         CupertinoIcons.shield_fill,
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //       title: Text(
                      //         jsonDecode(widget.prefs.getString('lastBus')!)["nom"],
                      //         style: Theme.of(context).textTheme.bodyMedium ,
                      //       ),
                      //     ),

                      //     ListTile(
                      //       leading: Icon(
                      //         CupertinoIcons.shield_fill,
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //       title: Text(
                      //         jsonDecode(widget.prefs.getString('lastBus')!)["marque"],
                      //         style: Theme.of(context).textTheme.bodyMedium ,
                      //       ),
                      //     ),

                      //     ListTile(
                      //       leading: Icon(
                      //         CupertinoIcons.number,
                      //         color: Theme.of(context).primaryColor,
                      //       ),
                      //       title: Text(
                      //         jsonDecode(widget.prefs.getString('lastBus')!)["matricule"],
                      //         style: Theme.of(context).textTheme.bodyMedium ,
                      //       ),
                      //     ),

                      //   ],
                      // ),
                    ],
                  ),
                ),

                const SizedBox(height: 5,),

                // ! Dernier arret
                Card(
                  child: Column(
                    children: [

                      
                      
                      ListTile(
                        leading: Icon(
                          CupertinoIcons.map_pin_ellipse,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Dernier Arret",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),

                      widget.prefs.getString("lastStop") == null 
                      ? Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
                        child: Text(
                          "Vous n'avez pas encore scanné un code QR d'un arrêt de bus",
                          style: Theme.of(context).textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      )
                      : Column(
                        children: [
                          ListTile(
                            leading: Icon(
                              CupertinoIcons.location_solid,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                             jsonDecode(widget.prefs.getString("lastStop")!)['nom'],
                              style: Theme.of(context).textTheme.bodyMedium ,
                            ),

                            trailing: IconButton(
                              icon:Icon(
                                CupertinoIcons.location_fill,
                                color: Theme.of(context).primaryColor,
                              ),
                              onPressed: () async {

                                Node arret = await nodeController.getNodeOSM(jsonDecode(widget.prefs.getString("lastStop")!)['id']);

                                // ignore: use_build_context_synchronously
                                Navigator.push(
                                  context, 
                                  MaterialPageRoute(builder: (context) => StopLocation(arret: arret))
                                );
                              }, 
                            ),

                          ),
                        ],
                      ),

                    ],
                  ),
                ),

                const SizedBox(height: 25,),

              ],
              
            ),
          ),
        ),
      ),
    );
  }
}