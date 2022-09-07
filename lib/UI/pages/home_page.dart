import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rjwada/Getx/getx_controller.dart';
import 'package:rjwada/UI/unitygame_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  SharedPreferences? prefs;
  @override
  void initState() {
    initializeValues();
    super.initState();
  }

  String userName = '';

  initializeValues() async {
    prefs = await SharedPreferences.getInstance();
    var user = prefs?.getString("name");

    setState(() {
      userName = user!;
    });
  }

  bool isOpened = false;
  final DataController imageController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Get.find<DataController>().logout();
                },
                icon: const Icon(Icons.logout))
          ],
          automaticallyImplyLeading: false,
          title: userName == ''
              ? const Text(
                  "Hello 👋",
                  style: TextStyle(color: Colors.black),
                )
              : Text(
                  'Hello, $userName 👋',
                  style: const TextStyle(color: Colors.black),
                )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(
            () => imageController.compressImagePath.value == ''
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Select image from camera/galley.'
                            ' Make Sure to upload as [jpeg, jpg,]',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                : Center(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                          image: FileImage(
                              File(imageController.compressImagePath.value)),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 200,
                      width: 200,
                    ),
                  ),
          ),
          const SizedBox(
            height: 60,
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            onPressed: () {
              showModalBottomSheet(
                  isDismissible: true,
                  context: context,
                  builder: (context) {
                    return Wrap(children: [
                      ListTile(
                        title: const Text("Camera"),
                        leading: const Icon(Icons.camera_alt_sharp),
                        onTap: () {
                          imageController.getImage(ImageSource.camera);
                          Get.back();
                        },
                      ),
                      ListTile(
                        title: const Text("Gallery"),
                        leading: const Icon(Icons.photo),
                        onTap: () {
                          imageController.getImage(ImageSource.gallery);
                          Get.back();
                        },
                      ),
                    ]);
                  });
              //
            },
            icon: const Icon(
              Icons.upload,
              color: Colors.white,
            ),
            label: const Text(
              "Pick Files",
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black87,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)))),
            onPressed: () {
              Get.to(() => const UnityScreen());
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              color: Colors.white,
            ),
            label: const Text(
              "Unity Widget",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
