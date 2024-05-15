import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nucleus/pages/alert_page.dart';
import 'package:nucleus/pages/home_page.dart';
import 'package:nucleus/pages/info_page.dart';
import 'package:nucleus/pages/settings_page.dart';

class BottomNavBarDemo extends StatefulWidget {
  const BottomNavBarDemo({super.key});

  @override
  _BottomNavBarDemoState createState() => _BottomNavBarDemoState();
}

class _BottomNavBarDemoState extends State<BottomNavBarDemo> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomePage(),
    const AlertPage(),
    const SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: const Text(
          "Nucleus",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return DevelopmentTeamPage();
                  },
                ),
              );
            },
            icon: const Icon(
              Icons.info_outline_rounded,
            ),
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: GNav(
          selectedIndex: _currentIndex,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Ana Sayfa',
              iconColor: Colors.blueGrey,
              textColor: Colors.blueGrey,
              backgroundColor: Colors.blueGrey.withOpacity(0.2),
              iconActiveColor: Colors.blueGrey,
            ),
            GButton(
              icon: Icons.notifications_active,
              text: 'Alarm',
              iconColor: Colors.redAccent,
              textColor: Colors.redAccent,
              backgroundColor: Colors.redAccent.withOpacity(0.2),
              iconActiveColor: Colors.redAccent,
            ),
            GButton(
              icon: Icons.settings,
              text: 'Ayarlar',
              iconColor: Colors.lightGreen,
              textColor: Colors.lightGreen,
              backgroundColor: Colors.lightGreen.withOpacity(0.2),
              iconActiveColor: Colors.lightGreen,
            ),
          ],
          onTabChange: (index) {
            setState(() {
              _currentIndex = index;
              debugPrint("Index: $index");
            });
          },
        ),
      ),
    );
  }
}
