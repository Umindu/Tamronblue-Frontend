import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class passwordController extends GetxController {

  Future<bool> forgotPassword(String email) async {
    try {
      var headers = {
          'Content-Type': 'application/json',
        };

      var url =
          Uri.parse(ApiEndpoints.authEndPoints.forgotPassword);

      Map body = {
        'email': email,
      };

      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

}