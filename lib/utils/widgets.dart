import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/screens/auth/authscreen.dart';
import 'package:tamronblue_frontend/screens/settings/settingscreen.dart';

 Future<dynamic> popUpMenu(BuildContext context) {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    return showMenu(
              context: context,
              position: const RelativeRect.fromLTRB(100, 80, 0, 0),
              items: [
                PopupMenuItem(
                  child: ListTile(
                    title: const Text('Settings'),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const SettingScreen());
                    },
                  ),
                ),
                PopupMenuItem(
                  child: ListTile(
                    title: const Text('Logout'),
                    onTap: () async {
                      final SharedPreferences prefs = await _prefs;
                      prefs.clear();
                      Get.offAll(const AuthScreen());
                    },
                  ),
                ),
              ],
            );
  }