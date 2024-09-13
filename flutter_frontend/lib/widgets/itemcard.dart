import 'package:flutter/material.dart';
import 'package:flutter_frontend/utils/api.dart';
import 'package:flutter_frontend/utils/controller.dart';
import 'package:flutter_frontend/utils/utils.dart';
import 'package:flutter_frontend/widgets/button.dart';
import 'package:get/get.dart';

class ItemCard extends StatefulWidget {
  final Map data;
  const ItemCard({super.key, required this.data});

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  AppController appController = Get.find<AppController>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                'Name: ${widget.data['name']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Poppins",
                  color: Colors.black87,
                ),
              ),
            ),
            CustomButton(
              text: 'Delete',
              backgroundColor: Colors.red,
              textColor: Colors.white,
              onPressed: () {
                _showDeleteConfirmationDialog(context);
              },
              icon: const Icon(Icons.delete),
              isLoading: loading,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Confirm Delete',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Are you sure you want to delete this item?',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 14),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: 'No',
                      backgroundColor: Colors.grey.shade300,
                      textColor: Colors.black87,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    CustomButton(
                      text: 'Yes',
                      backgroundColor: Colors.redAccent,
                      textColor: Colors.white,
                      onPressed: () {
                        setState(() {
                          loading = true;
                        });
                        Future.delayed(const Duration(seconds: 1), () {
                          _deleteItem();
                        });
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteItem() async {
    try {
      final res = await ApiCall().deleteItem(itemId: widget.data['id']);
      if (res.statusCode == 200) {
        showToast(message: 'Item deleted successfully');
        appController.items
            .removeWhere((element) => element['id'] == widget.data['id']);
      } else {
        showToast(message: res.response['message']);
      }
    } catch (e) {
      showToast(message: e.toString());
    } finally {
      setState(() {
        loading = false;
      });
    }
  }
}
