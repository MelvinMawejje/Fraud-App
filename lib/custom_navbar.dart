// ignore: file_names

import 'package:flutter/material.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar({super.key});

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
 // int _selectedIndex = 1; // Default to home (index 1)

  void _onItemTapped(int index, String route) {
    setState(() {
     // _selectedIndex = index;
    });
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      //height: 60,
      color: const Color.fromARGB(255, 193, 154, 107),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildNavItem(0, Icons.account_circle, 'Profile', '/profile'),
          _buildNavItem(1, Icons.home, 'Home', '/home'),
          _buildNavItem(2, Icons.settings, 'Settings', '/settings'),
        ],
      )
    );
  }
  
  Widget _buildNavItem(int index, IconData icon, String label, String route) {
    //final bool isSelected = _selectedIndex == index;
    final color =  Colors.black;
    
    return Column(
      children: [
        Expanded(
          child: IconButton(
            icon: Icon(icon, size: 34, color: color),
            onPressed: () => _onItemTapped(index, route),
          ),                
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: color,
          ),
        ),
      ],
    );
  }
}
