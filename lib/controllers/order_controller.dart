import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/models/Order.dart';
import 'package:tamronblue_frontend/utils/api_endpoints.dart';

class OrderController extends GetxController {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  //Order details controller....................................................

  //get order by id
  Future<Order> getOrderById(int id) async {
    Order order = Order(0, 0, 0, 0, 0, 0, 0, false, '', DateTime.now());

    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };
        var url = Uri.parse(ApiEndpoints.orderEndpoints.getOrderById + id.toString());

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);
          var id = body['id'];
          var customer_id = body['customer'];
          var land_id = body['land'];
          var agent_id = body['agent'];
          var subtotal = body['subtotal'];
          var discount = body['discount'];
          var total = body['total'];
          var paid = body['paid'];
          var status = body['status'];
          var created_at = body['created'];

          order = Order(
            id,
            customer_id,
            land_id,
            agent_id,
            double.parse(subtotal),
            double.parse(discount),
            double.parse(total),
            paid,
            status,
            DateTime.parse(created_at),
          );
          
        } else {
          Get.snackbar('Error', 'Failed to load order');
        }
      } else {
        Get.snackbar('Error', 'Failed to load order, user not authenticated');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load order');
    }
    return order;
  }


  //get my all orders
  Future<List<OrderList>> getMyAllOrdersList() async {
    List<OrderList>? orders = [];
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };

        var url = Uri.parse(ApiEndpoints.orderEndpoints.getMyOrders);

        http.Response response = await http.get(url, headers: headers);

        if (response.statusCode == 200) {
          var body = jsonDecode(response.body);

          for (var item in body) {
            var id = item['id'];
            var customer_id = item['customer'];
            var land_id = item['land'];
            var total = item['total'];
            var status = item['status'];
            var created_at = item['created'];

            OrderList order = OrderList(
              id,
              customer_id,
              land_id,
              '',
              '',
              double.parse(total),
              status,
              DateTime.parse(created_at),
            );

            orders.add(order);
          }
        } else {
          Get.snackbar('Error', 'Failed to load orderssss');
        }
      } else {
        Get.snackbar('Error', 'Failed to load orders, user not authenticated');
      }
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Failed to load orders');
    }
    return orders;
  }

  //add order
  Future<bool> addOrder(int customer_id, int land_id, double subtotal,
      List<Map<String, dynamic>> orderItemsList) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      final agent_id = prefs.getInt('id');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };

        var url = Uri.parse(ApiEndpoints.orderEndpoints.createOrder);
        var body = jsonEncode({
          'customer': customer_id,
          'land': land_id,
          'agent': agent_id,
          'subtotal': subtotal,
        });

        http.Response response =
            await http.post(url, headers: headers, body: body);

        if (response.statusCode == 201) {
          var body = jsonDecode(response.body);
          var order_id = body['id'];

          var respo = await addOrderItem(orderItemsList, order_id);

          if (respo == true) {
            Get.snackbar('Success', 'Order added successfully');
            return true;
          } else {
            Get.snackbar('Error', 'Failed to add order');
            return false;
          }
        } else {
          Get.snackbar('Error', 'Failed to add order');
          return false;
        }
      } else {
        Get.snackbar('Error', 'Failed to add order, user not authenticated');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add order');
      return false;
    }
  }


  // Order items controller....................................................
  //add order item
  Future<bool> addOrderItem(
      List<Map<String, dynamic>> orderItemsList, int order_id) async {
    try {
      final SharedPreferences prefs = await _prefs;
      final access = prefs.getString('access');

      if (access != null) {
        var headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $access',
        };

        var url = Uri.parse(ApiEndpoints.orderEndpoints.addOrderItem);

        for (var item in orderItemsList) {
          item['order'] = order_id;

          var body = jsonEncode(item);

          http.Response response =
              await http.post(url, headers: headers, body: body);

          if (response.statusCode != 201) {
            Get.snackbar('Error', 'Failed to add order items');
            return false;
          }
        }
        return true;
      } else {
        Get.snackbar(
            'Error', 'Failed to add order items, user not authenticated');
        return false;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to add order items');
      return false;
    }
  }
}
