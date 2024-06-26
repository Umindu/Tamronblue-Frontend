import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/models/Customer.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class CustomerController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // get customer by id
  Future<Customer> getCustomerById(int id) async {
    Customer customer =
        Customer(0, '', '', '', '', '', '', '', '', '', '', 0, 0, false);

    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(
            ApiEndpoints.customerEndpoints.getCustomerById + id.toString());

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);
          var id = body['id'];
          var first_name = body['first_name'];
          var last_name = body['last_name'];
          var email = body['email'];
          var gender = body['gender'];
          var nic = body['nic'];
          var phone = body['phone'];
          var address = body['address'];
          var city = body['city'];
          var country = body['country'];
          var zip_code = body['zip_code'];
          var branch_id = body['branch_id'];
          var agent_id = body['agent_id'];
          var status = body['status'];

          customer = Customer(
              id,
              first_name,
              last_name,
              email,
              gender,
              nic,
              phone,
              address,
              city,
              country,
              zip_code,
              branch_id,
              agent_id,
              status);
        } else {
          Get.snackbar('Error', 'Something went wrong');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
    return customer;
  }

  Future<List<CustomerList>> getMyAllCustomersList() async {
    List<CustomerList>? customers = [];
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.customerEndpoints.getCustomers);

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          List<dynamic> body = jsonDecode(response.body);
          for (var item in body) {
            var id = item['id'];
            var first_name = item['first_name'];
            var last_name = item['last_name'];
            var email = item['email'];
            CustomerList customer = CustomerList(
              id,
              first_name,
              last_name,
              email,
            );
            customers.add(customer);
          }
        } else {
          Get.snackbar('Error', 'Failed to load customers');
        }
      } else {
        Get.snackbar(
            'Error', 'Failed to load customers, user not authenticated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load customers');
    }
    return customers;
  }

  //add customer
  Future<bool> addCustomer(
      String first_name,
      String last_name,
      String email,
      String gender,
      String nic,
      String phone,
      String address,
      String city,
      String country,
      String zip_code,
      int branch_id,
      int agent_id,
      bool status) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };

        var url = Uri.parse(ApiEndpoints.customerEndpoints.createCustomer);
        var body = jsonEncode({
          'first_name': first_name,
          'last_name': last_name,
          'email': email,
          'gender': gender,
          'nic': nic,
          'phone': phone,
          'address': address,
          'city': city,
          'country': country,
          'zip_code': zip_code,
          'branch_id': branch_id,
          'agent_id': agent_id,
          'status': status,
        });

        http.Response response =
            await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          return true;
        } else {
          Get.snackbar('Unsuccessful', 'Something went wrong, try again');
          return false;
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      return false;
    }
    return false;
  }
}
