/*
Landing page with options like: “I'm a Donor” / “I'm a Receiver.”
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/donor_form_screen.dart';
import 'package:leftover_food_app/screens/receiver_form_screen.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Reciever Form
            ElevatedButton(
              onPressed: () {
                // You would normally handle submission here
                Navigator.push(context, MaterialPageRoute(builder: (context) => ReceiverFormScreen()));
              },
              child: Text("Request Food"),
            ),
            // Donor Form
            ElevatedButton(
              onPressed: () {
                // You would normally handle submission here
                Navigator.push(context, MaterialPageRoute(builder: (context) => DonorFormScreen()));
              },
              child: Text("Request Food"),
            ),
          ],
        ),
      ),
    );
  }
}
