import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tamronblue_frontend/controllers/login_controller.dart';
import 'package:tamronblue_frontend/controllers/profile_controller.dart';
import 'package:tamronblue_frontend/controllers/registeration_controller.dart';
import 'package:tamronblue_frontend/screens/auth/forgotpassword.dart';
import 'package:tamronblue_frontend/screens/home.dart';
import 'package:tamronblue_frontend/screens/profile/splashaddprofile.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  RegistrationController registrationController =
      Get.put(RegistrationController());
  LoginController loginController = Get.put(LoginController());

  var isLogin = true.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: MediaQuery.of(context).size.height,
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLogin.value ? loginWidget() : registerWidget(),
              ],
            ),
          ),
        ),
      ),
    ));
  }

  Widget registerWidget() {
    return Form(
      key: _registerFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Welcome to ',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor),
              ),
              Text(
                'Tamronblue',
                style: GoogleFonts.playball(
                  textStyle: Theme.of(context).textTheme.displayLarge,
                  fontSize: 32,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          Text(
            'Sign up to get started',
            style:
                TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: registrationController.firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: registrationController.lastNameController,
              decoration: const InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: registrationController.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: registrationController.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                } else if (value.length < 8) {
                  return 'Password must be at least 8 characters';
                } else if (!RegExp(r'^(?=.*?[A-Z])').hasMatch(value)) {
                  return 'Password must contain at least one uppercase letter';
                } else if (!RegExp(r'^(?=.*?[a-z])').hasMatch(value)) {
                  return 'Password must contain at least one lowercase letter';
                } else if (!RegExp(r'^(?=.*?[0-9])').hasMatch(value)) {
                  return 'Password must contain at least one number';
                } else if (!RegExp(r'^(?=.*?[!@#\$&*~])').hasMatch(value)) {
                  return 'Password must contain at least one special character';
                } else if (value.contains(' ')) {
                  return 'Password must not contain spaces';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: registrationController.RePasswordController,
              decoration: const InputDecoration(
                labelText: 'Re-enter Password',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please re-enter your password';
                } else if (value !=
                    registrationController.passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
                onPressed: () async {
                  registrationController.firstNameController.text =
                      registrationController.firstNameController.text.trim();
                  registrationController.lastNameController.text =
                      registrationController.lastNameController.text.trim();
                  registrationController.emailController.text =
                      registrationController.emailController.text.trim();
                  registrationController.passwordController.text =
                      registrationController.passwordController.text.trim();
                  registrationController.RePasswordController.text =
                      registrationController.RePasswordController.text.trim();

                  if (_registerFormKey.currentState!.validate()) {
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
                        await registrationController.registerWithEmail();
                    setState(() {
                      if (response) {
                        isLogin.value = true;
                      }
                    });
                  }
                },
                child: const Text('Register'),
              ),
            ),
          ),
          Row(
            children: [
              const Text('Already have an account?'),
              TextButton(
                onPressed: () {
                  isLogin.value = true;
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget loginWidget() {
    return Form(
      key: _loginFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome Back,',
            style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
          ),
          Text(
            'Login to your account',
            style:
                TextStyle(fontSize: 20, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: loginController.emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: TextFormField(
              controller: loginController.passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10))),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  Get.to(() => const ForgotPassword());
                },
                child: Text('Forgot Password?',
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 15)),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: SizedBox(
              height: 60,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ))),
                onPressed: () async {
                  loginController.emailController.text =
                      loginController.emailController.text.trim();
                  loginController.passwordController.text =
                      loginController.passwordController.text.trim();

                  if (_loginFormKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      },
                    );

                    bool response = await loginController.logingWithEmail();
                    if (response) {
                      bool secondResponse = await ProfileController().getMyDetailsSaveShared();
                      if (secondResponse) {
                        Get.offAll(() => const Home());
                      }else{
                        Get.offAll(() => const AddProfileSplash());
                      }
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ),
          ),
          Row(
            children: [
              const Text('Don\'t have an account?'),
              TextButton(
                onPressed: () {
                  isLogin.value = false;
                },
                child: const Text('Register Now'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
