import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/controllers/order_controller.dart';
import 'package:tamronblue_frontend/controllers/plant_controller.dart';
import 'package:tamronblue_frontend/controllers/variety_controller.dart';

class AddOrder extends StatefulWidget {
  const AddOrder({super.key});

  @override
  State<AddOrder> createState() => _AddOrderState();
}

class _AddOrderState extends State<AddOrder> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _productFormKey = GlobalKey<FormState>();

  CustomerController customerController = CustomerController();
  LandController landController = LandController();
  final MultiSelectController _controller = MultiSelectController();
  final List<ValueItem> _selectedOptions = [];

  PlantController plantController = PlantController();
  VarietyController varietyController = VarietyController();

  bool isShowAddItem = false;

  TextEditingController qntController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  int customer_id = 0;
  int land_id = 0;

  String? customerSelectedValue;
  String? landSelectedValue;
  String? plantSelectedValue;
  String? varietySelectedValue;

  var customers;
  var lands;
  var plants;
  var varieties;

  double total = 0;

  List<String> customerList = [];
  List<String> landList = [];
  List<String> plantList = [];
  List<String> varietyList = [];

  List<Map<String, dynamic>> showOrderItemsList = [];
  List<Map<String, dynamic>> OrderItemsList = [];

  //plant list make function
  void getPlantList() async {
    plantList.clear();
    plants = await plantController.getAllPlants();
    for (var plant in plants) {
      plantList.add(plant.name);
    }
    setState(() {
      plantList = plantList;
    });
  }

  //variety list make function
  void getVarietyList(String plantName) async {
    varietyList.clear();
    //get plant id
    var id = plants.firstWhere((element) => element.name == plantName).id;

    // get variety
    varieties = await varietyController.getVarietiesByPlantId(id);
    for (var variety in varieties) {
      varietyList.add(variety.name);
    }
    setState(() {
      varietyList = varietyList;
      print(varietyList);
    });
  }

  // land list make function
  void getLandList() async {
    landList.clear();
    lands = await landController.getCustomerLandsList(customer_id);
    for (var land in lands) {
      landList.add(land.name);
    }
    setState(() {
      landList = landList;
    });
  }

  //get Land id
  void getLandId(String landName) {
    land_id = lands.firstWhere((element) => element.name == landName).id;
  }

  //customer list make function
  void getCustomerList() async {
    customers = await customerController.getMyAllCustomersList();
    for (var customer in customers) {
      customerList.add(customer.first_name + ' ' + customer.last_name);
    }
    setState(() {
      customerList = customerList;
    });
  }

  //get customer id
  void getCustomerId(String customerName) {
    customer_id = customers
        .firstWhere((element) =>
            element.first_name + ' ' + element.last_name == customerName)
        .id;
  }

  @override
  void initState() {
    super.initState();
    getCustomerList();
    getPlantList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Order',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: Get.height - 80,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Customer Details
              Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Customer Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Select Customer',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          value: customerSelectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              customerSelectedValue = value;
                              landSelectedValue = null;
                              getCustomerId(customerSelectedValue!);
                              getLandList();
                            });
                          },
                          items: customerList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a customer';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 10),
                      // Land Details
                      const Text('Land Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: DropdownButtonFormField<String>(
                          decoration: const InputDecoration(
                              labelText: 'Select Land',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          value: landSelectedValue,
                          onChanged: (String? value) {
                            setState(() {
                              landSelectedValue = value;
                              getLandId(landSelectedValue!);
                            });
                          },
                          items: landList.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a land';
                            }
                            return null;
                          },
                        ),
                      ),

                      // // multi land select dropdown
                      // MultiSelectDropDown(
                      //   controller: _controller,
                      //   clearIcon: const Icon(Icons.reddit),
                      //   onOptionSelected: (options) {},
                      //   options: landList
                      //       .map((e) => ValueItem(label: e, value: e))
                      //       .toList(),
                      //   maxItems: 4,
                      //   singleSelectItemStyle: const TextStyle(
                      //       fontSize: 16, fontWeight: FontWeight.bold),
                      //   chipConfig: const ChipConfig(
                      //       wrapType: WrapType.wrap,
                      //       backgroundColor: Colors.red),
                      //   optionTextStyle: const TextStyle(fontSize: 16),
                      //   selectedOptionIcon: const Icon(
                      //     Icons.check_circle,
                      //     color: Colors.pink,
                      //   ),
                      //   selectedOptionBackgroundColor: Colors.grey.shade300,
                      //   selectedOptionTextColor: Colors.blue,
                      //   dropdownMargin: 2,
                      //   onOptionRemoved: (index, option) {},
                      //   optionBuilder: (context, valueItem, isSelected) {
                      //     return ListTile(
                      //       title: Text(valueItem.label),
                      //       subtitle: Text(valueItem.value.toString()),
                      //       trailing: isSelected
                      //           ? const Icon(Icons.check_circle)
                      //           : const Icon(Icons.radio_button_unchecked),
                      //     );
                      //   },
                      // ),

                      const SizedBox(height: 10),

                      //Order Details
                      const Text('Order Details',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),

                      SizedBox(
                        width: double.infinity,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: showOrderItemsList.length,
                            itemBuilder: (context, index) {
                              return Card(
                                child: ListTile(
                                  //show item number
                                  leading: CircleAvatar(
                                    child: Text((index + 1).toString()),
                                  ),
                                  title: Text(
                                    showOrderItemsList[index]['plant'] +
                                        ' (' +
                                        showOrderItemsList[index]['variety'] +
                                        ')',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                      'Qnt: ${showOrderItemsList[index]['quantity']}    Unit price: ${showOrderItemsList[index]['price']} LKR\nTotal: ${showOrderItemsList[index]['quantity'] * showOrderItemsList[index]['price']} LKR'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {
                                      setState(() {
                                        showOrderItemsList.removeAt(index);

                                        total = 0;
                                        for (var item in showOrderItemsList) {
                                          total += item['total'];
                                        }
                                      });
                                    },
                                  ),
                                ),
                              );
                            }),
                      ),
                      Form(
                        key: _productFormKey,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isShowAddItem = !isShowAddItem;
                                        });
                                      },
                                      child: const Text('Add Item',
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          isShowAddItem = !isShowAddItem;
                                        });
                                      },
                                      icon: isShowAddItem
                                          ? const Icon(Icons.close)
                                          : const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                                isShowAddItem == false
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          const SizedBox(height: 10),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                  labelText: 'Select Plant',
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)))),
                                              value: plantSelectedValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  plantSelectedValue = value;
                                                  varietySelectedValue = null;
                                                  getVarietyList(
                                                      plantSelectedValue!);
                                                });
                                              },
                                              items:
                                                  plantList.map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select a plant';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child:
                                                DropdownButtonFormField<String>(
                                              decoration: const InputDecoration(
                                                  labelText: 'Select Variety',
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                        color: Colors.black,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)))),
                                              value: varietySelectedValue,
                                              onChanged: (String? value) {
                                                setState(() {
                                                  varietySelectedValue = value;
                                                });
                                              },
                                              items: varietyList
                                                  .map((String value) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(value),
                                                );
                                              }).toList(),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select a variety';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: TextFormField(
                                                    controller: qntController,
                                                    expands: false,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Quantity',
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter a quantity';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 10),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 5),
                                                  child: TextFormField(
                                                    controller: priceController,
                                                    expands: false,
                                                    decoration:
                                                        const InputDecoration(
                                                      labelText: 'Price',
                                                      border:
                                                          OutlineInputBorder(
                                                              borderSide:
                                                                  BorderSide(
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          10))),
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                    validator: (value) {
                                                      if (value == null ||
                                                          value.isEmpty) {
                                                        return 'Please enter a price';
                                                      }
                                                      return null;
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 5),
                                          SizedBox(
                                            width: double.infinity,
                                            height: 60,
                                            child: OutlinedButton(
                                                onPressed: () {
                                                  if (_productFormKey
                                                      .currentState!
                                                      .validate()) {
                                                    setState(() {
                                                      showOrderItemsList.add({
                                                        'plant':
                                                            plantSelectedValue,
                                                        'variety':
                                                            varietySelectedValue,
                                                        'quantity': int.parse(
                                                            qntController.text),
                                                        'price': double.parse(
                                                            priceController
                                                                .text),
                                                        'total': int.parse(
                                                                qntController
                                                                    .text) *
                                                            double.parse(
                                                                priceController
                                                                    .text)
                                                      });

                                                      OrderItemsList.add({
                                                        'plant': plants
                                                            .firstWhere((element) =>
                                                                element.name ==
                                                                plantSelectedValue)
                                                            .id,
                                                        'variety': varieties
                                                            .firstWhere((element) =>
                                                                element.name ==
                                                                varietySelectedValue)
                                                            .id,
                                                        'quantity': int.parse(
                                                            qntController.text),
                                                        'unit_price':
                                                            double.parse(
                                                                priceController
                                                                    .text),
                                                        'discount': 0,
                                                        'tax': 0,
                                                        'subtotal': int.parse(
                                                                qntController
                                                                    .text) *
                                                            double.parse(
                                                                priceController
                                                                    .text)
                                                      });

                                                      total = 0;
                                                      for (var item
                                                          in showOrderItemsList) {
                                                        total += item['total'];
                                                      }

                                                      isShowAddItem =
                                                          !isShowAddItem;

                                                      plantSelectedValue = null;
                                                      varietySelectedValue =
                                                          null;
                                                      qntController.clear();
                                                      priceController.clear();
                                                    });
                                                  }
                                                },
                                                child: const Text('Add Item')),
                                          ),
                                        ],
                                      ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              //order summary details
              Padding(
                padding: const EdgeInsets.all(5),
                child: Column(
                  children: [
                    showOrderItemsList.isEmpty
                        ? const SizedBox()
                        : Column(
                            children: [
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    'Total:  ${total} LKR',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text('Quotation')),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (showOrderItemsList.isNotEmpty) {
                                  OrderController().addOrder(customer_id,
                                      land_id, total, OrderItemsList);
                                } else {
                                  Get.snackbar('Item error',
                                      'Please add items to the order',
                                      icon: const Icon(Icons.error));
                                }
                              }
                            },
                            child: const Text('Add Order'))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
