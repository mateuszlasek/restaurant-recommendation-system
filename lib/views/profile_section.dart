import 'package:flutter/material.dart';
import 'package:proj_inz/views/user_form_view.dart';

class ProfileSection extends StatelessWidget {
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
            child: Icon(Icons.person, size: 50, color: Colors.grey),
          ),
          SizedBox(height: 20),
          ElevatedButton(onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const UserFormView()),
            );
          },
              child: Text('Formularz')),
          ElevatedButton(onPressed: () {}, child: Text('Button 2')),
          ElevatedButton(onPressed: () {}, child: Text('Button 3')),
        ],
      ),
    );
  }
}
