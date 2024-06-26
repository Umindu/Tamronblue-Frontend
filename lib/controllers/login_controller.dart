import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<bool> logingWithEmail() async {
    try {
      var headers = {
        'Content-Type': 'application/json',
      };
      var url =
          Uri.parse(ApiEndpoints.baseUrl + ApiEndpoints.authEndPoints.login);

      Map body = {
        'email': emailController.text.trim(),
        'password': passwordController.text,
      };
      
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final access = json['access'];
        final refresh = json['refresh'];

        final SharedPreferences? prefs = await _prefs;
        await prefs?.setString('access', access);
        await prefs?.setString('refresh', refresh);

        emailController.clear();
        passwordController.clear();

        await getMyProfileId();
        // await ProfileController().getMyDetails();

        // Get.offAll(() => const Home());
        // Get.snackbar('Success', 'User logged in successfully');
        return true;
        
      } else {
        Get.snackbar('Error', jsonDecode(response.body)['message']);
        return false;
      }
    } catch (e) {
      Get.back();
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }

  // token verification
  Future<bool> verifyToken() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
        };
        var url = Uri.parse(ApiEndpoints.authEndPoints.verifyToken);
        Map body = {
          'token': access,
        };

        http.Response response =
            await http.post(url, body: jsonEncode(body), headers: headers);

        if (response.statusCode == 200) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  // My details
  Future<void> getMyProfileId() async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.authEndPoints.myDetails);

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          final json = jsonDecode(response.body);
          final id = json['id'];
          final first_name = json['first_name'];
          final last_name = json['last_name'];
          final email = json['email'];

          final SharedPreferences? prefs = await _prefs;
          await prefs?.setInt('id', id);
          await prefs?.setString('first_name', first_name);
          await prefs?.setString('last_name', last_name);
          await prefs?.setString('email', email);

        } else {
          Get.snackbar('Error', jsonDecode(response.body)['message']);
        }
      } else {
        Get.snackbar('Error', 'No access token found');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }
}
