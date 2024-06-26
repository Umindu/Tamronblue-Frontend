import 'dart:convert';

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:tamronblue_frontend/models/LandPlant.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class LandPlantController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late List<LandPlant> landPlants;

  // get plants in land by land id
  Future<List<LandPlant>> getPlantsInLandByLandId(int landId) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };

        var url = Uri.parse(
            ApiEndpoints.landPlantEndpoints.getPlantsInLandByLandId + landId.toString());

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);
          List<LandPlant> landPlants = [];

          for (var item in body) {
            var id = item['id'];
            var land_id = item['land_id'];
            var plant_id = item['plant_id'];
            var variety_id = item['variety_id'];
            var monthly_requirements = item['requirements_for_monthly'];
            var annual_requirements = item['requirements_for_annual'];

            LandPlant landPlant = LandPlant(
              id,
              land_id,
              plant_id,
              variety_id,
              monthly_requirements,
              annual_requirements,
            );

            landPlants.add(landPlant);
          }

          return landPlants;
        } else {
          Get.snackbar('Error', 'Failed to load plants in land');
          return [];
        }
      } else {
        Get.snackbar('Error', 'Failed to load plants in land, user not authenticated');
        return [];
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load plants in land');
      return [];
    }
  }

  // add plant to land
  Future<bool> addPlantToLand(
    int landId,
    String plantId,
    String varietyId,
    String requirements_for_monthly,
    String requirements_for_annual,
  ) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };

        var url = Uri.parse(ApiEndpoints.landPlantEndpoints.createLandPlant);
        var body = jsonEncode(
          {
            'land_id': landId,
            'plant_id': plantId,
            'variety_id': varietyId,
            'requirements_for_monthly': requirements_for_monthly,
            'requirements_for_annual': requirements_for_annual,
          },
        );

        http.Response response =
            await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          return true;
        } else {
          Get.snackbar('Error', 'Something went wrong');
          return false;
        }
      } else {
        Get.snackbar('Error', 'Something went wrong');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}
