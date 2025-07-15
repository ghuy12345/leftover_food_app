/* 
UI page for receivers to submit requests for available food.
*/
import 'package:flutter/material.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';
import 'package:leftover_food_app/functions.dart';

class ReceiverFormScreen extends StatefulWidget {
  const ReceiverFormScreen({super.key});

  @override
  State<ReceiverFormScreen> createState() => _ReceiverFormScreenState();
}

class _ReceiverFormScreenState extends State<ReceiverFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _addressController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  String? foodType;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _addressController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final success = await submitReceiverRequest(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        number: _numberController.text.trim(),
        address: _addressController.text.trim(),
        quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
        foodTypes: foodType ?? '',
        notes: _notesController.text.trim(),
      );

      if (success) {
        _formKey.currentState!.reset();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ConfirmationScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receiver Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter email' : null,
              ),
              TextFormField(
                controller: _numberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter phone number' : null,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter address' : null,
              ),
              DropdownButtonFormField<String>(
                value: foodType,
                hint: const Text('Select Food Type'),
                onChanged: (value) => setState(() => foodType = value),
                items: ['canned', 'dairy', 'raw', 'liquid']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                validator: (value) => value == null ? 'Please select a food type' : null,
              ),
              TextFormField(
                controller: _quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter quantity' : null,
              ),
              TextFormField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes (optional)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: const Text('Submit Request'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}