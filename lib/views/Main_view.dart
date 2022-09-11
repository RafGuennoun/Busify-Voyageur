import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:busify_voyageur/views/Emulator/Emulator.dart';
import 'package:busify_voyageur/views/Favoris_view.dart';
import 'package:busify_voyageur/views/Historique.dart';
import 'package:busify_voyageur/views/Home_view.dart';
import 'package:busify_voyageur/views/MesArrets.dart';
import 'package:busify_voyageur/views/ScanPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainView extends StatefulWidget {
  SharedPreferences prefs;
  MainView({required this.prefs});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {



  // List<Widget> pages = [
  //   HomeView(prefs: prefs,),
  //   const FavorisView(),
  // ];

  bool darkmode = false;
  dynamic savedThemeMode;

  Future getCurrentTheme() async {
    savedThemeMode = await AdaptiveTheme.getThemeMode();
    if (savedThemeMode.toString() == 'AdaptiveThemeMode.dark') {
      print('mode sombre');
      setState(() {
        darkmode = true;
      });
    } else {
      setState(() {
        darkmode = false;
      });
      print('mode clair');
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentTheme();
  }

  int index = 0;
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Busify Voyageur"),
          centerTitle: true,
          elevation: 0,
        ),
    
        body: Center(
          // child: pages[index],
          child: index == 0 
          ? HomeView(prefs: widget.prefs)
          : FavorisView(prefs: widget.prefs,),
        ),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(CupertinoIcons.camera_viewfinder),
          onPressed: () {
            print("Go scan");
            Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => const ScanPage())
            );

          }
        ),
    
        bottomNavigationBar: BottomNavigationBar(
          elevation: 0,
          onTap: ((value) {
            setState(() {
              index = value;
            });
          }),
          currentIndex: index,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_rounded),
              label: "Home"
            ), 
            
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.heart_solid),
              label: "Favoris"
            ),
            
          ] 
        ),
    
        drawer: Drawer(
          child: SizedBox(
            width: width,
            child: ListView(
              shrinkWrap: true,
              children: [
                
                const SizedBox(height: 25,),
                
                // Logo
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.asset("assets/voyageur.png"),
                ),

                const SizedBox(height: 20,),

                // Username
                SizedBox(
                  child: Center(
                    child: Text(
                      widget.prefs.getString('user')!,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
              
                const Divider(),

                // Jeu
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 5),
                //   child: Card(
                //     child: ListTile(
                //       leading: Icon(
                //         CupertinoIcons.gamecontroller_fill,
                //         color: Theme.of(context).primaryColor,
                //         size: 35,
                //       ),
                //       title: Text(
                //         "Jeu de scan",
                //         style: Theme.of(context).textTheme.bodyMedium,
                //       ),
                //       onTap: () {
                        
                //       },
                //     ),
                //   ),
                // ),
                
                // Historique des voyages
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.bookmark_fill,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Historique",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Historique(prefs: widget.prefs,) ),
                        );
                      },
                    ),
                  ),
                ),

                // Mes arrets
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.map_pin_ellipse,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Mes arrêts",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MesArrets(prefs: widget.prefs,) ),
                        );
                      },
                    ),
                  ),
                ),

                const Divider(),

                // Theme
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.moon_fill,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: 
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Mode sombre",
                            style: Theme.of(context).textTheme.bodyMedium,  
                          ),
                          
                          CupertinoSwitch(
                            value: darkmode, 
                            activeColor: Colors.amber,
                            onChanged: (value){
                              print(value);
                              if (value == true) {
                                AdaptiveTheme.of(context).setDark();
                              } else {
                                AdaptiveTheme.of(context).setLight();
                              }
                              setState(() {
                                darkmode = value;
                              });
                            }
                          ),
                        ],
                      ) 
                 
                    ),
                  ),
                ),

                const Divider(),

                // Nous contacter
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.mail_solid,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Nous contacter",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                      },
                    ),
                  ),
                ),

                // A propos
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.info_circle_fill,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "A propos",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                      },
                    ),
                  ),
                ),


                // Testing case
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.perspective,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Emulateur",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const Emulator())
                        );
                      },
                    ),
                  ),
                ),

                
              ],
            )
          ),
        ),
    
      ),
    );
  }
}