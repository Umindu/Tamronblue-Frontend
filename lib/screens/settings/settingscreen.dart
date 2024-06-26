import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tamronblue_frontend/screens/settings/accounts/accountscreen.dart';
import 'package:tamronblue_frontend/theme/theme_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool isDarkMode = ThemeService().isSavedDarkMode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Iconsax.user),
                title: Text('Account Settings'),
                subtitle: const Text('Change password, email'),
                onTap: () {
                  Get.to(() => AccountScreen());
                },
              ),
              ListTile(
                leading: isDarkMode
                    ? const Icon(Iconsax.moon)
                    : const Icon(Iconsax.sun),
                title: const Text('Theme'),
                onTap: () {
                    showDialog(context: context, builder: (context) {
                      return AlertDialog(
                        title: const Text('Change Theme'),
                        content: const Text('Do you want to change the theme?'),
                        actions: [
                          ListTile(
                            leading: const Icon(Iconsax.sun),
                            title: const Text('Light Mode'),
                            onTap: () {
                              if (isDarkMode == true) {
                                ThemeService().changeThemeMode();
                                setState(() {
                                  isDarkMode = false;
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                          ListTile(
                            leading: const Icon(Iconsax.moon),
                            title: const Text('Dark Mode'),
                            onTap: () {
                              if (isDarkMode == false) {
                                ThemeService().changeThemeMode();
                                setState(() {
                                  isDarkMode = true;
                                });
                              }
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
                },
                subtitle: isDarkMode
                    ? const Text('Dark Mode')
                    : const Text('Light Mode'),
              ),
              const ListTile(
                leading: Icon(Iconsax.notification),
                title: Text('Notifications'),
                subtitle: Text('Turn on/off notifications'),
              ),
              const ListTile(
                leading: Icon(Icons.language_outlined),
                title: Text('Language'),
                subtitle: Text('English'),
              ),
              const ListTile(
                leading: Icon(Iconsax.info_circle),
                title: Text('About'),
                subtitle: Text('TamronBlue'), 
              ),
            ],
          ),
        ),
      ),
    );
  }
}