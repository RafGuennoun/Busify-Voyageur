import 'dart:convert';
import 'dart:io';

import 'package:busify_voyageur/controllers/Bus_controller.dart';
import 'package:busify_voyageur/controllers/Location_controller.dart';
import 'package:busify_voyageur/controllers/Node_controller.dart';
import 'package:busify_voyageur/models/Bus_model.dart';
import 'package:busify_voyageur/models/Location_model.dart';
import 'package:busify_voyageur/models/Node_model.dart';
import 'package:busify_voyageur/views/Main_view.dart';
import 'package:busify_voyageur/views/ScanBus/UpdateBusLocation.dart';
import 'package:busify_voyageur/views/ScanStop/StartStop.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ScanPage extends StatefulWidget {
  const ScanPage({ Key? key }) : super(key: key);

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  
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
  

  final qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Barcode? barcode;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  void reassemble() async {

    super.reassemble();

    if (Platform.isAndroid) {
      await controller!.pauseCamera();
    }
    await controller!.resumeCamera();
    // controller!.resumeCamera();
  }

  LocationModel? loc;
  LocationController locController = LocationController();
  BusController busController = BusController();

    
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  final bool _isListenLocation = false;
  bool _isGetLocation = false;

  bool loading = false;

  NodeController nodeRepo = NodeController();


  @override
  Widget build(BuildContext context) {
    
    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
    
        appBar: AppBar(
          title: const Text("Scan Page"),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.camera),
              onPressed: () async {
                await controller!.resumeCamera();
              }, 
            )
          ],
        ),

        body: Stack(
          alignment: Alignment.center,
          children: [

            buildQrView(context, width),
    
            Positioned(
              bottom: 15,
              child: buildResult()
            )
          ],
        )
      ),
    );
  }

  Widget buildQrView(BuildContext context, double width) => QRView(
    key: qrKey, 
    onQRViewCreated: onQRViewCreated,
    overlay: QrScannerOverlayShape(
      cutOutSize: width*0.8,
      borderWidth: 10,
      borderLength: 25,
      borderRadius: 15,
      borderColor: Colors.blue
    ),
  );

  Future<void> onQRViewCreated(QRViewController controller) async {

    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream
      .listen((barcode) {
        setState(() {
          this.barcode = barcode; 
        });
      });
  }

    Widget buildResult() => Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white24,
        borderRadius: BorderRadius.circular(15)
      ),
      child: barcode == null ? 
      const Text(
        "Scannez le code",
        maxLines: 3,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16
        ),
      )
      : loading ? const CircularProgressIndicator()
      : ElevatedButton(
        child: const Text("Suivant"),
        onPressed: ()async {

          Map<String, dynamic> data = json.decode(barcode!.code!)  as Map<String, dynamic>; 

          if (data['scan'] == "bus") {
            // ! send location to bus

            _serviceEnabled = await location.serviceEnabled();
            if (!_serviceEnabled!) {
              _serviceEnabled = await location.requestService();
              if (_serviceEnabled!) {
                return;
              }
            } 

            _permissionGranted = await location.hasPermission();
            if (_permissionGranted == PermissionStatus.denied ) {
              _permissionGranted = await location.requestPermission();
              if (_serviceEnabled == PermissionStatus.granted) {
                return;
              }
            } 

            _locationData = await location.getLocation();
            setState(() {
              _isGetLocation = true;
              loading = true;
            });

            loc = LocationModel(
              _locationData!.latitude!.toString(),
             _locationData!.longitude!.toString()
            );


            Map<String, dynamic> pod = {
              'login' : data['qr']['login'],
              'webId' : data['qr']['webId'],
            };


            Map<String, dynamic> webId = {
              "webId" : data['qr']['webId']
            };

            Bus bus = await busController.getBus(webId).whenComplete(() {
              Future.delayed(
                const Duration(seconds: 1),
                (){
                  setState(() {
                    loading = false;
                  });
                }
              );
              
            });

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => UpdateBusLocation(
                bus: bus ,
                loc: loc!,
                data: pod,
              )),
              (Route<dynamic> route) => false,
            );

          } else if (data['scan'] == "stop") {
            // ! Go to scan stop 

            var scan = {
              "scan" : "stop",
              "depart" : 5394260858
            };

            setState(() {
              loading = true;
            });

            Node arret = await nodeRepo.getNodeOSM(data["depart"]).whenComplete((){
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

            prefs!.setString("lastStop", depart.toString());

            // ignore: use_build_context_synchronously
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => StartStop(data: stop) ),
              (Route<dynamic> route) => false,
            );

          }
          else{
            // ! Code QR n'appartient pas a notre application
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: const Text("Oups !"),
                  content: const Text("Ce code QR n'appartient pas a l'application."),
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

        }, 
      )
    ); 

}