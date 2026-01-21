import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:eyadflix/presentation/widgets/bottom_nav_bar.dart';
import 'package:eyadflix/presentation/pages/addons_page.dart';
import 'package:eyadflix/presentation/pages/library_page.dart';
import 'package:eyadflix/presentation/pages/settings_page.dart';
import 'package:eyadflix/presentation/pages/home_content_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    HomeContentPage(),
    AddonsPage(),
    LibraryPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
