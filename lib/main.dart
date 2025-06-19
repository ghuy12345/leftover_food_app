import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:leftover_food_app/screens/home_screen.dart';


/*
The app's entry point. Sets up routing, themes, Firebase initialization, and opens the first screen (Splash or Home).
*/
void main() async {
WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

runApp(MaterialApp(home: HomeScreen(),));
}
