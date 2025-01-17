import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:proj_inz/components/my_textfield.dart';
import 'package:proj_inz/components/my_button.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  void login() async {
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      // Próba zalogowania użytkownika
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (context.mounted) Navigator.pop(context); // Zamknięcie wskaźnika ładowania
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Zamknięcie wskaźnika ładowania

      // Sprawdzenie kodu błędu
      String errorMessage;
      if (e.code == 'wrong-password') {
        errorMessage = "Hasło niepoprawne. Spróbuj ponownie.";
      } else if (e.code == 'user-not-found') {
        errorMessage = "Brak użytkownika o podanym adresie email.";
      } else {
        errorMessage = e.message ?? "Wystąpił błąd.";
      }

      // Wyświetlenie komunikatu błędu
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Błąd logowania"),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void resetPassword() async {
    if (emailController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Błąd"),
          content: const Text("Wpisz swój adres email."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Sukces"),
          content: const Text("email do resetowania hasła został wysłany"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    } on FirebaseAuthException catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Błąd"),
          content: Text(e.message ?? "Wystąpił błąd."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                const Text("Zaloguj się"),
                const SizedBox(
                  height: 25,
                ),
                Container(
                  width: 200,
                  height: 200,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black38,
                  ),
                  child: const Icon(Icons.person, size: 160, color: Colors.amber,)
                ),
                const SizedBox(
                  height: 25,
                ),
                MyTextField(
                    controller: emailController,
                    hintText: "Email",
                    obscureText: false),
                const SizedBox(
                  height: 5,
                ),
                MyTextField(
                    controller: passwordController,
                    hintText: "Hasło",
                    obscureText: true),
                const SizedBox(
                  height: 5,
                ),
                 Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: resetPassword,
                      child: const Text(
                        "Zapomniałeś hasła?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                MyButton(onTap: login, text: "Zaloguj się",),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Nie masz konta?"),
                    GestureDetector(
                      onTap: widget.onTap,
                      child: const Text(
                        " Zarejestruj się tutaj",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
