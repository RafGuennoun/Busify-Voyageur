
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
    return const Scaffold(
      body: SafeArea(
        child: Center(child: Text("Splash")) 
      ),
    );
  }
}