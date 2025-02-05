import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proj_inz/views/user_form_view.dart';

import 'favorites_screen.dart';

class ProfileSection extends StatelessWidget {
  const ProfileSection({super.key});

  void _logout(BuildContext context) {
    FirebaseAuth.instance.signOut();
    //Navigator.pushNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[300],
            ),
            child: const Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserFormView()),
            );
          },
              child: const Text('Formularz')),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoriteSection()),
              );
            },
            child: const Text('Ulubione'),
          ),          ElevatedButton(onPressed: () {_logout(context);}, child: const Text('Wyloguj')),
        ],
      ),
    );
  }
}
