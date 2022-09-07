import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rjwada/UI/authentication_page.dart';
import 'package:rjwada/UI/home_page.dart';
import 'package:rjwada/UI/otp_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Provider/img_provider.dart';

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

  final _googlesignin = GoogleSignIn();
  var googleSignUser = Rx<GoogleSignInAccount?>(null);


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

      uploadImage(compressedFile);
    } else {
      Get.snackbar('Error', 'No image selected',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void uploadImage(File file) {
    Get.dialog(Center(child: CircularProgressIndicator(),),
      barrierDismissible: false,);
    ImageUploadProvider().uploadImage(file).then((resp) {
      Get.back();
      if (resp == "success") {
        Get.snackbar('Success', 'File Uploaded',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } else if (resp == "fail") {
        Get.snackbar('Error', 'File upload failed',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    }, onError: (err) {
      Get.back();
      Get.snackbar('Error', 'File upload failed',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    });
  }

  Future<void> registerUserWithPhone(String phone) async {
    auth.verifyPhoneNumber(
            phoneNumber: phone,
            timeout: const Duration(seconds: 60),
            verificationCompleted: (PhoneAuthCredential credential) {

            },
            verificationFailed: (FirebaseAuthException exception) {
              showOverlay(
                  (context, progress) => const Text('Verification Failed'));
            },
            codeSent: (String verificationID, int? code) {
             PhoneAuthProvider.credential(
                  verificationId: verificationID, smsCode: code.toString());

                Get.off(() => OtpVerificationScreen(
                      verficationId: verificationID,
                    ), arguments: phone);

            },
            codeAutoRetrievalTimeout: (String timer) {});
  }


  Future<void> verifyOtpCode(String otpCode, String verficationId) async {
    final credential = PhoneAuthProvider.credential(
        verificationId: verficationId, smsCode: otpCode);

    try {
      await auth.signInWithCredential(credential);
      final prefs = await SharedPreferences.getInstance();

      prefs.setString('phone', auth.currentUser!.phoneNumber ?? "");
      prefs.setString('uid', auth.currentUser!.uid);
      prefs.setString('name', auth.currentUser!.displayName??"");


      Get.offAll(() => const HomeScreen());
    } catch (e) {
      Get.snackbar('Error', '$e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
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
  googleSignInMethod() async {
    hasInternet.value = await InternetConnectionChecker().hasConnection;
    hasInternet.value
        ? null
        : showSimpleNotification(const Text("No Internet Connection"),
        background: Colors.red.shade700);

    hasInternet.value
        ? googleSignUser.value = (await _googlesignin.signIn())!
        : null;

    if (googleSignUser.value != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignUser.value!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here
        } else if (e.code == 'invalid-credential') {
          // handle the error here
        }
      } catch (e) {
        // handle the error here
      }
    }
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("name", googleSignUser.value!.displayName?? "");
    prefs.setString("mailID", googleSignUser.value!.email);
    prefs.setString("uid", googleSignUser.value!.id);





    try {
      if (googleSignUser.value == null) {
        Get.to(() => const AuthenticatonPage());
      } else {
        Get.offAll(() => const HomeScreen());
      }
    } catch (e) {
      // print(e);
    }
  }



  logout() async {
    await auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('phone');
    prefs.remove('uid');
    prefs.remove('name');

    if (auth.currentUser == null) {
      Get.off(() => const AuthenticatonPage());
    } else {
      Get.to(() => const HomeScreen());
    }
  }


}

