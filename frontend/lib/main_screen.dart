import 'package:flutter/material.dart';
import 'package:frontend/pages/generate_page.dart';
import 'package:frontend/pages/reference_page.dart';
import 'package:frontend/pages/settings_page.dart';
import 'package:frontend/pages/status_page.dart';

class MainScreen extends StatefulWidget {
  final String title;
  const MainScreen(this.title, {Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      GeneratePage(widget.title),
      const ReferencePage(),
      const StatusPage(),
      const SettingsPage()
    ];
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentPage != 0 ? AppBar(title: Text(widget.title)) : null,
      body: _pages?[_currentPage] ?? const Center(),
      bottomNavigationBar: Theme(
        data: Theme.of(context)
            .copyWith(canvasColor: Theme.of(context).primaryColor),
        child: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.create_rounded), label: "Generate"),
            BottomNavigationBarItem(
                icon: Icon(Icons.assignment), label: "Reference"),
            BottomNavigationBarItem(
                icon: Icon(Icons.handshake), label: "Status"),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: "Settings")
          ],
          onTap: (value) {
            setState(() {
              _currentPage = value;
            });
          },
          currentIndex: _currentPage,
        ),
      ),
    );
  }
}
