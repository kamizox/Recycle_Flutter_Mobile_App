import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:first_project/home.dart';
import 'package:first_project/points.dart';
import 'package:first_project/profile.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;

  final List<Widget> pages = [Home(), Points(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 70,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white, size: 34.0),
          Icon(Icons.point_of_sale, color: Colors.white, size: 34.0),
          Icon(Icons.person, color: Colors.white, size: 34.0),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
