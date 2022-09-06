
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:rjwada/Getx/getx_controller.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String verficationId;
  const OtpVerificationScreen({
    Key? key,
    required this.verficationId,
  }) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  var data = Get.arguments;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
   leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back_ios)),



      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 20, top: 20),
            child: Text("Verification Code",
                style: TextStyle(
                    fontSize: 30,
                    color: Colors.black87,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1)),
          ),
          const SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
                "Enter OTP code sent to your phone number "
                "$data",
                style: const TextStyle(fontSize: 18, color: Colors.black87)),
          ),
          SizedBox(
            height: 50,
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Pinput(
                length: 6,
                onCompleted: (String value) {

                  CoolAlert.show(context: context, type: CoolAlertType.loading, backgroundColor: Colors.black87);
                  Get.find<DataController>()
                      .verifyOtpCode(value, widget.verficationId);
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
