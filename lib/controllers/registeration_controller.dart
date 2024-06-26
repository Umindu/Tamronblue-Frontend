import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController{
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController RePasswordController = TextEditingController();

  Future<bool> registerWithEmail() async {
    try{
      var headers = {
        'Content-Type': 'application/json',
      };
      var url = Uri.parse(ApiEndpoints.baseUrl+ApiEndpoints.authEndPoints.register);

      Map body = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        're_password': RePasswordController.text
      };

      http.Response response = await http.post(url, headers: headers, body: jsonEncode(body));

      if(response.statusCode == 201){
        firstNameController.clear();
        lastNameController.clear();
        emailController.clear();
        passwordController.clear();
        RePasswordController.clear();
        
        Get.snackbar('Success', 'User registered successfully');

        return true;
      }else{
        Get.snackbar('Error', jsonDecode(response.body)['message']);
        return false;
      }
    }catch(e){
      Get.back();
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
  }
}