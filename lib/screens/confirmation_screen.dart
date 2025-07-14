/*
Displays a “Thank You” or “Success” message after submitting a form.
*/
/*
Landing page with options like: “I'm a Donor” / “I'm a Receiver.”
*/
/*
Displays a “Thank You” or “Success” message after submitting a form.
*/
/*
Landing page with options like: “I'm a Donor” / “I'm a Receiver.”
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  ConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form Submitted'),
        actions: [
          IconButton(
          icon: Icon(Icons.home),
            onPressed: () {
            Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false,
            );
          }, 
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Thank you for your Submission! Saved to Database.", 
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen()),
                  (route) => false,
                );
              },
              child: Text("Start Again"),
            ),
          ],
        ),
      ),
    );
  }
}