import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:leftover_food_app/screens/home_screen.dart';
import 'package:leftover_food_app/screens/confirmation_screen.dart';
import 'package:leftover_food_app/screens/donor_form_screen.dart';
import 'package:leftover_food_app/screens/receiver_form_screen.dart';

void main() async {
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

runApp(MaterialApp());
}
