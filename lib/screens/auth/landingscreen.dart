import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/controllers/login_controller.dart';
import 'package:tamronblue_frontend/controllers/profile_controller.dart';
import 'package:tamronblue_frontend/screens/auth/authscreen.dart';
import 'package:tamronblue_frontend/screens/home.dart';
import 'package:tamronblue_frontend/screens/profile/splashaddprofile.dart';

class LandingScreen extends StatefulWidget {
  LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> {
  LoginController loginController = Get.put(LoginController());

  Future<void> checkLogout() async {
    await Future.delayed(const Duration(seconds: 3));
    var response = await loginController.verifyToken();
    if (response) {
      bool secondResponse = await ProfileController().getMyDetailsSaveShared();
      if (secondResponse) {
        Get.offAll(const Home());
      }else{
        Get.offAll(const AddProfileSplash());
      }
    } else {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
      Get.offAll(const AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    checkLogout();
    return SafeArea(
      child: Scaffold(
        body: Container(
          color: Color.fromARGB(255, 249, 246, 255),
          height: double.infinity,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(),
                ),
                SizedBox(
                    width: 250.0,
                    child: Image.asset('assets/images/tamronblue_logo1.png')),
                const SizedBox(
                  height: 20,
                ),
                const Center(
                  child: CircularProgressIndicator(),
                ),
                Expanded(
                  child: Container(),
                ),
                const Column(
                  children: [
                    Text('V 1.0'),
                    Text('Developed by: finixly.com'),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   children: [
          //     Column(
          //       children: [
          //         SizedBox(
          //             width: 250.0,
          //             child: Image.asset('assets/images/tamronblue_logo1.png')),
          //         const SizedBox(
          //           height: 20,
          //         ),
          //         const Center(
          //           child: CircularProgressIndicator(),
          //         ),
          //       ],
          //     ),
          //     const Column(
          //       children: [
          //         Text('V 1.0'),
          //         Text('Developed by: finixly.com'),
          //       ],
          //     ),
          //   ],
          // ),
        ),
      ),
    );
  }
}
