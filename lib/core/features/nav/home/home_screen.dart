
import 'package:assignment_asl/core/features/task/detail_screen.dart';
import 'package:assignment_asl/core/features/task/edit_screen.dart';
import 'package:assignment_asl/core/features/nav/home/home_controller.dart';
import 'package:assignment_asl/core/features/task/model/customer_response.dart';
import 'package:assignment_asl/core/features/task/task_controller.dart';
import 'package:assignment_asl/core/features/utils/hexcolor.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final homeController = Get.put(HomeController());

  final taskController = Get.put(CustomerController());


  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
        extendBody: true,
         backgroundColor: const Color(0xfff8f9ff),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(12), // <-- custom height here
          child: AppBar(
            backgroundColor: const Color(0xfff8f9ff),
            elevation: 1,
          ),
        ),
      body: Obx(
          () {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Good morning Liam!",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey[600])),

                          const SizedBox(height: 6),

                          Text(homeController.formattedSelectedDate,
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.w600,
                              )),
                        ],
                      ),
                      const Icon(Icons.notifications_none_rounded, size: 28),
                    ],
                  ),

                  const SizedBox(height: 25),
              
                  // Today tasks section
                  Text("Today tasks",
                      style: GoogleFonts.poppins(
                          fontSize: 18, fontWeight: FontWeight.w600)),

                  const SizedBox(height: 16),

                  // Tabs
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Row(
                        children: [

                          // ALL
                          Expanded(
                            child: GestureDetector(
                              onTap: () => taskController.changeTab(0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: taskController.selectedTab.value == 0
                                      ? HexColor("#613BE7")
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(child: Text("All task",style: TextStyle(color:taskController.selectedTab.value == 0
                                    ? Colors.white:Colors.black ),)),
                              ),
                            ),
                          ),

                          // PENDING
                          Expanded(
                            child: GestureDetector(
                              onTap: () => taskController.changeTab(1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: taskController.selectedTab.value == 1
                                      ? HexColor("#613BE7")
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(child: Text("Pending",style: TextStyle(color:taskController.selectedTab.value == 1
                                    ? Colors.white:Colors.black ),)),
                              ),
                            ),
                          ),

                          // VISITED
                          Expanded(
                            child: GestureDetector(
                              onTap: () => taskController.changeTab(2),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: taskController.selectedTab.value == 2
                                      ? HexColor("#613BE7")
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(child: Text("Visited",style: TextStyle(color:taskController.selectedTab.value == 2
                                    ? Colors.white:Colors.black ),)),
                              ),
                            ),
                          ),

                          // NOT AVAILABLE
                          Expanded(
                            child: GestureDetector(
                              onTap: () => taskController.changeTab(3),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  color: taskController.selectedTab.value == 3
                                      ? HexColor("#613BE7")
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(child: Text("Not Available",style: TextStyle(color:taskController.selectedTab.value == 3
                                    ? Colors.white:Colors.black ),)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),


               const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      onChanged: (value) {
                        taskController.search(value); // 🔥 live search
                      },
                      decoration: InputDecoration(
                        hintText: "Search by name or phone",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

              // Task list
              Obx(() {

               if (taskController.customers.isEmpty) {
                  return SizedBox(
                      height: MediaQuery.sizeOf(context).height/4,
                      child: Center(child: Text("No tasks for today",style: TextStyle(color: Colors.red,
                          fontSize: 18
                    ),)));
                }

               return ListView.builder(
                 shrinkWrap: true,
                 physics: NeverScrollableScrollPhysics(),
                 itemCount: taskController.customers.length,
                 itemBuilder: (context, index) {
                   final c = taskController.customers[index];

                   return InkWell(
                     onTap: (){

                       Get.to(CustomerDetailScreen(customer: c,));
                     },
                     child: Card(
                       color: Colors.white,
                       child: ListTile(
                         leading: CircleAvatar(
                           child: Text(c.visitStatus[5].toUpperCase()),
                         ),

                         title: Text(c.name),
                         subtitle: Text("${c.phone} • ${c.visitStatus}"),

                         // 👉 ACTION BUTTONS
                         trailing: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [

                             // ✏️ EDIT
                             IconButton(
                               icon: Icon(Icons.edit, color: Colors.blue),
                               onPressed: () {
                                 Get.to(() => EditCustomerScreen(customer: c));
                               },
                             ),

                             // 🗑 DELETE
                             IconButton(
                               icon: Icon(Icons.delete, color: Colors.red),
                               onPressed: () {
                                 _confirmDelete(taskController, c);
                               },
                             ),
                           ],
                         ),
                       ),
                     ),
                   );
                 },
               );
                })
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  Widget _summaryCard(
      String title, String count, Color bgColor, Color borderColor) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey[700],
                  fontWeight: FontWeight.w500)),
          const SizedBox(height: 8),
          Text(count,
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.bold, color: borderColor)),
        ],
      ),
    );
  }

  // ✅ DELETE CONFIRM DIALOG
  void _confirmDelete(CustomerController controller, Customer c) {
    Get.dialog(
      AlertDialog(
        title: Text("Delete"),
        content: Text("Are you sure you want to delete this customer?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteCustomer(c);
              Get.back();
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }


}


class TaskCard extends StatelessWidget {
  final int id;
  final String title;
  final String description;
  final String date;
  final String status;
  final Color statusColor;
  final Map<String, dynamic> task;
  final VoidCallback onToggle;

  const TaskCard({
    super.key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.status,
    required this.statusColor,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final DateTime dateformate = DateTime.parse(date);

    /// ✅ THIS IS THE ONLY LOGIC NEEDED
    final bool isComplete = status.toLowerCase() == 'complete';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TITLE + CHECKBOX
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    decoration:
                    isComplete ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),

              Row(
                children: [
                  Checkbox(
                    value: isComplete, // ✅ COMPLETE → CHECKED
                    onChanged: (_) => onToggle(),
                    activeColor: HexColor("#613BE7"),
                  ),
                  Text(
                    status, // ❌ you had "status" string literal before
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: isComplete ? Colors.green : Colors.orange,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.grey[700],
              decoration:
              isComplete ? TextDecoration.lineThrough : null,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.access_time,
                      size: 16, color: Colors.grey),
                  const SizedBox(width: 5),
                  Text(
                    DateFormat('MMMM d, yyyy').format(dateformate),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),

              /// 🔹 STATUS CHIP
              GestureDetector(
                onTap: (){
                //  Get.to(()=>TaskDetailsScreen(task: task));
                },
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Icon(Icons.edit,size: 24,),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}


