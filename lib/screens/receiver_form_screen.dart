/*
UI page for receivers to submit requests for available food.
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';

class ReceiverFormScreen extends StatelessWidget {
  const ReceiverFormScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Request Form')),
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
