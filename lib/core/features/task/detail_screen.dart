import 'package:assignment_asl/core/features/task/model/customer_response.dart';
import 'package:flutter/material.dart';

class CustomerDetailScreen extends StatelessWidget {
  final Customer customer;

  CustomerDetailScreen({super.key, required this.customer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Customer Details"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            // 🧑 HEADER CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: Text(
                        customer.name[0].toUpperCase(),
                        style: TextStyle(fontSize: 24),
                      ),
                    ),
                    SizedBox(height: 10),

                    Text(
                      customer.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],
                ),
              ),
            ),

            SizedBox(height: 16),

            // 📋 INFO CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [

                  _item("📧 Email", customer.email),
                  _divider(),

                  _item("📍 Address", customer.address),
                  _divider(),

                  _item("📅 Last Visit", customer.lastVisitDate),
                  _divider(),

                  _statusItem("Visit Status", customer.visitStatus),
                  _divider(),

                  _item("📝 Notes", customer.notes.isEmpty
                      ? "No notes"
                      : customer.notes),
                  _divider(),

                  _syncStatusItem(customer.syncStatus),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Normal item
  Widget _item(String title, String value) {
    return ListTile(
      title: Text(title),
      subtitle: Text(value),
    );
  }

  // 🔹 Divider
  Widget _divider() {
    return Divider(height: 1);
  }

  // 🔹 Visit status with color
  Widget _statusItem(String title, String status) {
    Color color;

    switch (status) {
      case "visited":
        color = Colors.green;
        break;
      case "pending":
        color = Colors.orange;
        break;
      case "not_available":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return ListTile(
      title: Text(title),
      trailing: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          status.toUpperCase(),
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  // 🔹 Sync status badge
  Widget _syncStatusItem(String status) {
    Color color;

    switch (status) {
      case "synced":
        color = Colors.green;
        break;
      case "pending":
      case "pending_create":
      case "pending_update":
        color = Colors.orange;
        break;
      case "failed":
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return ListTile(
      title: Text("Sync Status"),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.sync, color: color),
          SizedBox(width: 6),
          Text(
            status.toUpperCase(),
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}