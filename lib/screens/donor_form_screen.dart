/* 
UI page for donors to submit food donations.
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';

class DonorFormScreen extends StatefulWidget {
  const DonorFormScreen({super.key});

  @override
  DonorFormScreenState createState() => DonorFormScreenState();
}

class DonorFormScreenState extends State<DonorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _foodTypeController       = TextEditingController();
  final _donationDateController   = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _sourceController         = TextEditingController();
  final _notesController          = TextEditingController();
  final _quantityController       = TextEditingController();
  final _donorNameController      = TextEditingController();
  final _donorAddressController   = TextEditingController();
  final _emailController          = TextEditingController();
  final _phoneNumberController    = TextEditingController();

  @override
  void dispose() {
    _foodTypeController.dispose();
    _donationDateController.dispose();
    _expirationDateController.dispose();
    _sourceController.dispose();
    _notesController.dispose();
    _quantityController.dispose();
    _donorNameController.dispose();
    _donorAddressController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donor Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Name of Donor
              TextFormField(
                controller: _donorNameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              // 2. Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 16),
              // 3. Phone Number
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Please enter your phone number' : null,
              ),
              const SizedBox(height: 16),
              // 4. Address of Donor
              TextFormField(
                controller: _donorAddressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (v) => v!.isEmpty ? 'Please enter your address' : null,
              ),
              const SizedBox(height: 16),
              // 5. Type of Food
              TextFormField(
                controller: _foodTypeController,
                decoration: const InputDecoration(labelText: 'Type of Food'),
                validator: (v) => v!.isEmpty ? 'Please enter a food type' : null,
              ),
              const SizedBox(height: 16),
              // 6. Date of Donation
              TextFormField(
                controller: _donationDateController,
                decoration: const InputDecoration(labelText: 'Date of Donation'),
                keyboardType: TextInputType.datetime,
                validator: (v) => v!.isEmpty ? 'Please enter a donation date' : null,
              ),
              const SizedBox(height: 16),
              // 7. Expiration Date of Food
              TextFormField(
                controller: _expirationDateController,
                decoration: const InputDecoration(labelText: 'Expiration Date of Food'),
                keyboardType: TextInputType.datetime,
                validator: (v) => v!.isEmpty ? 'Please enter an expiration date' : null,
              ),
              const SizedBox(height: 16),
              // 8. Source of Food
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'Source of Food'),
                validator: (v) => v!.isEmpty ? 'Please enter the food source' : null,
              ),
              const SizedBox(height: 16),
              // 9. Quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Please enter a quantity' : null,
              ),
              const SizedBox(height: 16),
              // 10. Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    //
                    // Need to add form submission logic here
                    //
                    if (_formKey.currentState!.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) =>  ConfirmationScreen()),
                      );
                    }
                  },
                  child: const Text("Submit"),
                ),
              ), 
            ], // Children
          ), 
        ), 
      ), 
    ); 
  }
}
