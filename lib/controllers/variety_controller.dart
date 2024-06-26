import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/models/Variety.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class VarietyController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  get varieties => null;

  //get all Varieties
  Future<List<Variety>> getAllVarieties() async {
    List<Variety>? varieties = [];
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.varietyEndpoints.getAllVarieties);
        http.Response response = await http.get(url, headers: headers);
        print(response.body);

        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          for (var item in body) {
            var id = item['id'];
            var name = item['name'];
            var description = item['description'];
            var plantId = item['plant_id'];
            var status = item['status'];

            Variety variety = Variety(
                id,
                name,
                description,
                plantId,
                status);

            varieties.add(variety);
          }
        }else{
          Get.snackbar('Error', 'Failed to load varieties');
        }
      }else{
        Get.snackbar('Error', 'Failed to load varieties, user not authenticated');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load varieties');
    }
    return varieties;
  }

  //get all Varieties by plant id
  Future<List<Variety>> getVarietiesByPlantId(int plantId) async {
    List<Variety>? varieties = [];
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.varietyEndpoints.getVarietiesByPlantId + plantId.toString());
        
        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          for (var item in body) {
            var id = item['id'];
            var name = item['name'];
            var description = item['description'];
            var plantId = item['plant_id'];
            var status = item['status'];

            Variety variety = Variety(
                id,
                name,
                description,
                plantId,
                status);

            varieties.add(variety);
          }
        }else{
          Get.snackbar('Error', 'Failed to load varieties');
        }
      }else{
        Get.snackbar('Error', 'Failed to load varieties, user not authenticated');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load varieties');
    }
    return varieties;
  }
}
 