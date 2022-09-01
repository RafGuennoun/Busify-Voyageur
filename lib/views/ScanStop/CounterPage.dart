import 'package:busify_voyageur/views/Main_view.dart';
import 'package:busify_voyageur/views/ScanStop/SetupNotif.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_countdown/slide_countdown.dart';

class CounterPage extends StatefulWidget {
  final int min;
  const CounterPage({required this.min});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  
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
  
  bool load = true;
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Compteur"),
          centerTitle: true,
        ),
    
        body: SizedBox(
          width: width,
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
            child: load
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Votre bus arrive dans :'),
                
                const SizedBox(height: 15,),

                SlideCountdownSeparated(
                  height: 50,
                  width: 50,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(15)), 
                    color: Colors.blue
                  ),
                  textStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white
                  ),
                  separatorStyle: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.blue
                  ),
                  duration: const Duration( 
                    // minutes: widget.min,
                    minutes: 0,
                    seconds: 10,
                  ),
                  onDone: (){
                    setState(() {
                      load = false;
                    });
                  },
                ),

                const SizedBox(height: 25,),

                CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  child: const Text("Programmer une notification"), 
                  onPressed: (){
                    print("monte dans le bus");

                    if(widget.min > 2){
                      
                      Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => SetupNotif(
                        min: widget.min,
                      ))
                    );
                    } else{
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text("Oups !"),
                            content: const Text("Votre bus arrive dans moins de deux minutes."),
                            actions: [

                              CupertinoDialogAction(
                                child: Text(
                                  "Retour",
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

                    }
                  }
                ),

                const SizedBox(height: 5,),

                CupertinoButton(
                  child: const Text("Annuler l'attente"), 
                  onPressed: (){
                    print("Annuler l'attente");
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("Attention !"),
                          content: const Text("Voulez vous vraiment annuler l'attente de votre bus ?"),
                          actions: [

                            CupertinoDialogAction(
                              child: Text(
                                "Oui",
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: (){ 
                                Navigator.pushAndRemoveUntil(
                                  context, 
                                  MaterialPageRoute(builder: (context) => MainView(prefs: prefs!,)), 
                                  (route) => false
                                );
                              }
                            ),

                            CupertinoDialogAction(
                              child: Text(
                                "Retour",
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
                  }
                ),

              ],
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Votre bus est normalement arrivé'),
                
                const SizedBox(height: 15,),
              
                CupertinoButton(
                  color: Theme.of(context).primaryColor,
                  child: const Text("Je monte dans le bus"), 
                  onPressed: (){
                    print("monte dans le bus");
                  }
                ),

                const SizedBox(height: 5,),

                CupertinoButton(
                  child: const Text("Annuler"), 
                  onPressed: (){
                    print("Annuler l'attente");
                    showCupertinoDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: const Text("Attention !"),
                          content: const Text("Voulez vous vraiment annuler l'attente de votre bus ?"),
                          actions: [

                            CupertinoDialogAction(
                              child: Text(
                                "Oui",
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: (){ 
                                Navigator.pushAndRemoveUntil(
                                  context, 
                                  MaterialPageRoute(builder: (context) => MainView(prefs: prefs!,)), 
                                  (route) => false
                                );
                              }
                            ),

                            CupertinoDialogAction(
                              child: Text(
                                "Retour",
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
                  }
                ),

              ],
            ),

            
          ),
          
        ),
      ),
    );
  }
}