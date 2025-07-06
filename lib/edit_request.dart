import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Dialog widget for editing a receiver request
class EditRequestDialog extends StatefulWidget {
  final Map<String, dynamic> requestData; // initial request data
  final String requestId; // Firestore document ID

  const EditRequestDialog({
    Key? key,
    required this.requestData,
    required this.requestId,
  }) : super(key: key);

  @override
  _EditRequestDialogState createState() => _EditRequestDialogState();
}

class _EditRequestDialogState extends State<EditRequestDialog> {
  final _formKey = GlobalKey<FormState>(); // key for form validation

  late TextEditingController nameController;     // controller for 'name'
  late TextEditingController addressController;  // controller for 'address'
  late TextEditingController foodTypesController; // controller for 'foodTypes'
  late TextEditingController quantityController; // controller for 'quantity'
  late TextEditingController notesController;    // controller for 'notes'

  late String status; // holds the current request status

  @override
  void initState() {
    super.initState();
    // initialize controllers with existing values
    nameController = TextEditingController(text: widget.requestData['name'] ?? '');
    addressController = TextEditingController(text: widget.requestData['address'] ?? '');
    foodTypesController = TextEditingController(text: widget.requestData['foodTypes'] ?? '');
    quantityController = TextEditingController(
      text: widget.requestData['quantity']?.toString() ?? '',
    );
    notesController = TextEditingController(text: widget.requestData['notes'] ?? '');
    status = widget.requestData['status'] ?? 'pending'; // default if missing
  }

  @override
  void dispose() {
    // release controller resources
    nameController.dispose();
    addressController.dispose();
    foodTypesController.dispose();
    quantityController.dispose();
    notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Request'), // dialog header
      content: SingleChildScrollView(
        child: Form(
          key: _formKey, // assign form key
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Name field
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter a name' : null,
              ),
              // Address field
              TextFormField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Address'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter an address' : null,
              ),
              // Food types field
              TextFormField(
                controller: foodTypesController,
                decoration: const InputDecoration(labelText: 'Food Types'),
                validator: (value) =>
                    (value == null || value.isEmpty) ? 'Enter food types' : null,
              ),
              // Quantity field
              TextFormField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Enter quantity';
                  if (int.tryParse(value) == null) return 'Enter a number';
                  return null;
                },
              ),
              // Notes field (optional)
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              // Status dropdown to choose pending/approved/rejected
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: const [
                  DropdownMenuItem(value: 'pending', child: Text('Pending')),
                  DropdownMenuItem(value: 'approved', child: Text('Approved')),
                  DropdownMenuItem(value: 'rejected', child: Text('Rejected')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => status = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        // Close without saving
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        // Save updates to Firestore
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              await FirebaseFirestore.instance
                  .collection('receiver_requests')
                  .doc(widget.requestId)
                  .update({
                'name': nameController.text,
                'address': addressController.text,
                'foodTypes': foodTypesController.text,
                'quantity': int.parse(quantityController.text),
                'notes': notesController.text,
                'status': status, // update status field
              });
              Navigator.of(context).pop(); // close dialog
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
