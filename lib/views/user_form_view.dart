import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart'; // Import Firebase Realtime Database
import 'package:firebase_core/firebase_core.dart';

import '../models/user_form_model.dart';
import '../services/firebase_database/firebase_service.dart'; // Dodajemy import Firebase core, aby używać app

class UserFormView extends StatefulWidget {
  @override
  _UserFormViewState createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
  final _nameController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService(
    databaseURL: 'https://restaurant-recommendatio-57162-default-rtdb.europe-west1.firebasedatabase.app',
  );

  bool _servesVegetarianFood = false;
  bool _menuForChildren = false;
  bool _goodForChildren = false;
  bool _allowsDogs = false;
  bool _acceptsCreditCards = false;
  bool _acceptsDebitCards = false;
  bool _acceptsCashOnly = false;
  bool _acceptsNfc = false;
  bool _freeParkingLot = false;
  bool _paidParkingLot = false;
  bool _wheelchairAccessibleParking = false;
  bool _wheelchairAccessibleEntrance = false;
  bool _wheelchairAccessibleRestroom = false;

  Future<void> _submitForm() async {
    final userForm = UserFormModel(
      name: _nameController.text,
      servesVegetarianFood: _servesVegetarianFood,
      menuForChildren: _menuForChildren,
      goodForChildren: _goodForChildren,
      allowsDogs: _allowsDogs,
      acceptsCreditCards: _acceptsCreditCards,
      acceptsDebitCards: _acceptsDebitCards,
      acceptsCashOnly: _acceptsCashOnly,
      acceptsNfc: _acceptsNfc,
      freeParkingLot: _freeParkingLot,
      paidParkingLot: _paidParkingLot,
      wheelchairAccessibleParking: _wheelchairAccessibleParking,
      wheelchairAccessibleEntrance: _wheelchairAccessibleEntrance,
      wheelchairAccessibleRestroom: _wheelchairAccessibleRestroom,
    );


    await _firebaseService.submitUserForm(userForm);
  }

  // Funkcja do usunięcia formularza
  Future<void> _deleteForm() async {
    final uid = await _firebaseService.getUserUID();
    if (uid != null) {
      await _firebaseService.deleteUserFormByUID(uid);
      print("User form with UID $uid deleted successfully.");
    } else {
      print("Error: No UID found.");
    }
  }

  // Funkcja do pobrania formularza
  Future<void> _getForm() async {
    final uid = await _firebaseService.getUserUID();
    if (uid != null) {
      final userForm = await _firebaseService.getUserFormByUID(uid);
      if (userForm != null) {
        print("User form data: ${userForm.toMap()}");
      } else {
        print("No data found for UID $uid.");
      }
    } else {
      print("Error: No UID found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Form'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Restaurant Name'),
              ),
              SwitchListTile(
                title: Text('Serves Vegetarian Food'),
                value: _servesVegetarianFood,
                onChanged: (value) {
                  setState(() {
                    _servesVegetarianFood = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Menu for Children'),
                value: _menuForChildren,
                onChanged: (value) {
                  setState(() {
                    _menuForChildren = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Good for Children'),
                value: _goodForChildren,
                onChanged: (value) {
                  setState(() {
                    _goodForChildren = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Allows Dogs'),
                value: _allowsDogs,
                onChanged: (value) {
                  setState(() {
                    _allowsDogs = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Accepts Credit Cards'),
                value: _acceptsCreditCards,
                onChanged: (value) {
                  setState(() {
                    _acceptsCreditCards = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Accepts Debit Cards'),
                value: _acceptsDebitCards,
                onChanged: (value) {
                  setState(() {
                    _acceptsDebitCards = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Accepts Cash Only'),
                value: _acceptsCashOnly,
                onChanged: (value) {
                  setState(() {
                    _acceptsCashOnly = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Accepts NFC'),
                value: _acceptsNfc,
                onChanged: (value) {
                  setState(() {
                    _acceptsNfc = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Free Parking Lot'),
                value: _freeParkingLot,
                onChanged: (value) {
                  setState(() {
                    _freeParkingLot = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Paid Parking Lot'),
                value: _paidParkingLot,
                onChanged: (value) {
                  setState(() {
                    _paidParkingLot = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Wheelchair Accessible Parking'),
                value: _wheelchairAccessibleParking,
                onChanged: (value) {
                  setState(() {
                    _wheelchairAccessibleParking = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Wheelchair Accessible Entrance'),
                value: _wheelchairAccessibleEntrance,
                onChanged: (value) {
                  setState(() {
                    _wheelchairAccessibleEntrance = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text('Wheelchair Accessible Restroom'),
                value: _wheelchairAccessibleRestroom,
                onChanged: (value) {
                  setState(() {
                    _wheelchairAccessibleRestroom = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getForm,
                child: Text('Get Form'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _deleteForm,
                child: Text('Delete Form'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
