import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/controllers/navigation_controller.dart';
// import 'package:tamronblue_frontend/screens/auth/authscreen.dart';
import 'package:iconsax/iconsax.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  NavigationController navigationController = Get.put(NavigationController());
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 70,
          elevation: 1,
          selectedIndex: navigationController.selectedIndex.value,
          onDestinationSelected: (index) =>
              {navigationController.selectedIndex.value = index},
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.profile_2user),
              label: 'Customers',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.location),
              label: 'Lands',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              label: 'Profile',
            ),
          ],
        ),
      ),
      body: Obx(() => navigationController.screens[navigationController.selectedIndex.value]),
    );
  }
}
