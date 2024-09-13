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
  String? errorText;

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
                    iconSize: 28,
                    onPressed: () => showAddItemModal(context),
                    icon: const Icon(Icons.add),
                  )
                : const Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                        strokeWidth: 2,
                      ),
                    ),
                  ),
          ],
        ),
        body: Stack(
          children: [
            Obx(
              () => ListView(
                children: [
                  if (appController.items.isEmpty)
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.hourglass_empty,
                              size: 50,
                              color: Colors.black,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'No items found',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ...appController.items.map((e) => ItemCard(data: e)),
                  const SizedBox(
                    height: 10,
                  )
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
        return StatefulBuilder(
          builder: (context, setState) {
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
                    const SizedBox(height: 14),
                    TextField(
                      cursorErrorColor: Colors.red,
                      onChanged: (value) {
                        setState(() {
                          errorText =
                              value.isEmpty ? 'Please enter item name' : null;
                        });
                      },
                      controller: itemController,
                      decoration: InputDecoration(
                        hintText: 'Enter item name',
                        errorText: errorText,
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    buttonLoading
                        ? const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(Colors.black),
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        : CustomButton(
                            text: '   Add   ',
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            onPressed: () {
                              if (itemController.text.isEmpty ||
                                  itemController.text.length < 3) {
                                setState(() {
                                  errorText =
                                      'Item name must be at least 3 characters';
                                });
                              } else {
                                setState(() {
                                  buttonLoading = true;
                                });
                                Future.delayed(const Duration(seconds: 1),
                                    () async {
                                  await addItem(itemController.text);
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                          ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((_) {
      setState(() {
        errorText = null;
        itemController.clear();
      });
    });
  }
}
