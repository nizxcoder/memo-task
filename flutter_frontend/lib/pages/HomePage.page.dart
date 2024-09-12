import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  bool loading = false;

  Future<void> fetchItems() async {
    try {
      final res = await ApiCall().getItems();
      if (mounted) {
        if (res.statusCode == 200) {
          appController.items.value = res.response as List;
        } else {
          showToast(message: res.response['message']);
        }
      }
    } catch (e) {
      showToast(message: e.toString());
    } finally {
      setState(() {
        loading = false;
      });
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
        loading = false;
        itemController.clear();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    appController.items.clear();
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          forceMaterialTransparency: true,
          title: const Text('Memo'),
          actions: [
            !loading
                ? IconButton(
                    onPressed: showAddItemModal,
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
        body: Obx(
          () => ListView(
            children: [
              ...appController.items.map((e) => ItemCard(data: e)),
            ],
          ),
        ));
  }

  void showAddItemModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
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
                text: 'Add',
                backgroundColor: Colors.deepPurple,
                textColor: Colors.white,
                onPressed: () {
                  setState(() {
                    loading = true;
                  });
                  Future.delayed(const Duration(seconds: 2), () async {
                    await addItem(itemController.text);
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
