import 'package:flutter/material.dart';
import '../models/user_form_model.dart';
import '../services/firebase_database/firebase_service.dart';

class UserFormView extends StatefulWidget {
  @override
  _UserFormViewState createState() => _UserFormViewState();
}

class _UserFormViewState extends State<UserFormView> {
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

  int _currentPageIndex = 0;

  final List<String> _categories = [
    'Informacje o restauracji',
    'Jakie opcje płatności są dla mnie priorytetem',
    'Dostępność',
  ];

  void _nextPage() {
    setState(() {
      if (_currentPageIndex < _categories.length - 1) {
        _currentPageIndex++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPageIndex > 0) {
        _currentPageIndex--;
      }
    });
  }

  Future<void> _submitForm() async {
    final userForm = UserFormModel(
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
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Formularz zapisany pomyślnie!'),
    ));
  }

  Widget _buildCategoryContent() {
    switch (_currentPageIndex) {
      case 0:
        return Column(
          children: [
            SwitchListTile(
              title: Text('Zależy mi na opcjach wegetariańskich w menu'),
              value: _servesVegetarianFood,
              onChanged: (value) {
                setState(() {
                  _servesVegetarianFood = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Udogodniania dla dzieci są dla mnie istotne'),
              value: _menuForChildren,
              onChanged: (value) {
                setState(() {
                  _goodForChildren = value;
                  _menuForChildren = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Zdarza mi się przyjść do restauracji z psem lub innym zwierzęciem'),
              value: _allowsDogs,
              onChanged: (value) {
                setState(() {
                  _allowsDogs = value;
                });
              },
            ),
          ],
        );
      case 1:
        return Column(
          children: [
            SwitchListTile(
              title: Text('Karta kredytowa'),
              value: _acceptsCreditCards,
              onChanged: (value) {
                setState(() {
                  _acceptsCreditCards = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Karta debetowa'),
              value: _acceptsDebitCards,
              onChanged: (value) {
                setState(() {
                  _acceptsDebitCards = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Płatności NFC'),
              value: _acceptsNfc,
              onChanged: (value) {
                setState(() {
                  _acceptsNfc = value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Płatność tylko gotówką nie jest dla mnie problemem'),
              value: _acceptsCashOnly,
              onChanged: (value) {
                setState(() {
                  _acceptsCashOnly = value;
                });
              },
            ),
          ],
        );
      case 2:
        return Column(
          children: [
            SwitchListTile(
              title: Text('Zależy mi na bezpłatnym parkingu w okolicy'),
              value: _freeParkingLot,
              onChanged: (value) {
                setState(() {
                  _freeParkingLot = value;
                  _paidParkingLot = !value;
                });
              },
            ),
            SwitchListTile(
              title: Text('Zależy mi na udogodnieniach dla osób z niepełnosprawnością ruchową'),
              value: _wheelchairAccessibleParking,
              onChanged: (value) {
                setState(() {
                  _wheelchairAccessibleParking = value;
                  _wheelchairAccessibleEntrance = value;
                  _wheelchairAccessibleRestroom = value;
                });
              },
            ),
          ],
        );
      default:
        return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Formularz użytkownika'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _categories[_currentPageIndex],
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(child: _buildCategoryContent()),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_currentPageIndex > 0)
                  ElevatedButton(
                    onPressed: _previousPage,
                    child: Text('Poprzedni'),
                  ),
                if (_currentPageIndex < _categories.length - 1)
                  ElevatedButton(
                    onPressed: _nextPage,
                    child: Text('Następny'),
                  ),
                if (_currentPageIndex == _categories.length - 1)
                  ElevatedButton(
                    onPressed: _submitForm,
                    child: Text('Zapisz'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
