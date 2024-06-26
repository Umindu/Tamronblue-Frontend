import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/controllers/order_controller.dart';
import 'package:tamronblue_frontend/models/Customer.dart';
import 'package:tamronblue_frontend/models/Land.dart';
import 'package:tamronblue_frontend/models/Order.dart';

class OrderDetail extends StatefulWidget {
  const OrderDetail({super.key, required this.order_id});
  final int order_id;

  @override
  State<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  OrderController orderController = OrderController();
  CustomerController customerController = CustomerController();
  LandController landController = LandController();

  TextEditingController orderIdController = TextEditingController();
  TextEditingController CustomerNameController = TextEditingController();
  TextEditingController LandNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  late Order orderDetails;
  late Land landDetails;
  late Customer customerDetails;

  bool isLoading = true;

  void getLandDetails() async {
    final land = await landController.getLandById(orderDetails.land_id);
    setState(() {
      landDetails = land;

      orderIdController.text = orderDetails.id.toString();
      CustomerNameController.text =
          '${customerDetails.first_name} ${customerDetails.last_name}';
      LandNameController.text = landDetails.name;
      dateController.text =
          DateFormat('yyyy-MM-dd').format(orderDetails.created_at);

      isLoading = false;
    });
  }

  void getCustomerDetails() async {
    final customer =
        await customerController.getCustomerById(orderDetails.customer_id);
    setState(() {
      customerDetails = customer;
      getLandDetails();
    });
  }

  void getOrderDetail() async {
    final order = await OrderController().getOrderById(widget.order_id);
    setState(() {
      orderDetails = order;
      print(order.id);
      getCustomerDetails();
    });
  }

  @override
  void initState() {
    super.initState();
    getOrderDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Detail',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: TextFormField(
                              readOnly: true,
                              controller: orderIdController,
                              expands: false,
                              decoration: InputDecoration(
                                  labelText: 'Invoice Number',
                                  labelStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: SizedBox(
                            height: 60,
                            child: TextFormField(
                              readOnly: true,
                              controller: dateController,
                              expands: false,
                              decoration: InputDecoration(
                                  labelText: 'Date',
                                  labelStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Theme.of(context).primaryColor),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        readOnly: true,
                        controller: CustomerNameController,
                        expands: false,
                        decoration: InputDecoration(
                            labelText: 'Customer Name',
                            labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ),
                    SizedBox(
                      height: 60,
                      child: TextFormField(
                        readOnly: true,
                        controller: LandNameController,
                        expands: false,
                        decoration: InputDecoration(
                            labelText: 'Land Name',
                            labelStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor),
                            border: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            )),
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Order Items
                    const Text('Order Items',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 5),

                    SizedBox(
                      width: double.infinity,
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                //show item number
                                leading: CircleAvatar(
                                  child: Text((index + 1).toString()),
                                ),
                                title: const Text(
                                  'Plant Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: const Text(
                                    'Qnt: 10    Unit price: 120.00 LKR\nTotal: 1200.00 LKR'),
                              ),
                            );
                          }),
                    ),

                    //order summary details
                    const Column(
                      children: [
                        SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Total:  1200.00 LKR',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // const SizedBox(height: 30),
                    // SizedBox(
                    //   width: double.infinity,
                    //   height: 60,
                    //   child: OutlinedButton(
                    //       onPressed: () {}, child: const Text('Quotation')),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }
}
