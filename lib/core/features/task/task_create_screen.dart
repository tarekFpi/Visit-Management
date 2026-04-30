import 'package:assignment_asl/core/features/task/model/customer_response.dart';
import 'package:assignment_asl/core/features/task/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AddCustomerScreen extends StatelessWidget {
  AddCustomerScreen({super.key});

  final controller = Get.put(CustomerController());

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  final RxString visitStatus = "pending".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Customer"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [

              // NAME
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: "Customer Name",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12),

              // PHONE
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12),

              // EMAIL
              TextField(
                controller: emailCtrl,
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 12),

              // ADDRESS
              TextField(
                controller: addressCtrl,
                decoration: InputDecoration(
                  labelText: "Address",
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              // VISIT STATUS
              Obx(() => DropdownButtonFormField(
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

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    final customer = Customer(
                      id: DateTime.now().millisecondsSinceEpoch,
                      name: nameCtrl.text,
                      phone: phoneCtrl.text,
                      email: emailCtrl.text,
                      address: addressCtrl.text,
                      lastVisitDate: "",
                      visitStatus: visitStatus.value,
                      notes: "",
                      syncStatus: "pending_create",
                     // updatedAt: DateTime.now(),
                    );

                    await controller.addCustomer(customer);

                  //  Get.back(); // close screen
                  },
                  child: Text("Save Customer"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
