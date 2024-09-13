import 'package:flutter/material.dart';
import 'package:flutter_frontend/pages/HomePage.page.dart';
import 'package:flutter_frontend/utils/controller.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
  Get.lazyPut(() => AppController());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Memo Task',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            secondary: Colors.black,
            primary: Colors.black),
        useMaterial3: true,
        fontFamily: 'Poppins',
      ),
      home: const HomePage(),
    );
  }
}
