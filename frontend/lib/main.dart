import 'package:flutter/material.dart';
import 'package:frontend/db.dart';
import './main_screen.dart';

void main() async {
  await DB.initialize();
  runApp(const HordeArt());
}

class HordeArt extends StatelessWidget {
  const HordeArt({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Horde Art',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MainScreen('Horde Art'),
    );
  }
}
