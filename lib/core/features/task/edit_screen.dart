import 'package:assignment_asl/core/features/nav/home/home_controller.dart';
import 'package:assignment_asl/core/features/task/model/customer_response.dart';
import 'package:assignment_asl/core/features/task/task_controller.dart';
import 'package:assignment_asl/core/features/utils/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class EditCustomerScreen extends StatelessWidget {
  final Customer customer;

  EditCustomerScreen({required this.customer});

  final CustomerController controller = Get.find();

  late final TextEditingController nameCtrl =
  TextEditingController(text: customer.name);

  // ✅ Add Rx variable and initialize with existing value
  final RxString visitStatus = "".obs;

  @override
  Widget build(BuildContext context) {

    // ✅ Initialize once
    visitStatus.value = customer.visitStatus ?? "pending";

    return Scaffold(
      appBar: AppBar(title: Text("Edit Customer")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: "Customer Name",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 16),

            /// ✅ VISIT STATUS DROPDOWN
            Obx(() => DropdownButtonFormField<String>(
              value: visitStatus.value,
              items: [
                DropdownMenuItem(
                    value: "pending", child: Text("Pending")),
                DropdownMenuItem(
                    value: "visited", child: Text("Visited")),
                DropdownMenuItem(
                    value: "not_available",
                    child: Text("Not Available")),
              ],
              onChanged: (value) {
                visitStatus.value = value!;
              },
              decoration: InputDecoration(
                labelText: "Visit Status",
                border: OutlineInputBorder(),
              ),
            )),

            SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {

                  /// ✅ Update both fields
                  customer.name = nameCtrl.text;
                  customer.visitStatus = visitStatus.value;

                  await controller.updateCustomer(customer);

                  Get.back();
                },
                child: Text("Update"),
              ),
            )
          ],
        ),
      ),
    );
  }
}