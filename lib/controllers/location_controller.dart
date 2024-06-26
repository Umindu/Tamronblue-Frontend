import 'package:get/get.dart';

class LocationController extends GetxController {
  var locationLatLng = " ".obs;
  var locationAddress = " ".obs;

  void addLocationLatLng(RxString LatLng, RxString Address) {
    locationLatLng = LatLng;
    locationAddress = Address;
    update();
  }
}
