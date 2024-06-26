import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tamronblue_frontend/screens/settings/accounts/changepassword.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 23,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Iconsax.lock),
                title: const Text('Change Password'),
                onTap: () {
                  Get.to(() => const ChangePassword());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}