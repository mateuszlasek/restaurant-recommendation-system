import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:proj_inz/services/auth/auth.dart';
import 'package:proj_inz/views/user_form_view.dart';

import 'firebase_options.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nearby Restaurants',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserFormView(),
    );
  }
}