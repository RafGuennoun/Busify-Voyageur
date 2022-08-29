import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  
  // String? username = prefs!.getString('username');
  
  // Location location = Location();

  bool? _serviceEnabled;
  // PermissionStatus? _permissionGranted;
  // LocationData? _locationData;
  final bool _isListenLocation = false;
  final bool _isGetLocation = false;

  SharedPreferences? prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    initPrefs();
    super.initState();
  }

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
                              "5 scans",
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
                                  value: 0.75, 
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
                          "Bab Ezzouar",
                          style: Theme.of(context).textTheme.bodyMedium ,
                        ),
                      ),

                      ListTile(
                        leading: Icon(
                          CupertinoIcons.location_fill,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Alger centre",
                          style: Theme.of(context).textTheme.bodyMedium ,
                        ),
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

                      ListTile(
                        leading: Icon(
                          CupertinoIcons.shield_fill,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Coaster",
                          style: Theme.of(context).textTheme.bodyMedium ,
                        ),
                      ),

                      ListTile(
                        leading: Icon(
                          CupertinoIcons.shield_fill,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "Toyota",
                          style: Theme.of(context).textTheme.bodyMedium ,
                        ),
                      ),

                      ListTile(
                        leading: Icon(
                          CupertinoIcons.number,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                          "01809 122 15",
                          style: Theme.of(context).textTheme.bodyMedium ,
                        ),
                      ),

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