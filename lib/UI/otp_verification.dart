
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key, })
      : super(key: key);



  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  var data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        title: const Text("Enter OTP"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          const Text("VERIFICATION",
              style: TextStyle(
                  fontSize: 30,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1)),
          Text("Enter the code to your number "
              "$data",
              style: const TextStyle(fontSize: 15)),
          Pinput(
            length: 6,
            onSubmitted: (String value) {} ,
            onCompleted: (String value) {},
          )
        ],
      ),
    );
  }
}
