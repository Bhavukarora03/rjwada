import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rjwada/Getx/getx_controller.dart';
import 'package:rjwada/UI/otp_verification.dart';

class AuthenticatonPage extends StatefulWidget {
  const AuthenticatonPage({Key? key}) : super(key: key);

  @override
  State<AuthenticatonPage> createState() => _AuthenticatonPageState();
}

class _AuthenticatonPageState extends State<AuthenticatonPage> {
  @override
  void initState() {
    Get.find<DataController>().checkInternetConnection();
    super.initState();
  }

  String? phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sign in")),
      body: Column(
        children: [
          IntlPhoneField(
            dropdownTextStyle: const TextStyle(color: Colors.black),
            dropdownIcon: const Icon(
              Icons.arrow_drop_down,
              color: Colors.black,
            ),
            style: const TextStyle(color: Colors.black),
            // decoration: kInputDecorationPhoneNumber,
            initialCountryCode: 'IN',
            onChanged: (phone) {
              phoneNumber = phone.completeNumber;
            },
            flagsButtonPadding: const EdgeInsets.all(10.0),
          ),
          ElevatedButton.icon(
              onPressed: () {
                //Get.find<DataController>().registerUserWithPhone(phoneNumber!);
                Get.to(() => const OtpVerificationScreen(), arguments: phoneNumber);
              },
              icon: const Icon(Icons.phone),
              label: const Text("Phone"))
        ],
      ),
    );
  }
}
