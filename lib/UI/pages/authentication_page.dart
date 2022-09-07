import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rjwada/Getx/getx_controller.dart';

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

  late String phoneNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text(
              'Sign In',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: IntlPhoneField(
              dropdownTextStyle: const TextStyle(color: Colors.black),
              dropdownIcon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
              style: const TextStyle(color: Colors.black),
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black)),
              ),
              initialCountryCode: 'IN',
              onChanged: (phone) {
                phoneNumber = phone.completeNumber;
              },
              flagsButtonPadding: const EdgeInsets.all(10.0),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)))),
                  onPressed: () {
                    CoolAlert.show(
                      context: context,
                      type: CoolAlertType.loading,
                    );
                    Get.find<DataController>()
                        .registerUserWithPhone(phoneNumber);
                  },
                  icon: const Icon(
                    Icons.phone,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Proceed",
                    style: TextStyle(color: Colors.white),
                  ))),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
            child: SignInButton(
              Buttons.Google,
              onPressed: () {
                Get.find<DataController>().googleSignInMethod();
              },
            ),
          )
        ],
      ),
    );
  }
}
