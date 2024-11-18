import 'package:flutter/material.dart';

AppBar buildAppBar() {
  return AppBar(
    title: const Text(
      'Projekt Inżynierski',
      style: TextStyle(color: Colors.amber, fontFamily: "Comic Sans"),
    ),
    shadowColor: Colors.black12,
    surfaceTintColor: Colors.black12,
    backgroundColor: Colors.black12,
    foregroundColor: Colors.black12,
    centerTitle: true,
  );
}
