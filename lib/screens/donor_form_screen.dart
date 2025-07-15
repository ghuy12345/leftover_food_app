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
  State<DonorFormScreen> createState() => _DonorFormScreenState();
}

class _DonorFormScreenState extends State<DonorFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _numberController = TextEditingController();
  final _addressController = TextEditingController();
  final _donationDateController = TextEditingController();
  final _expirationDateController = TextEditingController();
  final _quantityController = TextEditingController();
  final _notesController = TextEditingController();

  String? foodType;
  String? source;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _numberController.dispose();
    _addressController.dispose();
    _donationDateController.dispose();
    _expirationDateController.dispose();
    _quantityController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final success = await submitDonation(
        context: context,
        name: _nameController.text.trim(),
        email: _emailController.text.trim().toLowerCase(),
        phone: _numberController.text.trim(),
        address: _addressController.text.trim(),
        donationDate: DateTime.tryParse(_donationDateController.text.trim()) ?? DateTime.now(),
        expirationDate: DateTime.tryParse(_expirationDateController.text.trim()) ?? DateTime.now(),
        foodType: foodType ?? '',
        source: source ?? '',
        quantity: int.tryParse(_quantityController.text.trim()) ?? 0,
        notes: _notesController.text.trim(),
        isAdmin: widget.isAdmin,
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
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Donor Form'),
            if (widget.isAdmin)
              const Text('Admin Form', style: TextStyle(fontSize: 14, color: Colors.white70)),
          ],
        ),
      ),
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
              TextFormField(
                controller: _donationDateController,
                decoration: const InputDecoration(labelText: 'Donation Date (YYYY-MM-DD)'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter donation date' : null,
              ),
              TextFormField(
                controller: _expirationDateController,
                decoration: const InputDecoration(labelText: 'Expiration Date (YYYY-MM-DD)'),
                validator: (value) => value == null || value.isEmpty ? 'Please enter expiration date' : null,
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
              DropdownButtonFormField<String>(
                value: source,
                hint: const Text('Select Source'),
                onChanged: (value) => setState(() => source = value),
                items: ['farm', 'store', 'homemade']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                validator: (value) => value == null ? 'Please select a source' : null,
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
                child: const Text('Submit Donation'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}