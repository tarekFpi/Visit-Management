import 'dart:convert';

import 'package:assignment_asl/core/features/nav/nav_screen.dart';
import 'package:assignment_asl/core/features/task/model/customer_response.dart';
import 'package:assignment_asl/core/features/utils/db_helper.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomerController extends GetxController {

  final DBHelper dbHelper = DBHelper();

  var customers = <Customer>[].obs;

  var allCustomers = <Customer>[];

  var isOffline = false.obs;
  var pendingCount = 0.obs;

  final nameController = TextEditingController();
  final descController = TextEditingController();

  void pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isStart) {
        startDate.value = picked;
      } else {
        endDate.value = picked;
      }
    }
  }


  // 0 = All tasks, 1 = Completed
  var selectedTab = 0.obs;

  void changeTab(int index) {
    selectedTab.value = index;

    applyFilter();
  }

  /// edit textFiled
  final startDate = Rxn<DateTime>();
  final endDate = Rxn<DateTime>();

  @override
  void onInit() {
    loadCustomers();
    super.onInit();
  }

  // ======================
  // LOAD FROM LOCAL DB
  // ======================
  Future<void> loadCustomers() async {
    final data = await dbHelper.getCustomers();
    customers.value = data;

    allCustomers = data;
    applyFilter();
  }


  // 🔥 FILTER FUNCTION
  // 🔥 FILTER + SEARCH COMBINE
  void applyFilter() {
    List<Customer> filtered = allCustomers;

    // 👉 status filter
    if (selectedTab.value == 1) {
      filtered =
          filtered.where((c) => c.visitStatus == "pending").toList();
    } else if (selectedTab.value == 2) {
      filtered =
          filtered.where((c) => c.visitStatus == "visited").toList();
    } else if (selectedTab.value == 3) {
      filtered =
          filtered.where((c) => c.visitStatus == "not_available").toList();
    }

    // 👉 search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((c) {
        return c.name
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()) ||
            c.phone.contains(searchQuery.value);
      }).toList();
    }

    customers.value = filtered;
  }


  var searchQuery = "".obs;
  // 🔍 SEARCH
  void search(String value) {
    searchQuery.value = value;
    applyFilter();
  }

  // ======================
  // ADD CUSTOMER (OFFLINE SUPPORT)
  // ======================
  Future<void> addCustomer(Customer c) async {
    await dbHelper.insertCustomer(c);

    await dbHelper.addSyncQueue({
      "entityType": "customer",
      "entityId": c.id,
      "operationType": "create",
      "payload": jsonEncode(c.toMap()),
      "retryCount": 0,
      "syncStatus": "pending",
      "createdAt": DateTime.now().toIso8601String(),
    });

    // ✅ SUCCESS MESSAGE
    Get.snackbar(
      "Success",
      "Customer added successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

    loadCustomers();
  }



  // ======================
  // UPDATE CUSTOMER (OFFLINE)
  // ======================
  Future<void> updateCustomer(Customer c) async {
    await dbHelper.updateCustomer(c);

    await dbHelper.addSyncQueue({
      "entityType": "customer",
      "entityId": c.id,
      "operationType": "update",
      "payload": jsonEncode(c.toMap()),
      "retryCount": 0,
      "syncStatus": "pending",
      "createdAt": DateTime.now().toIso8601String(),
    });


    loadCustomers();

    // ✅ SUCCESS MESSAGE
    Get.snackbar(
      "Update",
      "Customer Update successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );

  }



  // ======================
  // DELETE CUSTOMER (OFFLINE)
  // ======================
  Future<void> deleteCustomer(Customer c) async {
    final dbClient = await dbHelper.db;

    // local delete
    await dbClient.delete(
      "customers",
      where: "id = ?",
      whereArgs: [c.id],
    );

    // sync queue (optional - if API support delete)
    await dbHelper.addSyncQueue({
      "entityType": "customer",
      "entityId": c.id,
      "operationType": "delete",
      "payload": jsonEncode(c.toMap()),
      "retryCount": 0,
      "syncStatus": "pending",
      "createdAt": DateTime.now().toIso8601String(),
    });

    await loadCustomers();


    // ✅ SUCCESS MESSAGE
    Get.snackbar(
      "Deleted",
      "Customer Deleted successfully",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: Duration(seconds: 2),
    );
  }

  // ======================
  // SYNC PENDING DATA
  // ======================
  Future<void> syncNow() async {
    final queue = await dbHelper.getSyncQueue();

    for (var item in queue) {
      try {
        final payload = jsonDecode(item["payload"]);

        if (item["operationType"] == "create") {
          await fakeApiCreate(payload);
        } else if (item["operationType"] == "update") {
          await fakeApiUpdate(payload);
        }

        await dbHelper.deleteSyncItem(item["id"]);

      } catch (e) {
        print("Sync failed: $e");
      }
    }

    loadCustomers();
  }

  // ======================
  // FAKE API (replace later)
  // ======================
  Future<void> fakeApiCreate(Map data) async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  Future<void> fakeApiUpdate(Map data) async {
    await Future.delayed(Duration(milliseconds: 500));
  }

  // ======================
  // SEARCH
  // ======================
/*  void search(String query) async {
    final all = await dbHelper.getCustomers();

    customers.value = all.where((c) =>
    c.name.toLowerCase().contains(query.toLowerCase()) ||
        c.phone.contains(query)
    ).toList();
  }*/
}

