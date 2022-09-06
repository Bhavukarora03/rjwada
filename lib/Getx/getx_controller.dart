import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rjwada/UI/home_page.dart';

class DataController extends GetxController {
  static DataController get to => Get.find<DataController>();

  FirebaseAuth auth = FirebaseAuth.instance;

  var selectedImagePath = ''.obs;
  var selectedImageSize = ''.obs;


  var cropImagePath = ''.obs;
  var cropImageSize = ''.obs;


  var compressImagePath = ''.obs;
  var compressImageSize = ''.obs;

  RxBool hasInternet = false.obs;

  StreamSubscription? internetSubscription;

  @override
  void dispose() {
    internetSubscription!.cancel();
    super.dispose();
  }

  void getImage(ImageSource imageSource) async {
    final pickedFile = await ImagePicker().pickImage(source: imageSource);
    if (pickedFile != null) {
      selectedImagePath.value = pickedFile.path;
      selectedImageSize.value =
          "${((File(selectedImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)} Mb";

      // Crop
      final cropImageFile = await ImageCropper().cropImage(
          sourcePath: selectedImagePath.value,
          maxWidth: 512,
          maxHeight: 512,
          compressFormat: ImageCompressFormat.jpg);
      cropImagePath.value = cropImageFile!.path;
      cropImageSize.value =
          "${((File(cropImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)} Mb";

      // Compress

      final dir = Directory.systemTemp;
      final targetPath = "${dir.absolute.path}/temp.jpg";
      var compressedFile = await FlutterImageCompress.compressAndGetFile(
          cropImagePath.value, targetPath,
          quality: 90);
      compressImagePath.value = compressedFile!.path;
      compressImageSize.value =
          "${((File(compressImagePath.value)).lengthSync() / 1024 / 1024).toStringAsFixed(2)} Mb";

      // uploadImage(compressedFile);
    } else {
      Get.snackbar('Error', 'No image selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> registerUserWithPhone(String phone) async {
    auth.verifyPhoneNumber(
        phoneNumber: phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          Get.to(() => const HomeScreen());
        },
        verificationFailed: (FirebaseAuthException exception) {
          Get.snackbar('Verification Failed', 'for some reason',
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              messageText: Text(
                exception.toString(),
                style: const TextStyle(color: Colors.white),
              ));
        },
        codeSent: (String verificationID, int? code) {
          AuthCredential credential = PhoneAuthProvider.credential(
              verificationId: verificationID, smsCode: code.toString());
          final user = auth.signInWithCredential(credential);
          if (user == null) {
            Get.offAll(() => const HomeScreen());
          } else {
            Get.snackbar('Couldnt verifyPhoneNumber', 'sorry',
                snackPosition: SnackPosition.TOP, colorText: Colors.white);
          }
        },
        codeAutoRetrievalTimeout: (String verificationID) {});
  }


  checkInternetConnection() {
    internetSubscription =
        InternetConnectionChecker().onStatusChange.listen((status) {
      final hasInternet = status == InternetConnectionStatus.connected;
      this.hasInternet.value = hasInternet;
      hasInternet
          ? null
          : showSimpleNotification(
              const Text(
                "No Internet connection",
              ),
              background: Colors.red.shade800);
    });
  }
}
