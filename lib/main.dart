import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:rjwada/Getx/getxbindings.dart';
import 'package:rjwada/UI/authentication_page.dart';
import 'package:rjwada/UI/splash_screen.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: GetxBindings(),
      theme: Theme.of(context).copyWith(useMaterial3: true,appBarTheme: AppBarTheme(color: Colors.transparent)),
      home: const SplashScreen(),
    );
  }
}
