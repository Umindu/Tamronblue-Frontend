import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/controllers/profile_controller.dart';
import 'package:tamronblue_frontend/screens/home.dart';
import 'package:tamronblue_frontend/utils/dropdown_list.dart';

class AddProfileSplash extends StatefulWidget {
  const AddProfileSplash({super.key});

  @override
  State<AddProfileSplash> createState() => _AddProfileSplashState();
}

class _AddProfileSplashState extends State<AddProfileSplash> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  TextEditingController nicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController zipController = TextEditingController();

  int _gender = 1;
  String gender = 'Male';

  String? districtSelectedValue;
  String? regionSelectedValue;

  String first_name = ' ';
  String last_name = ' ';
  String email = ' ';

  int step = 1;

  void getNameEmail() async {
    final SharedPreferences prefs = await _prefs;

    setState(() {
      first_name = prefs.getString('first_name')!;
      last_name = prefs.getString('last_name')!;
      email = prefs.getString('email')!;
    });
  }

  @override
  void initState() {
    super.initState();
    getNameEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: step != 1
          ? AppBar(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(0),
                ),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    step = step - 1;
                  });
                },
              ),
            )
          : null,
      body: step == 1
          ? firstPage()
          : step == 2
              ? secondPage()
              : thirdPage(),
    );
  }

  Widget firstPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          CircleAvatar(
            radius: 50,
            child: Text(
                first_name[0].toUpperCase() + last_name[0].toUpperCase(),
                style: const TextStyle(fontSize: 30)),
          ),
          const SizedBox(height: 20),
          Text(
            '$first_name $last_name',
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 10),
          Text(
            email,
            style: const TextStyle(fontSize: 15),
          ),
          const Spacer(),
          SizedBox(
            width: 130,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  step = 2;
                });
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Next', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 10),
                  Icon(Icons.arrow_forward_ios),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget secondPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: Get.height - 80),
          child: IntrinsicHeight(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text('Profile Setup',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor)),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 6),
                          child: SizedBox(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              controller: nicController,
                              maxLength: 12,
                              expands: false,
                              decoration: const InputDecoration(
                                labelText: 'NIC Number',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                                counterText: '',
                              ),
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.length < 12) {
                                  return 'Please enter your NIC number';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 12),
                          child: SizedBox(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: _gender,
                                    onChanged: (value) => {
                                          setState(() {
                                            _gender = value as int;
                                            gender = 'Male';
                                          })
                                        }),
                                const Text('Male'),
                                const SizedBox(width: 10),
                                Radio(
                                    value: 2,
                                    groupValue: _gender,
                                    onChanged: (value) => {
                                          setState(() {
                                            _gender = value as int;
                                            gender = 'Female';
                                          })
                                        }),
                                const Text('Female')
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 6),
                        child: SizedBox(
                          width: 300,
                          child: TextFormField(
                            keyboardType: TextInputType.phone,
                            controller: phoneController,
                            maxLength: 15,
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              counterText: '',
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty) {
                                return 'Please enter your phone number';
                              }else if(value.length < 10){
                                return 'Phone number is not valid';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
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
                            return 'Please enter your address';
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
                              top: 6, bottom: 6, right: 5, left: 5),
                          child: SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'District',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
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
                                  return 'Please select a district';
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
                              top: 6, bottom: 6, left: 5, right: 5),
                          child: SizedBox(
                            width: 200,
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                labelText: 'Region',
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                              value: regionSelectedValue,
                              onChanged: (String? value) {
                                setState(() {
                                  regionSelectedValue = value;
                                });
                              },
                              items:
                                  DropDownList.getRegion().map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a region';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 6),
                        child: SizedBox(
                          width: 150,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: zipController,
                            maxLength: 5,
                            expands: false,
                            decoration: const InputDecoration(
                              labelText: 'Zip',
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              counterText: '',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your zip code';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  const Spacer(),
                  SizedBox(
                    width: 130,
                    height: 50,
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

                          bool response =
                              await ProfileController().addMyDetails(
                            first_name,
                            last_name,
                            email,
                            nicController.text,
                            gender,
                            phoneController.text,
                            addressController.text,
                            districtSelectedValue!,
                            regionSelectedValue!,
                            zipController.text,
                          );
                          if (response) {
                            Navigator.pop(context);
                            setState(() {
                              step = 3;
                            });
                          }else{
                            Navigator.pop(context);
                          }
                        }
                      },
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Next', style: TextStyle(fontSize: 20)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget thirdPage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, $first_name $last_name',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor),
            ),
            const Spacer(),
            const Image(
              image: AssetImage('assets/images/vector-1.png'),
              height: 300,
              width: 300,
            ),
            const SizedBox(
              height: 40,
            ),
            const Text(
              'You have successfully created your profile',
            ),
            const Text(
              'You can now start using the app',
            ),
            const SizedBox(
              height: 20,
            ),
            const Spacer(),
            SizedBox(
              width: 160,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Get.offAll(() => const Home());
                },
                child:
                    const Text('Get Started', style: TextStyle(fontSize: 20)),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
