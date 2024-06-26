import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/controllers/land_controller.dart';
import 'package:tamronblue_frontend/controllers/land_plant_controller.dart';
import 'package:tamronblue_frontend/controllers/plant_controller.dart';
import 'package:tamronblue_frontend/controllers/variety_controller.dart';
import 'package:tamronblue_frontend/models/Customer.dart';
import 'package:tamronblue_frontend/models/Land.dart';
import 'package:tamronblue_frontend/models/LandPlant.dart';
import 'package:tamronblue_frontend/screens/customer/customerdetail.dart';

class LandDetail extends StatefulWidget {
  const LandDetail(
      {super.key, required this.land_id, required this.isCustomerField});
  final int land_id;
  final bool isCustomerField;

  @override
  State<LandDetail> createState() => _LandDetailState();
}

class _LandDetailState extends State<LandDetail> {
  LandController landController = LandController();
  LandPlantController landPlantController = LandPlantController();
  PlantController plantController = PlantController();
  VarietyController varietyController = VarietyController();
  CustomerController customerController = CustomerController();

  late LatLng location;
  late Land landDetails;
  late Customer customerDetails;

  late List<LandPlant> landPlantsList;
  var plantMap = Map<String, String>();
  var varietyMap = Map<String, String>();

  bool isLoading = true;

  void getCustomerDetails() async {
    final customer =
        await customerController.getCustomerById(landDetails.customer_id);
    setState(() {
      customerDetails = customer;
      isLoading = false;
    });
  }

  void getLocation() {
    final List<String> latlong = landDetails.google_map.split(', ');
    final double lat = double.parse(latlong[0]);
    final double long = double.parse(latlong[1]);

    location = LatLng(lat, long);
    getCustomerDetails();
  }

  void getVarietiesList() async {
    varietyMap.clear();
    final varieties = await varietyController.getAllVarieties();
    for (var variety in varieties) {
      varietyMap[variety.id.toString()] = variety.name;
    }
    getLocation();
  }

  void getPlantList() async {
    plantMap.clear();
    final plants = await plantController.getAllPlants();
    for (var plant in plants) {
      plantMap[plant.id.toString()] = plant.name;
    }
    getVarietiesList();
  }

  void getLandPlantDetails() async {
    final landPlants =
        await landPlantController.getPlantsInLandByLandId(widget.land_id);
    setState(() {
      landPlantsList = landPlants;
      getPlantList();
    });
  }

  void getLandDetails() async {
    final land = await landController.getLandById(widget.land_id);
    setState(() {
      landDetails = land;
      getLandPlantDetails();
    });
  }

  @override
  void initState() {
    super.initState();
    getLandDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Land Details',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              //popup menu
              showMenu(
                  context: context,
                  position: const RelativeRect.fromLTRB(100, 80, 0, 0),
                  items: [
                    PopupMenuItem(
                      child: ListTile(
                        title: const Text('Edit'),
                        onTap: () {},
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: const Text('Delete'),
                        onTap: () {},
                      ),
                    ),
                  ]);
            },
            icon: const Icon(Iconsax.more),
          ),
        ],
      ),
      body: isLoading // Check loading state
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // const Text('Land Details',
                    //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    // const SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          readOnly: true,
                          initialValue: landDetails.name,
                          expands: false,
                          decoration:  InputDecoration(
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
                        const SizedBox(height: 5),
                        TextFormField(
                          readOnly: true,
                          initialValue:
                              '${landDetails.address}, ${landDetails.district}, ${landDetails.region}',
                          expands: false,
                          decoration:  InputDecoration(
                              labelText: 'Address',
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
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                initialValue: landDetails.area.toString(),
                                expands: false,
                                decoration:  InputDecoration(
                                    labelText: 'Area (in acres)',
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
                            const SizedBox(width: 20),
                            Expanded(
                              child: TextFormField(
                                readOnly: true,
                                initialValue: landDetails.agricultural_zone,
                                expands: false,
                                decoration: InputDecoration(
                                    labelText: 'Agricultural Zone',
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
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 2 - 20,
                          child: TextFormField(
                            readOnly: true,
                            initialValue: landDetails.Density,
                            expands: false,
                            decoration:  InputDecoration(
                                labelText: 'Density',
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
                        const SizedBox(height: 5),
                        TextFormField(
                          readOnly: true,
                          initialValue: landDetails.acclimatization,
                          expands: false,
                          decoration:  InputDecoration(
                              labelText: 'Acclimatization',
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
                        const SizedBox(height: 5),
                        TextFormField(
                          maxLines: 3,
                          minLines: 1,
                          readOnly: true,
                          initialValue: landDetails.description,
                          expands: false,
                          decoration: InputDecoration(
                              labelText: 'Description',
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
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text('Location :',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColor)),
                    const SizedBox(height: 5),
                    Container(
                      width: double.infinity,
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: location,
                          zoom: 14,
                        ),
                        mapType: MapType.hybrid,
                        markers: {
                          Marker(
                            markerId: const MarkerId('marker_1'),
                            position: location,
                            infoWindow: InfoWindow(
                              title: landDetails.name,
                              snippet:
                                  '${landDetails.address}, ${landDetails.district}, ${landDetails.region}',
                            ),
                            icon: BitmapDescriptor.defaultMarker,
                          ),
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text('Plant Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    ListView.builder(
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: FaIcon(
                              FontAwesomeIcons.seedling,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(
                                '${plantMap[landPlantsList[index].plant_id.toString()]} - ${varietyMap[landPlantsList[index].variety_id.toString()]}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            subtitle: Text(
                                'Monthly requirements:  ${landPlantsList[index].monthly_requirements}\nAnnual requirements:    ${landPlantsList[index].annual_requirements}'),
                          ),
                        );
                      },
                      itemCount: landPlantsList.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                    ),
                    const SizedBox(height: 20),
                    const Text('Customer Details',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    Card(
                      child: ListTile(
                        leading: Icon(
                          Iconsax.user,
                          color: Theme.of(context).primaryColor,
                        ),
                        title: Text(
                            '${customerDetails.first_name} ${customerDetails.last_name}',
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                            'Email: ${customerDetails.email}\nPhone: ${customerDetails.phone}'),
                        trailing: Icon(
                          Iconsax.arrow_right_3,
                          color: Theme.of(context).primaryColor,
                        ),
                        onTap: () {
                          widget.isCustomerField
                              ? Get.back()
                              : Get.to(() => CustomerDetail(
                                  customer_id: customerDetails.id));
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
