/* 
UI page for receivers to submit requests for available food.
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';
import 'package:leftover_food_app/functions.dart';

class ReceiverFormScreen extends StatefulWidget {
  const ReceiverFormScreen({super.key});

  @override
  ReceiverFormScreenState createState() => ReceiverFormScreenState();
}

class ReceiverFormScreenState extends State<ReceiverFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController       = TextEditingController();
  final _emailController      = TextEditingController();
  final _addressController    = TextEditingController();
  final _numberController     = TextEditingController();
  final _foodTypesController  = TextEditingController();
  final _quantityController   = TextEditingController();
  final _notesController      = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _numberController.dispose();
    _foodTypesController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submitForm() async {
  if (_formKey.currentState!.validate()) {
    try {
      final quantity = int.tryParse(_quantityController.text);
      if (quantity == null || quantity <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enter a valid quantity greater than 0.')),
        );
        return;
      }

      final foodType = _foodTypesController.text.trim().toLowerCase();
      if (!['canned', 'dairy', 'other'].contains(foodType)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Food type must be canned, dairy, or other.")),
        );
        return;
      }

      final success = await submitReceiverRequest(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        address: _addressController.text.trim(),
        number: _numberController.text.trim(),
        foodTypes: foodType,
        quantity: quantity,
        notes: _notesController.text.trim(),
      );

      if (success) {
        if (!mounted) return;
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
      appBar: AppBar(title: const Text('Request Form')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v!.isEmpty ? 'Please enter your name' : null,
              ),
              const SizedBox(height: 16),
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) => v!.isEmpty ? 'Please enter your email' : null,
              ),
              const SizedBox(height: 16),
              // Address
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Zip Code'),
                validator: (v) => v!.isEmpty ? 'Please enter your Zip code' : null,
              ),
              const SizedBox(height: 16),
              // Number
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Please enter your phone number (10 digits)' : null,
              ),
              const SizedBox(height: 16),
              // Types of Food
              TextFormField(
                controller: _foodTypesController,
                decoration: const InputDecoration(labelText: 'Types of Food'),
                validator: (v) => v!.isEmpty ? 'Please enter the types of food (canned, dairy, or other)' : null,
              ),
              const SizedBox(height: 16),
              // Quantity
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? 'Please enter a quantity' : null,
              ),
              const SizedBox(height: 16),
              // Notes
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text("Submit"),
                ),
              ), // ElevatedButton
            ], // Children
          ), // Column
        ), // Form
      ), // SingleChildScrollView
    ); // Scaffold
  }
}