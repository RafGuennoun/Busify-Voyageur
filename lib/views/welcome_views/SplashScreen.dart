
import 'dart:async';
import 'package:busify_voyageur/views/Main_view.dart';
import 'package:busify_voyageur/views/welcome_views/WelcomePage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  Future check() async {
    
    // instance
    SharedPreferences prefs = await SharedPreferences.getInstance();
    
    String? key = prefs.getString('user');
    
    if (key==null) {
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const WelcomePage()));
    } else {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainView(prefs: prefs,)));
    }
  }

  @override
  void initState() {
    super.initState();
    
    Timer(
      const Duration(milliseconds: 1500),
      (){
        check();
      } 
    );
  }
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    
    
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              SizedBox(
                width: width*0.4,
                height: width*0.4,
                child: Image.asset("assets/voyageur.png"),
              ),

              const SizedBox(height: 15,),

              Text(
                "Busify Voyageur",
                style: Theme.of(context).textTheme.titleMedium,
              )

            ],
          ),
        ),
      ),
    );
  }
}