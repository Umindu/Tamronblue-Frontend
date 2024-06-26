import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Themes{
  // Light Theme
  final lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: const Color(0xFF4d2586),
    scaffoldBackgroundColor: const Color(0xFFffffff),
    secondaryHeaderColor: const Color(0xFF000000),
    canvasColor: const Color(0xFFffffff),
    shadowColor: const Color(0xFF000000).withOpacity(0.1),
    dividerColor: const Color(0xFF000000).withOpacity(0.1),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFffffff),
      foregroundColor: Color.fromARGB(255, 0, 0, 0),
      surfaceTintColor: Color(0xFFffffff),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(bottom: BorderSide(color: Color.fromARGB(255, 69, 69, 69), width: 0.3)),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFFffffff),
      indicatorColor: const Color.fromARGB(23, 77, 37, 134),
      surfaceTintColor: const Color(0xFFffffff),
      elevation: 0,
      iconTheme: MaterialStateProperty.resolveWith((states) => const IconThemeData(color: Colors.black)),
      labelTextStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600)),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
      
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFFffffff),
      labelTextStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(color: Colors.black, fontSize: 14)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFF4d2586),
      foregroundColor: Colors.white,
      elevation: 5,
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF4d2586)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF4d2586)),
        foregroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFffffff)),
        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFffffff)),
        foregroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF4d2586)),
        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFF4d2586)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFF4d2586)),
      ),
      labelStyle: TextStyle(color: Colors.black, fontSize: 14),
    ),
  );


  // Dark Theme
  final darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: Color(0xFFB685FA),
    scaffoldBackgroundColor: Color(0xFF121212),
    secondaryHeaderColor: const Color(0xFFffffff),
    canvasColor: const Color(0xFF121212),
    shadowColor: Color.fromARGB(34, 160, 160, 160).withOpacity(0.1),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF121212),
      foregroundColor: Color(0xFFffffff),
      surfaceTintColor: Color(0xFF121212),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      shape: Border(bottom: BorderSide(color: Color.fromARGB(255, 69, 69, 69), width: 0.3)),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF121212),
      indicatorColor: const Color.fromARGB(30, 255, 255, 255),
      surfaceTintColor: const Color(0xFF121212),
      iconTheme: MaterialStateProperty.resolveWith((states) => const IconThemeData(color: Colors.white)),
      labelTextStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600)),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF121212),
      labelTextStyle: MaterialStateProperty.resolveWith((states) => const TextStyle(color: Colors.white, fontSize: 14)),
    ),

    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Color(0xFFB685FA),
      foregroundColor: Color(0xFF000000),
      elevation: 5,
    ),

    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFffffff)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFB685FA)),
        foregroundColor: MaterialStateProperty.resolveWith((states) => Color(0xFF000000)),
        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFFB685FA)),
        foregroundColor: MaterialStateProperty.resolveWith((states) => const Color(0xFF000000)),
        shape: MaterialStateProperty.resolveWith((states) => RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        )),
      ),
    ),

    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFFffffff)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        borderSide: BorderSide(color: Color(0xFFffffff)),
      ),
      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
    ),
  );
}

class MyAppColors {
  static final darkBlue = const Color(0xFF1E1E2C);
  static final lightBlue = const Color(0xFF2D2D44);
}