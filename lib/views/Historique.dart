import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Historique extends StatefulWidget {
  SharedPreferences prefs;
  Historique({required this.prefs});

  @override
  State<Historique> createState() => _HistoriqueState();
}

class _HistoriqueState extends State<Historique> {

  List voyages = [
    {
      "date" : "07/08/2022",
      "heure" : "13:46",
      "dep" : "Fréres El Selami",
      "dest" : "Jardin d'essai",
    },

    {
      "date" : "29/07/2022",
      "heure" : "09:21",
      "dep" : "Vieux Kouba",
      "dest" : "Place des martyrs",
    },

    // {
    //   "date" : "20/02/2022",
    //   "heure" : "15:31",
    //   "dep" : "Fréres El Selami",
    //   "dest" : "Jardin d'essai",
    // },

 
  ];
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique"),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
              child: Column(
                children: [
                  Text(
                    "Liste des Voyages",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
      
                  const SizedBox(
                    height: 10,
                  ),
      
                  widget.prefs.getStringList("trips") == null 
                  ? Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Vous n'avez pas encore fait de voyage",
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  )
                  : ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: voyages.length,
                    itemBuilder: (BuildContext ctx, index){
                      return  Card(
                        child: Column(
                          children: [
                            
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.ticket,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                "Voyage",
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.calendar,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                voyages[index]["date"],
                                style: Theme.of(context).textTheme.bodyMedium ,
                              ),
                            ),
      
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.time,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                voyages[index]["heure"],
                                style: Theme.of(context).textTheme.bodyMedium ,
                              ),
                            ),
      
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.location_solid,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                voyages[index]["dep"],
                                style: Theme.of(context).textTheme.bodyMedium ,
                              ),
                            ),
      
                            ListTile(
                              leading: Icon(
                                CupertinoIcons.location_fill,
                                color: Theme.of(context).primaryColor,
                              ),
                              title: Text(
                                voyages[index]["dest"],
                                style: Theme.of(context).textTheme.bodyMedium ,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  )
                ],
              ),
            ),
          ),
      ),
    );
  }
}