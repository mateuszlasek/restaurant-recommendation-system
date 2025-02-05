import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const AppNavigationBar({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      elevation: 2,
      backgroundColor: Colors.black12,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Odkryj'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Wyszukaj'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
      ],
    );
  }
}
