import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff8f9ff),
      appBar: AppBar(
        title: const Text('Profile',style: TextStyle(fontSize: 24),),
        centerTitle: true,
        backgroundColor: const Color(0xfff8f9ff),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image
            CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage(
                  'https://www.w3schools.com/w3images/avatar2.png'), // Replace with user's image
            ),
            const SizedBox(height: 20),

            // Name
            Text(
              'Mehedi Hasan Tarek',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),

            // Phone
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.phone, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  '+88 01830089750',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Address
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.location_on, color: Colors.grey),
                SizedBox(width: 8),
                Text(
                  'Dhaka, Bangladesh',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            const Spacer(),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Add your logout functionality here
                  print('Logged out');
                },
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  textStyle: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    const MaterialApp(
      home: ProfileScreen(),
    ),
  );
}
