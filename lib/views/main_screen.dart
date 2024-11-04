import 'package:flutter/material.dart';

import 'package:proj_inz/views/profile_section.dart';
import 'package:proj_inz/views/search_section.dart';
import 'package:proj_inz/views/home_section.dart';

import '../components/app_bar.dart';
import '../components/navigation_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _sections = [
    HomeSection(),
    SearchSection(),
    ProfileSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: _sections[_currentIndex],
      bottomNavigationBar: AppNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}