import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditUserDialog extends StatefulWidget {
  final Map<String, dynamic> userData;
  final String userId;
  // need this to receive user data and ID, a confusing constructor i needed help with
  const EditUserDialog({
    Key? key,
    required this.userData,
    required this.userId,
  }) : super(key: key);
 // instance
  @override
  _EditUserDialogState createState() => _EditUserDialogState();
}

class _EditUserDialogState extends State<EditUserDialog> {
  late TextEditingController emailController;
  late TextEditingController nameController;

  @override
  void initState() { // text controllers we need for email and name
    super.initState();
    emailController = TextEditingController(text: widget.userData['email'] ?? '');
    nameController = TextEditingController(text: widget.userData['name'] ?? '');
  }

  @override
  void dispose() {
    emailController.dispose();
    nameController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges() async {
    await FirebaseFirestore.instance.collection('users').doc(widget.userId).update({
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit User'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [ // text fields for email and name
          TextField(
            controller: emailController,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
        ],
      ),
      actions: [ // buttons for cancel and save, simple enough
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _saveChanges,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
