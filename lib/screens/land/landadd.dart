import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/controllers/plant_controller.dart';
import 'package:tamronblue_frontend/controllers/variety_controller.dart';
import 'package:tamronblue_frontend/utils/dropdown_list.dart';
import 'package:tamronblue_frontend/screens/land/getlocation.dart';

class AddLand extends StatefulWidget {
  const AddLand({super.key});

  @override
  State<AddLand> createState() => _AddLandState();
}

class _AddLandState extends State<AddLand> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  PlantController plantController = PlantController();
  VarietyController varietyController = VarietyController();
  CustomerController customerController = CustomerController();

  TextEditingController landNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController acclimatizationController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController requirementsMonthController = TextEditingController();
  TextEditingController requirementsAnnualController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  int customer_id = 0;

  String? densitySelectedValue;
  String? agriculturalZoneSelectedValue;
  String? districtSelectedValue;
  String? regionSelectedValue = 'Sri Lanka';
  String? customerSelectedValue;

  String? plantSelectedValue;
  String? varietySelectedValue;

  var plants;
  var varieties;
  var customers;

  List<String> plantList = [];
  List<String> varietyList = [];
  List<String> customerList = [];

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
    });
  }

  @override
  void initState() {
    super.initState();
    getPlantList();
    getCustomerList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Add Land',
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
                Form(
                  key: _formKey,
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Land Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: TextFormField(
                                controller: landNameController,
                                expands: false,
                                decoration: const InputDecoration(
                                  labelText: 'Land Name',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter land name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: TextFormField(
                                minLines: 3,
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                controller: addressController,
                                expands: false,
                                decoration: const InputDecoration(
                                  labelText: 'Address',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter address';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 5),
                                  child: SizedBox(
                                    width: 200,
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'District',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      value: districtSelectedValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          districtSelectedValue = value;
                                        });
                                      },
                                      items: DropDownList.getDistrict()
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select district';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5),
                                  child: SizedBox(
                                    width: 200,
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Region',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      value: regionSelectedValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          regionSelectedValue = value;
                                        });
                                      },
                                      items: DropDownList.getRegion()
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select region';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: TextFormField(
                                readOnly: true,
                                controller: locationController,
                                expands: false,
                                decoration: const InputDecoration(
                                  labelText: 'Pick Map Location',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select location';
                                  }
                                  return null;
                                },
                                onTap: () {
                                  Get.to(() => const GetLocation())
                                      ?.then((result) {
                                    if (result != null) {
                                      LatLng selectedLocation = result as LatLng;
                                      locationController.text =
                                          '${selectedLocation.latitude}, ${selectedLocation.longitude}';
                                    }
                                  });
                                },
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 5),
                                  child: SizedBox(
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Agricultural Zone',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      value: agriculturalZoneSelectedValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          agriculturalZoneSelectedValue = value;
                                        });
                                      },
                                      items:
                                          DropDownList.getAgriculturalZoneItem()
                                              .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select agricultural zone';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              ),
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 5),
                                  child: SizedBox(
                                    child: DropdownButtonFormField<String>(
                                      decoration: const InputDecoration(
                                        labelText: 'Density',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      value: densitySelectedValue,
                                      onChanged: (String? value) {
                                        setState(() {
                                          densitySelectedValue = value;
                                        });
                                      },
                                      items: DropDownList.getDensityItem()
                                          .map((String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select density';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(child: Container()),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: TextFormField(
                                controller: acclimatizationController,
                                expands: false,
                                decoration: const InputDecoration(
                                  labelText: 'Acclimatization',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter acclimatization';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 5),
                                  child: SizedBox(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: areaController,
                                      expands: false,
                                      decoration: const InputDecoration(
                                        labelText: 'Area',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter area';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(),
                              )
                            ],
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, right: 5),
                                  child: SizedBox(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: requirementsMonthController,
                                      expands: false,
                                      decoration: const InputDecoration(
                                        labelText: 'Requirements Month',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter requirements month';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 5),
                                  child: SizedBox(
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: requirementsAnnualController,
                                      expands: false,
                                      decoration: const InputDecoration(
                                        labelText: 'Requirements Annual',
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(10))),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter requirements annual';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: TextFormField(
                                controller: descriptionController,
                                expands: false,
                                maxLines: 3,
                                decoration: const InputDecoration(
                                  labelText: 'Description',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter description';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                    
                          //Customer Details
                          const Text('Customer Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                    labelText: 'Customer',
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                value: customerSelectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    customerSelectedValue = value;
                                    getCustomerId(customerSelectedValue!);
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
                                    return 'Please select customer';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                    
                          //Plant Details
                          const Text('Plant Details',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Plant',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                ),
                                value: plantSelectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    plantSelectedValue = value;
                                    varietySelectedValue = null;
                                    getVarietyList(plantSelectedValue!);
                                  });
                                },
                                items: plantList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select plant';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: SizedBox(
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  labelText: 'Variety',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10))),
                                ),
                                value: varietySelectedValue,
                                onChanged: (String? value) {
                                  setState(() {
                                    varietySelectedValue = value;
                                  });
                                },
                                items: varietyList.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please select variety';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ]),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: SizedBox(
                    height: 60,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                          );
                
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final agent_id = await prefs.getInt('id');
                          final branch_id = await prefs.getInt('branch');
                
                          if (agent_id != null || branch_id != null) {
                            bool response = await LandController().addLand(
                              landNameController.text,
                              customer_id,
                              addressController.text,
                              double.parse(areaController.text),
                              districtSelectedValue!,
                              agriculturalZoneSelectedValue!,
                              densitySelectedValue!,
                              acclimatizationController.text,
                              regionSelectedValue!,
                              locationController.text,
                              branch_id!,
                              agent_id!,
                              descriptionController.text,
                              true,
                              plants
                                  .firstWhere((element) =>
                                      element.name == plantSelectedValue)
                                  .id
                                  .toString(),
                              varieties
                                  .firstWhere((element) =>
                                      element.name == varietySelectedValue)
                                  .id
                                  .toString(),
                              requirementsMonthController.text,
                              requirementsAnnualController.text,
                            );
                
                            if (response != false) {
                              Navigator.pop(context);
                              Navigator.pop(context, true);
                              Get.snackbar(
                                  'Success', 'Land Added Successfully');
                            } else {
                              Navigator.pop(context);
                              Get.snackbar('Error', 'Something went wrong');
                            }
                          }else{
                            Navigator.pop(context);
                            Get.snackbar('Error', 'Something went wrong');
                          }
                        }
                      },
                      child: const Text('Add Land'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
