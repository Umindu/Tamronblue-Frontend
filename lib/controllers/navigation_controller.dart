import 'package:get/get.dart';
import 'package:tamronblue_frontend/screens/customer/customerscreen.dart';
import 'package:tamronblue_frontend/screens/home/homescreen.dart';
import 'package:tamronblue_frontend/screens/land/landscreen.dart';
import 'package:tamronblue_frontend/screens/profile/profilescreen.dart';

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens =[HomeScreen(), CustomerScreen(), LandScreen(), ProfileScreen()];

}