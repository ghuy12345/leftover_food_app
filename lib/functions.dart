// ton of packages
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';

Future<void> ensureUserExists(String email, String name) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(email);

  final userSnapshot = await userRef.get();
  if (!userSnapshot.exists) {
    await userRef.set({
      'email': email,
      'name': name,
      'active': true,
      'createdAt': Timestamp.now(),
    });
  }
}

// donation submission function
Future<bool> submitDonation({
  // pulls all of the data from the form
  required BuildContext context,
  required String name,
  required String email,
  required String phone,
  required String address,
  required String foodType,
  required DateTime donationDate,
  required DateTime expirationDate,
  required String source,
  required int quantity,
  required String notes,
  bool isAdmin = false, // default to false, only true for admin submissions
}) async {
  final emailPattern = RegExp(
    r'^[^@]+@(gmail\.com|hotmail\.com|outlook\.com|yahoo\.com|fsu\.edu)$',
  );
  final cleanedEmail = email.trim().toLowerCase();
  if (!emailPattern.hasMatch(cleanedEmail)) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Invalid email domain.")));
    return false;
  }
  // ensures the user exists in the database
  await ensureUserExists(email, name);

  if (donationDate.isBefore(DateTime(2010))) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Donation date must be after 2010.")),
    );
    return false;
  }

  if (expirationDate.isBefore(donationDate.add(const Duration(days: 3)))) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Expiration must be at least 3 days after donation date.",
        ),
      ),
    );
    return false;
  }

  /*
  if (!['canned', 'dairy', 'raw', 'liquid'].contains(foodType.toLowerCase())) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Food type must be canned, dairy, or other.")),
    );
    return false;
  } */

  if (!RegExp(r'^\d{10}$').hasMatch(phone)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Phone number must be exactly 10 digits (no '-' or spaces).",
        ),
      ),
    );
    return false;
  }

  if (quantity <= 0) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Quantity must be greater than 0.")),
    );
    return false;
  }

  /*
  if (!['farm', 'store', 'homemade'].contains(source.toLowerCase())) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Source must be farm, store, or homemade.")),
    );
    return false;
  } */

  try {
    // adds it to the database (not easy)
    await FirebaseFirestore.instance.collection('donations').add({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'foodType': foodType,
      'donationDate': donationDate,
      'expirationDate': expirationDate,
      'source': source,
      'quantity': quantity,
      'notes': notes,
      'timestamp': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      'isAdmin': isAdmin,
    });
    // After donation has been added successfully
    final inventoryRef = FirebaseFirestore.instance
        .collection('inventory')
        .doc('foodTotals');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(inventoryRef);

      if (!snapshot.exists) {
        throw Exception("Inventory document does not exist!");
      }

      final currentAmount = snapshot.get(foodType) ?? 0;
      final newAmount = currentAmount + quantity;

      transaction.update(inventoryRef, {foodType: newAmount});
    });

    // needs to save to admin dash
    // Ensure user is added to 'users' collection as well
    final userRef = FirebaseFirestore.instance.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (!userSnapshot.exists) {
      await userRef.set({
        'email': email,
        'name': name,
        'isActive': true,
        'createdAt': Timestamp.now(),
      });
    }
    return true;
  } catch (e) {
    print('Firebase submission error: $e');
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Failed to submit donation: $e')));
    return false;
  }
}

// this handles all of the receiver requests stuff, basically the same as the donor submission function
Future<bool> submitReceiverRequest({
  required BuildContext context,
  required String name,
  required String email,
  required String number,
  required String address,
  required String foodTypes,
  required int quantity,
  required String notes,
}) async {
  try {
    final inventoryRef = FirebaseFirestore.instance.collection('inventory').doc('foodTotals');
    final inventorySnapshot = await inventoryRef.get();

    if (!inventorySnapshot.exists) {
      throw Exception("Inventory not found.");
    }

    final availableQuantity = inventorySnapshot.get(foodTypes) ?? 0;
    if (availableQuantity < quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not enough $foodTypes in inventory')),
      );
      return false;
    }

    // Add receiver request
    await FirebaseFirestore.instance.collection('requests').add({
      'name': name,
      'email': email,
      'number': number,
      'address': address,
      'foodTypes': foodTypes,
      'quantity': quantity,
      'notes': notes,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Update inventory
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final snapshot = await transaction.get(inventoryRef);
      final currentAmount = snapshot.get(foodTypes) ?? 0;
      final newAmount = currentAmount - quantity;
      transaction.update(inventoryRef, {foodTypes: newAmount});
    });

    // Create or update user
    final userRef = FirebaseFirestore.instance.collection('users').doc(email);
    final userSnapshot = await userRef.get();
    if (userSnapshot.exists) {
      await userRef.update({
        'requestCount': FieldValue.increment(1),
      });
    } else {
      await userRef.set({
        'email': email,
        'name': name,
        'isActive': true,
        'donationCount': 0,
        'requestCount': 1,
      });
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => ConfirmationScreen()),
    );

    return true;
  } catch (e) {
    print('Error submitting request: $e');
    return false;
  }
}
