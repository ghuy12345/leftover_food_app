/*
UI page for donors to submit food donations.
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';
import 'package:leftover_food_app/functions.dart';

class DonorFormScreen extends StatefulWidget {
  final bool isAdmin;

  const DonorFormScreen({super.key, this.isAdmin = false});

  @override
  State<DonorFormScreen> createState() => DonorFormScreenState();
}


class DonorFormScreenState extends State<DonorFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _foodTypeController = TextEditingController();
  final _donationDateController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _sourceController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();


  String? foodType;
  String? source;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _foodTypeController.dispose();
    _donationDateController.dispose();
    _expirationDateController.dispose();
    _sourceController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }


// holy this was a pain , this is fully modified to work with the functions.dart file after many edits
  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {
      final donationDate = DateTime.tryParse(_donationDateController.text);
      final expirationDate = DateTime.tryParse(_expirationDateController.text);
      final quantity = int.tryParse(_quantityController.text);

      if (donationDate == null || expirationDate == null || quantity == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter valid date and quantity values.')),
        );
        return;
      }

      final success = await submitDonation(
        context: context,
        name: _nameController.text.trim(),
       email: _emailController.text.trim().toLowerCase(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        foodType: _foodTypeController.text.trim(),
        donationDate: donationDate,
        expirationDate: expirationDate,
        source: _sourceController.text.trim(),
        quantity: quantity,
        notes: _notesController.text.trim(),
        isAdmin: widget.isAdmin,
      );

      if (success) {
        if (!mounted) return;
        // this is where it navigates to the confirmation screen
        print("Success! Navigating to confirmation screen...");
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ConfirmationScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Donor Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
              TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
              TextFormField(controller: _phoneController, decoration: const InputDecoration(labelText: 'Phone (10 digits)')),
              TextFormField(controller: _addressController, decoration: const InputDecoration(labelText: 'Zip Code')),
              TextFormField(controller: _foodTypeController, decoration: const InputDecoration(labelText: 'Food Type (canned, dairy, other)')),
              TextFormField(controller: _donationDateController, decoration: const InputDecoration(labelText: 'Donation Date (YYYY-MM-DD)')),
              TextFormField(controller: _expirationDateController, decoration: const InputDecoration(labelText: 'Expiration Date (YYYY-MM-DD)')),
              TextFormField(controller: _sourceController, decoration: const InputDecoration(labelText: 'Source (farm, store, homemade)')),
              TextFormField(controller: _quantityController, decoration: const InputDecoration(labelText: 'Quantity')),
              TextFormField(controller: _notesController, decoration: const InputDecoration(labelText: 'Notes (optional)')),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Donation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
