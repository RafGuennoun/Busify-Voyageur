import 'dart:convert';

import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Maps/StopLocation';
import 'package:busify_voyageur/views/ScanStop/ResultETA.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Destination"),
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
                  child: const Text("Trouver un bus"),
                  onPressed: (){

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

                      Map<String, dynamic> data = {
                        "depart" : widget.data["depart"],
                        "dest" : dest,
                        "bus" : {
                          "webId" : "https://bus1.solidcommunity.net"
                        }
                      };

                      String today = DateFormat.yMd().format(DateTime.now());
                      String hour = DateFormat("HH:mm:ss").format(DateTime.now());

                      Map<String, dynamic> voyage = {
                        "depart" : (widget.data["depart"] as Node).name.toString(),
                        "dest" : dest!.name.toString(),
                        "date" : today,
                        "hour" : hour
                      };

                      prefs!.setString("lastTrip", jsonEncode(voyage));

                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => ResultETA(data: data)),
                        (Route<dynamic> route) => false,
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
    );
  }
}