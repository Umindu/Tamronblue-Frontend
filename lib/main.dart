import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tamronblue_frontend/screens/auth/landingscreen.dart';
import 'package:tamronblue_frontend/theme/theme_service.dart';
import 'package:tamronblue_frontend/theme/themes.dart';

void main() async{
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      
      theme: Themes().lightTheme,
      darkTheme: Themes().darkTheme,

      themeMode: ThemeService().getThemeMode(),
      
      home: LandingScreen(),
    );
  }
}
