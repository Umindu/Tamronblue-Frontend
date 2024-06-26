import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/controllers/order_controller.dart';
import 'package:tamronblue_frontend/screens/order/orderadd.dart';
import 'package:tamronblue_frontend/screens/order/orderdetail.dart';
import 'package:tamronblue_frontend/screens/order/orderscreen.dart';
import 'package:tamronblue_frontend/shimmer/shimmercard.dart';
import 'package:tamronblue_frontend/utils/widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  DateTime now = DateTime.now();

// Orders..............................
  OrderController orderController = Get.put(OrderController());
  CustomerController customerController = Get.put(CustomerController());
  LandController landController = Get.put(LandController());

  List ordersList = [];
  List customersList = [];
  List landsList = [];

  bool isOrdersLoading = false;

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
      }
      isOrdersLoading = true;
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
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Ellangava ',
              style: GoogleFonts.playball(
                textStyle: Theme.of(context).textTheme.displayLarge,
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Text(
              'Agent',
              style: TextStyle(
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
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
      floatingActionButton: SpeedDial(
        label: const Text('Contact Us'),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        icon: Iconsax.call,
        activeIcon: Icons.close,
        backgroundColor: Theme.of(context).primaryColor,
        children: [
          SpeedDialChild(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Iconsax.call, color: Theme.of(context).canvasColor),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Call',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _makePhoneCall('0702037916');
            },
          ),
          SpeedDialChild(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: FaIcon(FontAwesomeIcons.whatsapp,
                color: Theme.of(context).canvasColor),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'WhatsApp',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _launchUrl(Uri.parse('https://wa.me/message/EL7Z6D2Z3U23L1'));
            },
          ),
          SpeedDialChild(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Iconsax.sms, color: Theme.of(context).canvasColor),
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Email',
            labelStyle: const TextStyle(fontSize: 18.0),
            onTap: () {
              _sendEmail('info@tamronblue.com');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                        color: Theme.of(context).shadowColor,
                      ),
                    ],
                  ),
                  child: FutureBuilder(
                    future: _prefs,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        final SharedPreferences prefs =
                            snapshot.data as SharedPreferences;
                        final first_name = prefs.getString('first_name');
                        final last_name = prefs.getString('last_name');
                        final monthly_income =
                            prefs.getDouble('monthly_income');

                        return Column(
                          children: [
                            Row(
                              children: [
                                now.hour < 12
                                    ? const Icon(
                                        Iconsax.cloud_sunny,
                                        size: 40,
                                      )
                                    : now.hour < 17
                                        ? const Icon(
                                            Iconsax.sun_14,
                                            size: 40,
                                          )
                                        : const Icon(
                                            Iconsax.sun_fog,
                                            size: 40,
                                          ),
                                const SizedBox(width: 10),
                                Flexible(
                                    child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  strutStyle: const StrutStyle(fontSize: 12.0),
                                  text: TextSpan(
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .secondaryHeaderColor,
                                    ),
                                    text:
                                        'Good ${now.hour < 12 ? 'Morning,' : now.hour < 17 ? 'Afternoon,' : 'Evening,'} $first_name $last_name',
                                  ),
                                )),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        'Rs. $monthly_income',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const Text(
                                        'Monthly Income',
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: 50,
                                  width: 1,
                                  color: Colors.grey,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        '1250',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                      ),
                                      const Text(
                                        'Number of plants sold',
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                          ],
                        );
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text('Orders',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Get.to(() => const AddOrder());
                        },
                        child: const Row(
                          children: [
                            Icon(Iconsax.add, size: 25),
                            Text('Add Order', style: TextStyle(fontSize: 16)),
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.history, size: 20, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text('Recent Orders',
                        style: TextStyle(
                            fontSize: 14,
                            color: Theme.of(context).secondaryHeaderColor)),
                  ],
                ),
                const SizedBox(height: 10),
                isOrdersLoading == false
                    ? Shimmer.fromColors(
                        baseColor: Colors.white,
                        highlightColor: Colors.grey.withOpacity(0.6),
                        child: Container(
                          height: 200,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            itemBuilder: (context, index) {
                              return ShimmerCard();
                            },
                          ),
                        ),
                      )
                    : ordersList.isEmpty
                        ? const Center(child: Text('No Orders'))
                        : Container(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: ordersList.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        right: 10, bottom: 10, top: 10),
                                    width: 200,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).canvasColor,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                          offset: const Offset(0, 2),
                                          color: Theme.of(context).shadowColor,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Stack(
                                          children: [
                                            Container(
                                              height: 75,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight: Radius.circular(10),
                                                ),
                                                image: DecorationImage(
                                                  image: AssetImage(
                                                      'assets/images/vector-1.png'),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 5,
                                              right: 5,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context)
                                                      .canvasColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                child:
                                                    ordersList[index].status ==
                                                            'Pending'
                                                        ? const Icon(
                                                            Iconsax.clock,
                                                            color: Colors.red,
                                                          )
                                                        : const Icon(
                                                            Icons.done,
                                                            color: Colors.green,
                                                          ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, right: 10, top: 5),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Invoice No: ${ordersList[index].id}',
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context)
                                                        .primaryColor,
                                                  )),
                                              Text(
                                                '${ordersList[index].customer_name}\n${ordersList[index].land_name}\nTotal: ${ordersList[index].total}',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    Get.to(() => OrderDetail(
                                          order_id: ordersList[index].id,
                                        ));
                                  },
                                );
                              },
                            ),
                          ),
                Row(
                  children: [
                    const Spacer(),
                    TextButton(
                        onPressed: () {
                          Get.to(() => const OrderScreen());
                        },
                        child: Text('View All',
                            style: TextStyle(
                                fontSize: 16,
                                color: Theme.of(context).primaryColor))),
                  ],
                ),
                const Text('Sales Summary',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                // monthly best selling amount
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        spreadRadius: 3,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                        color: Theme.of(context).shadowColor,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Icon(Iconsax.calendar, size: 20),
                          const SizedBox(width: 5),
                          Text('Monthly Best profit Amount',
                              style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Theme.of(context).secondaryHeaderColor)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Text('Rs. 1000',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)),
                                const Text(
                                  'Best profit of the month',
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            width: 1,
                            color: Colors.grey,
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Text('0',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor)),
                                const Text('Number of plants sold',
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 100),
              ],
            )),
      ),
    );
  }

// make call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

// make email
  Future<void> _sendEmail(String email) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    await launchUrl(launchUri);
  }

// make whatsapp
  Future<void> _launchUrl(Uri launchUri) async {
    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }
}
