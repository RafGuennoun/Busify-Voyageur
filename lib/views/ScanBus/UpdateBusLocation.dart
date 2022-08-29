
import 'dart:convert';

import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/views/Main_view.dart';
import 'package:busify_voyageur/widgets/SimpleAlertDialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UpdateBusLocation extends StatefulWidget {
  final Bus bus;
  final LocationModel loc;
  final Map<String, dynamic> data;
  const UpdateBusLocation({required this.bus, required this.loc, required this.data});

  @override
  State<UpdateBusLocation> createState() => _UpdateBusLocationState();
}

class _UpdateBusLocationState extends State<UpdateBusLocation> {

  LocationController locController = LocationController();

  final _nomController = TextEditingController();
  final _marqueController = TextEditingController();
  final _matController = TextEditingController();

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

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height= MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crowdsourcing"),
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
      
                
                // NOM
                TextField(
                  controller: _nomController,
                  readOnly: read,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(CupertinoIcons.bus),
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
                    prefixIcon: const Icon(CupertinoIcons.bookmark_fill),
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
                    prefixIcon: const Icon(CupertinoIcons.number),
                    labelText: "Matricule",
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    hintStyle: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),

                const SizedBox(height: 45,),

                loading  
                ? const SizedBox(
                  width: 50,
                  height: 50,
                  child: Center(child: CircularProgressIndicator()),
                )
                : Column(
                  children: [
                    CupertinoButton(
                      color: Theme.of(context).primaryColor,
                      child: const Text("Mettre à jour"), 
                      onPressed: (){

                        setState(() {
                          loading = true;
                        });

                        int? nbScans = prefs!.getInt("nbScans");

                        if (nbScans == null) {
                          prefs!.setInt("nbScans", 1);
                        } else {
                          int nb = nbScans + 1;
                          prefs!.setInt("nbScans", nb);
                          
                        }

                        Map<String, dynamic> busData = {
                          "nom" : widget.bus.name,
                          "marque" : widget.bus.marque,
                          "matricule" : widget.bus.matricule
                        };

                        prefs!.setString("lastBus", jsonEncode(busData));
                        
                        Map<String, dynamic> json = {
                          "login" : widget.data['login'],
                          "webId" : widget.data['webId'],
                          "location" : {
                            "lat" : widget.loc.lat,
                            "lon" : widget.loc.lon
                          }
                        };

                        locController.setLocation(json).whenComplete((){
                          Future.delayed(
                            const Duration(seconds: 1),
                            (){
                              setState(() {
                                loading = false;
                              });
                            }
                          );
                        });

                        showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: const Text("Merci !"),
                              content: const Text("Vous avez mis à jour la localisation de ce bus."),
                              actions: [

                                CupertinoDialogAction(
                                  child: Text(
                                    "Retour",
                                    style: TextStyle(color: Theme.of(context).primaryColor),
                                  ),
                                  onPressed: (){ 
                                    Navigator.pushAndRemoveUntil(
                                      context, 
                                      MaterialPageRoute(builder: (context) => const MainView()), 
                                      (route) => false
                                    );
                                  }
                                ),
                              ],
                            );
                          },
                        );
                      }
                    ),

                    const SizedBox(height: 10,),

                    TextButton(
                      child: const Text("Retour"),
                      onPressed: (){
                        Navigator.pushAndRemoveUntil(
                          context, 
                          MaterialPageRoute(builder: (context) => const MainView()), 
                          (route) => false
                        );
                      }, 
                    )
                  ],
                ),

               
              
              ],
            ),
          ),
        ),
      )
    );
  }
}