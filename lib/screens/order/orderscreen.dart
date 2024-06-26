import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/controllers/order_controller.dart';
import 'package:tamronblue_frontend/screens/order/orderadd.dart';
import 'package:intl/intl.dart';
import 'package:tamronblue_frontend/screens/order/orderdetail.dart';
import 'package:tamronblue_frontend/shimmer/shimmerlist.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  OrderController orderController = Get.put(OrderController());
  CustomerController customerController = Get.put(CustomerController());
  LandController landController = Get.put(LandController());

  List ordersList = [];
  List customersList = [];
  List landsList = [];

  bool isLoading = false;

  //get land
  void getLandName() async {
    var lands = await landController.getMyAllLandsList();
    setState(() {
      landsList = lands;

      for (var order in ordersList) {
        for (var customer in customersList) {
          if (order.customer_id == customer.id) {
            order.customer_name =
                customer.first_name + ' ' + customer.last_name;
          }
        }

        for (var land in landsList) {
          if (order.land_id == land.id) {
            order.land_name = land.name;
          }
        }

        isLoading = true;
      }
    });
  }

  //get customer
  void getCustomerName() async {
    var customers = await customerController.getMyAllCustomersList();
    setState(() {
      customersList = customers;
      getLandName();
    });
  }

  // get my all orders
  void getMyAllOrdersList() async {
    var orders = await orderController.getMyAllOrdersList();
    setState(() {
      ordersList = orders;
      getCustomerName();
    });
  }

  @override
  void initState() {
    super.initState();
    getMyAllOrdersList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(0),
          ),
        ),
        title: const Text(
          'Orders',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => const AddOrder())?.then((result) {
            if (result == true) {
              setState(() {
                isLoading = false;
                ordersList = [];
                getMyAllOrdersList();
              });
            }
          });
        },
        child: const Icon(Iconsax.add),
      ),
      body: SafeArea(
        child: Container(
          child: isLoading == false
              ? Center(
                  child: SizedBox(
                    child: Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.withOpacity(0.6),
                        child: ListView.separated(
                            itemBuilder: (context, index) =>
                                const ShimmerList(),
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                                  height: 16,
                                ),
                            itemCount: 15)),
                  ),
                )
              : ordersList.isEmpty
                  ? const Center(
                      child: Text('No Orders'),
                    )
                  : ListView.builder(
                      itemCount: ordersList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          // leading AssetImage
                          leading: ordersList[index].status == 'Pending'
                              ? const Icon(Iconsax.clock, color: Colors.red,)
                              : const Icon(Icons.done, color: Colors.green,),
                          title: Text(
                            'Invoice No: ${ordersList[index].id}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).secondaryHeaderColor),
                          ),
                          subtitle: Text(
                            '${ordersList[index].customer_name} - ${ordersList[index].land_name}\nTotal: ${ordersList[index].total}',
                          ),
                          trailing: Text(DateFormat('yyyy.MMMM.dd')
                              .format(ordersList[index].created_at)),
                              onTap: () {
                                Get.to(() => OrderDetail(order_id: ordersList[index].id,));
                              },
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
