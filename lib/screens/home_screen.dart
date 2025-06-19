/*
Landing page with options like: “I'm a Donor” / “I'm a Receiver.”
*/
import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Name:"),
            TextField(controller: nameController),
            SizedBox(height: 16),
            Text("Email:"),
            TextField(controller: emailController),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // You would normally handle submission here
                print("Submitted: ${nameController.text}, ${emailController.text}");
              },
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
