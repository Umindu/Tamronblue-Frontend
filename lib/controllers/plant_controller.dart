import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/models/Plant.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class PlantController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //get all Plants
  Future<List<Plant>> getAllPlants() async {
    List<Plant>? plants = [];
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.plantEndpoints.getAllPlants);
        
        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          for (var item in body) {
            var id = item['id'];
            var name = item['name'];
            var description = item['description'];
            var status = item['status'];

            Plant plant = Plant(
                id,
                name,
                description,
                status);

            plants.add(plant);
          }
        }else{
          Get.snackbar('Error', 'Failed to load plants');
        }
      }else{
        Get.snackbar('Error', 'Failed to load plants, user not authenticated');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load plants');
    }
    return plants;
  }
}