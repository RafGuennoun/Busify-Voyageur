import 'package:busify_voyageur/views/Test.dart';
import 'package:busify_voyageur/views/welcome_views/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Busify-Voyageur',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        primarySwatch: Colors.blue,

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.blue
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.blue
        ),

        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.white
          ),
          foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            centerTitle: false,
            iconTheme: IconThemeData(
              color: Colors.white
            ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.white
        ),

        textTheme:  const TextTheme(
            
          titleLarge: TextStyle(
            fontFamily : 'Poppins', fontWeight : FontWeight.bold,
            fontSize: 20,
          ),

          titleMedium: TextStyle(
            fontFamily : 'Poppins', fontWeight : FontWeight.bold,
            fontSize: 18,
          ),

          titleSmall: TextStyle(
            fontFamily : 'Poppins',
            fontSize: 18,
          ),

          bodyMedium: TextStyle(
            fontFamily : 'Poppins', fontWeight : FontWeight.normal,
            fontSize: 14,
          ),

          bodySmall: TextStyle(
            fontFamily : 'Poppins', fontWeight : FontWeight.normal,
            fontSize: 12,
          )
        )
      ),
      home: const SplashScreen(),
    );
  }
}
