import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:busify_voyageur/views/welcome_views/SplashScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return AdaptiveTheme(
      initial: AdaptiveThemeMode.light, 
      light: ThemeData(
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

      dark: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.amber,
        primarySwatch: Colors.amber,

        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.amber
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          selectedItemColor: Colors.amber
        ),

        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.normal,
            fontSize: 20,
            color: Colors.black87
          ),
          foregroundColor: Colors.black87,
            backgroundColor: Colors.amber,
            centerTitle: false,
            iconTheme: IconThemeData(
              color: Colors.black87
            ),
        ),

        iconTheme: const IconThemeData(
          color: Colors.amber
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


      builder: (theme, darkTheme) => MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Busify Voyageur',
        theme: theme,
        darkTheme: darkTheme,
        // home: LoginScreen(),
        home: const SplashScreen(),
      )
    );
  }
}
