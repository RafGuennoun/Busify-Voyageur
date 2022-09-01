import 'package:busify_voyageur/services/LocalNotifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';


class SetupNotif extends StatefulWidget {
  final int min;
  const SetupNotif({required this.min});

  @override
  State<SetupNotif> createState() => _SetupNotifState();
}

class _SetupNotifState extends State<SetupNotif> {

  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.initalize();
    super.initState();
  } 

   int _currentValue = 1;

  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Notification"),
          centerTitle : true,
          actions: [
            IconButton(
              icon: const Icon(
                CupertinoIcons.info
              ),
              onPressed: (){
                showCupertinoDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: const Text("Ne ratez pas votre bus"),
                      content: const Text("Choisissez le temps que vous voulez, notre application vous enverra une notification pour vous rappelez que votre bus arrive."),
                      actions: [
    
                        CupertinoDialogAction(
                          child: Text(
                            "Fermer",
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
          ],
        ),
    
        body: SingleChildScrollView(
          child: SizedBox(
            width: width,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
        
                  const SizedBox(height: 10,),
        
                  Card(
                    child: ListTile(
                      leading: Icon(
                        CupertinoIcons.time,
                        color: Theme.of(context).primaryColor,
                      ),
                      title: Text(
                        "Temps restant",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      subtitle: Text(
                        "${widget.min - 2} min",
                        textAlign: TextAlign.justify,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
        
                  const SizedBox(height: 15,),
        
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(
                            CupertinoIcons.bell,
                            color: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            "Me notifier dans :",
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
        
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            NumberPicker(
                              // haptics: true,
                              value: _currentValue,
                              minValue: 1,
                              maxValue: widget.min - 1,
                              onChanged: (value) => setState(() => _currentValue = value),
                            ),
        
                            Text(
                              "minutes",
                              style: Theme.of(context).textTheme.bodyMedium,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 35,),
        
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    child: const Text("Programmer"), 
                    onPressed: ()async {
                      print("current = $_currentValue");
                      await service.showScheduledNotification(
                        id: 0, 
                        title: "Busify", 
                        body: "Votre bus arrive dans $_currentValue minutes, ne le ratez pas.", 
                        seconds: Duration(minutes: _currentValue).inSeconds
                      );
    
                      showCupertinoDialog(
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            title: const Text("Notification programmée"),
                            content: const Text("Une notification vous avertera avant l'arrivée de votre bus."),
                            actions: [
    
                              CupertinoDialogAction(
                                child: Text(
                                  "Retour",
                                  style: TextStyle(color: Theme.of(context).primaryColor),
                                ),
                                onPressed: (){ 
                                  Navigator.pop(context);
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
      ),
    );
  }
}