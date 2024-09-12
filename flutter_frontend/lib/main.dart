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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
