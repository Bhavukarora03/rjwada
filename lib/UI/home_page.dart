import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rjwada/Getx/getx_controller.dart';
import 'package:rjwada/UI/unity.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOpened = false;
  final DataController imageController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick an Image"),
      ),
      body: Column(
        children: [
          Obx(
            () => imageController.compressImagePath.value == ''
                ? const Text(
                    'Select image from camera/galley',
                    style: TextStyle(fontSize: 20),
                  )
                : Image.file(
                    File(imageController.compressImagePath.value),
                    width: double.infinity,
                    height: 300,
                  ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                isOpened = true;
              });
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
                        },
                      ),
                      ListTile(
                        title: const Text("Gallery"),
                        leading: const Icon(Icons.photo),
                        onTap: () {
                          imageController.getImage(ImageSource.gallery);
                        },
                      ),
                    ]);
                  });
              //
            },
            icon: const Icon(Icons.upload),
            label: const Text("Pick Files"),
          ),
          ElevatedButton.icon(
            onPressed: () {Get.to(()=> UnityScreen());},
            icon: const Icon(Icons.account_circle_rounded),
            label: const Text("Unity Widget"),
          )
        ],
      ),
    );
  }
}
