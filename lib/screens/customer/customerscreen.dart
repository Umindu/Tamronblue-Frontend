import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/screens/customer/customeradd.dart';
import 'package:tamronblue_frontend/screens/customer/customerdetail.dart';
import 'package:tamronblue_frontend/shimmer/shimmerlist.dart';
import 'package:tamronblue_frontend/utils/widgets.dart';

class CustomerScreen extends StatefulWidget {
  const CustomerScreen({super.key});

  @override
  State<CustomerScreen> createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  CustomerController customerController = Get.put(CustomerController());

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
          'Customers',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // show popup menu
          IconButton(
            onPressed: () {
              popUpMenu(context);
            },
            icon: const Icon(Iconsax.more),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => AddCustomer())?.then((result) {
            if (result == true) {
              setState(() {});
            }
          });
        },
        child: const Icon(Iconsax.add),
      ),
      body: SafeArea(
        child: Container(
          child: FutureBuilder(
            future: customerController.getMyAllCustomersList(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
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
                );
              } else {
                if (snapshot.data.length == 0) {
                  return const Center(
                    child: Text('No Customers'),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        snapshot.data[index].first_name +
                            " " +
                            snapshot.data[index].last_name,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      subtitle: Text(snapshot.data[index].email),
                      trailing: IconButton(
                        onPressed: () {},
                        icon: Icon(Iconsax.more,
                            color: Theme.of(context).secondaryHeaderColor),
                      ),
                      onTap: () {
                        Get.to(() => CustomerDetail(
                            customer_id: snapshot.data[index].id));
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
