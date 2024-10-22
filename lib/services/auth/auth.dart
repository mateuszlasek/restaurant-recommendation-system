import "package:proj_inz/views/home_view.dart";
import "package:proj_inz/services/auth/login_or_register.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  static const routeName = "/auth";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return const MyHomePage(title: "Proj");
        } else {
          return const LoginOrRegister();
        }
      },
    ));
  }
}
