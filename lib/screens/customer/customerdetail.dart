import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/models/Customer.dart';
import 'package:tamronblue_frontend/screens/land/landdetail.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetail extends StatefulWidget {
  const CustomerDetail({super.key, required this.customer_id});
  final int customer_id;

  @override
  State<CustomerDetail> createState() => _CustomerDetailState();
}

class _CustomerDetailState extends State<CustomerDetail> {
  LandController landController = Get.put(LandController());
  CustomerController customerController = Get.put(CustomerController());

  late Customer customerDetail;
  bool isLoading = true;

  // get customer by id
  void getCustomerById(int id) async {
    final customer = await customerController.getCustomerById(id);
    setState(() {
      customerDetail = customer;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getCustomerById(widget.customer_id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Customer Details',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(10),
            child: Center(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //avatar
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Text(
                            customerDetail.first_name[0] +
                                customerDetail.last_name[0],
                            style: const TextStyle(fontSize: 30),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              customerDetail.first_name +
                                  ' ' +
                                  customerDetail.last_name,
                              style: const TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton(
                                  onPressed: () {
                                    //call
                                    _makePhoneCall(customerDetail.phone);
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Iconsax.call,
                                      ),
                                      SizedBox(width: 5),
                                      Text(
                                        'Call',
                                        style: TextStyle(
                                            fontSize: 18),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Customer Details',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // check and set icon
                                    customerDetail.gender == 'Male'
                                        ? Icon(
                                            Iconsax.man,
                                            color:
                                                Theme.of(context).primaryColor,
                                          )
                                        : Icon(
                                            Iconsax.woman,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                    const SizedBox(width: 20.0),
                                    Text(customerDetail.gender,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.card,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(customerDetail.nic,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.sms,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(customerDetail.email,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.call,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 20.0),
                                    Text(customerDetail.phone,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Iconsax.location,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                    const SizedBox(width: 20.0),
                                    Expanded(
                                      child: Text(
                                          '${customerDetail.address}, ${customerDetail.city}, ${customerDetail.counrty}',
                                          maxLines: 3,
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('ZIP',
                                        style: TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w500,
                                          color: Theme.of(context).primaryColor,
                                        )),
                                    const SizedBox(width: 20.0),
                                    Text(customerDetail.zip_code,
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w500)),
                                  ],
                                ),
                              ],
                            ),
                          ]),
                    ),
                    const SizedBox(height: 10),
                    const Divider(),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(top: 10),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Customer Lands Details',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Container(
                              child: FutureBuilder(
                                future: landController.getCustomerLandsList(
                                    customerDetail.id),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    if (snapshot.data.length == 0) {
                                      return const Center(
                                        child: Text('No Lands'),
                                      );
                                    }
                                    return ListView.builder(
                                      // scrollDirection: Axis.vertical,
                                      shrinkWrap: true,
                                      itemCount: snapshot.data.length,
                                      itemBuilder: (context, index) {
                                        return ListTile(
                                          title: Text(
                                            snapshot.data[index].name,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context)
                                                    .secondaryHeaderColor),
                                          ),
                                          subtitle: Text(snapshot.data[index]
                                              .address+ ', ' + snapshot.data[index].district + ', ' + snapshot.data[index].region),
                                          onTap: () {
                                            Get.to(() =>
                                                      LandDetail(land_id: snapshot.data[index].id, isCustomerField: true,));
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ]),
                    ),
                  ]),
            ),
          ),
        ));
  }
  
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }
}
