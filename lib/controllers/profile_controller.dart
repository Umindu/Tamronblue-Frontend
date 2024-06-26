import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class ProfileController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // My details save shared preferences
  Future<bool> getMyDetailsSaveShared() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.profileEndpoints.getMyProfile +
            prefs.getInt('id').toString());

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final first_name = json['first_name'];
          final last_name = json['last_name'];
          final email = json['email'];
          final point = json['point'];
          final level = json['level'];
          final monthly_income =
              double.parse(json['monthly_income'].toString());
          final is_admin = json['is_admin'];
          final is_agent = json['is_agent'];
          final branch = json['branch'];

          await prefs.setString('first_name', first_name);
          await prefs.setString('last_name', last_name);
          await prefs.setString('email', email);
          await prefs.setInt('point', point);
          await prefs.setInt('level', level);
          await prefs.setDouble('monthly_income', monthly_income);
          await prefs.setBool('is_admin', is_admin);
          await prefs.setBool('is_agent', is_agent);
          await prefs.setInt('branch', branch);

          return true;
        } else if (response.statusCode == 404) {
          return false;
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['message']);
          return false;
        }
      } else {
        Get.snackbar('Error', 'No access token found');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  // My details list
  Future<bool> getMyDetails() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.profileEndpoints.getMyProfile +
            prefs.getInt('id').toString());

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final first_name = json['first_name'];
          final last_name = json['last_name'];
          final email = json['email'];
          final point = json['point'];
          final level = json['level'];
          final monthly_income =
              double.parse(json['monthly_income'].toString());
          final is_admin = json['is_admin'];
          final is_agent = json['is_agent'];
          final branch = json['branch'];

          await prefs.setString('first_name', first_name);
          await prefs.setString('last_name', last_name);
          await prefs.setString('email', email);
          await prefs.setInt('point', point);
          await prefs.setInt('level', level);
          await prefs.setDouble('monthly_income', monthly_income);
          await prefs.setBool('is_admin', is_admin);
          await prefs.setBool('is_agent', is_agent);
          await prefs.setInt('branch', branch);

          return true;
        } else if (response.statusCode == 404) {
          return false;
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['message']);
          return false;
        }
      } else {
        Get.snackbar('Error', 'No access token found');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  // add my details
  Future<bool> addMyDetails(
    String first_name,
    String last_name,
    String email,
    String nic,
    String gender,
    String phone,
    String address,
    String city,
    String country,
    String zip_code,
  ) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.profileEndpoints.addMyProfile);

        var body = jsonEncode({
          'user_id' : prefs.getInt('id'),
          'first_name': first_name,
          'last_name': last_name,
          'email': email,
          'nic': nic,
          'gender': gender,
          'phone': phone,
          'address': address,
          'city': city,
          'country': country,
          'postal_code': zip_code,
        });

        http.Response response =
            await http.post(url, headers: headers, body: body);
print(response.body);
        if (response.statusCode == 201) {
          final json = jsonDecode(response.body);
          final first_name = json['first_name'];
          final last_name = json['last_name'];
          final email = json['email'];
          final point = json['point'];
          final level = json['level'];
          final monthly_income =
              double.parse(json['monthly_income'].toString());
          final is_admin = json['is_admin'];
          final is_agent = json['is_agent'];
          final branch = json['branch'];

          await prefs.setString('first_name', first_name);
          await prefs.setString('last_name', last_name);
          await prefs.setString('email', email);
          await prefs.setInt('point', point);
          await prefs.setInt('level', level);
          await prefs.setDouble('monthly_income', monthly_income);
          await prefs.setBool('is_admin', is_admin);
          await prefs.setBool('is_agent', is_agent);
          await prefs.setInt('branch', branch);

          return true;
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['message']);
          return false;
        }
      } else {
        Get.snackbar('Error', 'No access token found');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}
