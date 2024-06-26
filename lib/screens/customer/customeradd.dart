import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamronblue_frontend/controllers/customer_controller.dart';
import 'package:tamronblue_frontend/utils/dropdown_list.dart';

class AddCustomer extends StatefulWidget {
  const AddCustomer({super.key});

  @override
  State<AddCustomer> createState() => _AddCustomerState();
}

class _AddCustomerState extends State<AddCustomer> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nicController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zipController = TextEditingController();
  int _gender = 1;
  String gender = 'Male';

  String? districtSelectedValue;
  String? regionSelectedValue = 'Sri Lanka';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Customer',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 10, right: 5, left: 5, bottom: 5),
                            child: SizedBox(
                              child: TextFormField(
                                controller: firstNameController,
                                expands: false,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your first name';
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
                                top: 10, right: 5, left: 5, bottom: 5),
                            child: SizedBox(
                              child: TextFormField(
                                controller: lastNameController,
                                expands: false,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.black,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your last name';
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: SizedBox(
                        child: TextFormField(
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          expands: false,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Please enter a valid email';
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 5),
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
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
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
                                horizontal: 5, vertical: 5),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                                value.isEmpty ||
                                value.length < 15) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
                                top: 5, bottom: 5, right: 5, left: 5),
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
                                top: 5, bottom: 5, left: 5, right: 5),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
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
              ),
              const SizedBox(height: 20),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ))),
                    onPressed: () async {
                      //validate form
                      if (_formKey.currentState!.validate()) {
                        //show CircularProgressIndicator while waiting for the response
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
              
                        //remove spaces
                        emailController.text = emailController.text.trim();
                        nicController.text = nicController.text.trim();
                        phoneController.text = phoneController.text.trim();
                        zipController.text = zipController.text.trim();
              
                        if (agent_id != null || branch_id != null) {
                          bool response = await CustomerController()
                              .addCustomer(
                                  firstNameController.text,
                                  lastNameController.text,
                                  emailController.text,
                                  gender,
                                  nicController.text,
                                  phoneController.text,
                                  addressController.text,
                                  districtSelectedValue.toString(),
                                  regionSelectedValue.toString(),
                                  zipController.text,
                                  branch_id!,
                                  agent_id!,
                                  true);
              
                          if (response) {
                            Navigator.pop(context);
                            Navigator.pop(context, true);
                            Get.snackbar(
                                'Success', 'Customer Added Successfully');
                          } else {
                            Navigator.pop(context);
                            Get.snackbar('Error', 'Something went wrong');
                          }
                        } else {
                          Navigator.pop(context);
                          Get.snackbar('Error', 'Something went wrong');
                        }
                      }
                    },
                    child: const Text('Add Customer'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
