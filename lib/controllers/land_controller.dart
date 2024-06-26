import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/controllers/land_plant_controller.dart';
import 'package:tamronblue_frontend/models/Land.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class LandController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //get land by id
  Future<Land> getLandById(int id) async {
    Land land = Land(0, '', 0, '', 0, '', '', '', '', '', '', 0, 0, '', false);
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.landEndpoints.getLandById + id.toString());

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);
          var id = body['id'];
          var name = body['name'];
          var customer_id = body['customer_id'];
          var address = body['address'];
          var area = body['area'];
          var district = body['district'];
          var agricultural_zone = body['agricultural_zone'];
          var density = body['density_of_cultivation'];
          var acclimatization = body['acclimatization'];
          var region = body['region'];
          var google_map = body['google_map'];
          var branch_id = body['branch_id'];
          var agent_id = body['agent_id'];
          var description = body['description'];
          var status = body['status'];

          land = Land(
              id,
              name,
              customer_id,
              address,
              area,
              district,
              agricultural_zone,
              density,
              acclimatization,
              region,
              google_map,
              branch_id,
              agent_id,
              description,
              status);
        } else {
          Get.snackbar('Error', 'Field to load land');
        }
      }else{
        Get.snackbar('Error', 'Field to load land, user not authenticated');}
    } catch (e) {
      Get.snackbar('Error', 'Field to load land');
    }
    return land;
  }

  //get my all lands
  Future<List<LandList>> getMyAllLandsList() async {
    List<LandList>? lands = [];
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.landEndpoints.getAgentLands);
       
        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          for (var item in body) {
            var id = item['id'];
            var name = item['name'];
            var address = item['address'];
            var district = item['district'];
            var region = item['region'];

            LandList land = LandList(
                id,
                name,
                address,
                district,
                region
                );
            lands.add(land);
          }
        } else {
          Get.snackbar('Error', 'Failed to load lands');
        }
      }else{
        Get.snackbar('Error', 'Failed to load lands, user not authenticated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load lands');
    }
    return lands;
  }

  //get customer lands
  Future<List<LandList>> getCustomerLandsList(int id) async {
    List<LandList>? lands = [];
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(
            ApiEndpoints.landEndpoints.getCustomerLands + id.toString());

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          for (var item in body) {
            var id = item['id'];
            var name = item['name'];
            var address = item['address'];
            var district = item['district'];
            var region = item['region'];;

            LandList land = LandList(
                id,
                name,
                address,
                district,
                region);
            lands.add(land);
          }
        } else {
          Get.snackbar('Error', 'Failed to load lands');
        }
      }else{
        Get.snackbar('Error', 'Failed to load lands, user not authenticated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load lands');
    }
    return lands;
  }

  //add land
  Future<bool> addLand(
    String landName,
    int customer_id,
    String address,
    double area,
    String district,
    String agricultural_zone,
    String density_of_cultivation,
    String acclimatization,
    String region,
    String google_map,
    int branch_id,
    int agent_id,
    String description,
    bool status,
    String plant_id,
    String variety_id,
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

        var url = Uri.parse(ApiEndpoints.landEndpoints.createLand);
        var body = jsonEncode({
          'name': landName,
          'customer_id': customer_id,
          'address': address,
          'area': area,
          'district': district,
          'agricultural_zone': agricultural_zone,
          'density_of_cultivation': density_of_cultivation,
          'acclimatization': acclimatization,
          'region': region,
          'google_map': google_map,
          'branch_id': branch_id,
          'agent_id': agent_id,
          'description': description,
          'status': status
        });

        http.Response response =
            await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          var landId = jsonDecode(response.body)['id'];

          var secondResponse = await LandPlantController().addPlantToLand(
            landId,
            plant_id,
            variety_id,
            requirements_for_monthly,
            requirements_for_annual,
          );

          if (secondResponse) {
            Get.snackbar('Success', 'Land added successfully');
            return true;
          }else {
            Get.snackbar('Error', 'Something went wrong');
            return false;
          }
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
