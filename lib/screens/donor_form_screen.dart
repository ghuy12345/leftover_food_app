/*
UI page for donors to submit food donations.
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';

class DonorFormScreen extends StatelessWidget {
  const DonorFormScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Donor Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Hello World'),
            ElevatedButton(
              onPressed: () {
                //
                // Need to add form submission logic here
                //
                Navigator.push(context, MaterialPageRoute(builder: (context) => ConfirmationScreen()));
              },
              child: Text("Submit"),
            ),
            ], // Children
        ),
      ),
    );
  }
}