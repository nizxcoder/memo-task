import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/api.dart';
import 'package:flutter_frontend/utils/controller.dart';
import 'package:flutter_frontend/utils/utils.dart';
import 'package:flutter_frontend/widgets/button.dart';
import 'package:flutter_frontend/widgets/itemcard.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppController appController = Get.find<AppController>();
  TextEditingController itemController = TextEditingController();

  List items = [];
  bool isLoading = true;
  bool buttonLoading = false;

  Future<void> fetchItems() async {
    try {
      final res = await ApiCall().getItems();
      if (mounted) {
        if (res.statusCode == 200) {
          appController.items.value = res.response as List;
        } else if ([401, 403].contains(res.statusCode)) {
          showToast(message: res.response['message']);
        }
      }
    } catch (e) {
      showToast(message: e.toString());
    } finally {
      Future.delayed(
        const Duration(seconds: 1),
        () => setState(() {
          isLoading = false;
        }),
      );
    }
  }

  Future<void> addItem(String item) async {
    try {
      Map<String, dynamic> data = {'name': item};
      final res = await ApiCall().addItem(
        body: data,
      );
      if (res.statusCode == 201) {
        appController.items.add(res.response);
        showToast(message: 'Item added successfully');
      } else {
        showToast(message: res.response['message']);
      }
    } catch (e) {
      showToast(message: e.toString());
    } finally {
      setState(() {
        buttonLoading = false;
        itemController.clear();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    appController.items.clear();
    itemController.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await fetchItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 5,
          surfaceTintColor: const Color.fromARGB(250, 255, 255, 255),
          backgroundColor: const Color.fromARGB(250, 255, 255, 255),
          shadowColor: const Color.fromARGB(75, 255, 255, 255),
          title: const Text('Memo'),
          actions: [
            !buttonLoading
                ? IconButton(
                    onPressed: () => showAddItemModal(context),
                    icon: const Icon(Icons.add),
                  )
                : const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                      strokeWidth: 2,
                    ),
                  ),
          ],
        ),
        body: Stack(
          children: [
            Obx(
              () => ListView(
                children: [
                  ...appController.items.map((e) => ItemCard(data: e)),
                ],
              ),
            ),
            if (isLoading)
              Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height,
                child: const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    strokeWidth: 2,
                  ),
                ),
              ),
          ],
        ));
  }

  void showAddItemModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 4,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add Item',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: itemController,
                  decoration: const InputDecoration(
                    hintText: 'Enter item name',
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: '    Add    ',
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  onPressed: () {
                    setState(() {
                      buttonLoading = true;
                    });
                    Future.delayed(const Duration(seconds: 1), () async {
                      await addItem(itemController.text);
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
