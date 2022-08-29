import 'package:busify_voyageur/views/Favoris_view.dart';
import 'package:busify_voyageur/views/Home_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {



  List<Widget> pages = [
    const HomeView(),
    const FavorisView(),
  ];

  int index = 0;
  @override
  Widget build(BuildContext context) {

    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Busify"),
          centerTitle: true,
          elevation: 0,
        ),
    
        body: Center(child: pages[index],),

        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          child: const Icon(CupertinoIcons.camera_viewfinder),
          onPressed: () {
            print("Go scan");
            // Navigator.push(
            //   context, 
            //   MaterialPageRoute(builder: (context) => const ScanPage())
            // );

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
                
                const SizedBox(height: 15,),
                
                // Logo
                Container(
                  width: 150,
                  height: 150,
                  color: Theme.of(context).primaryColor,
                ),

                const SizedBox(height: 20,),

                // Username
                SizedBox(
                  child: Center(
                    child: Text(
                      "User",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ),

                const SizedBox(height: 10,),
              
                const Divider(),

                // Jeu
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.gamecontroller_fill,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Jeu de scan",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        
                      },
                    ),
                  ),
                ),
                
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
                        CupertinoIcons.paintbrush_fill,
                        color: Theme.of(context).primaryColor,
                        size: 35,
                      ),
                      title: Text(
                        "Theme",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(builder: (context) => const ThemeSelectorPage())
                        // );
                      },
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

                
              ],
            )
          ),
        ),
    
      ),
    );
  }
}