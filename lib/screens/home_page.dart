import 'package:flutter/material.dart';
import 'package:part_ia/screens/screens_home/search_recipes_screen.dart';
import 'package:part_ia/screens/screens_home/chat_screen.dart';
import 'package:part_ia/screens/screens_home/profile_screen.dart';
import 'package:part_ia/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import '../providers/usuario_provider.dart';

String apiKey = 'AIzaSyDE_IvbK3BRi0605Q_FwKfQZgqGaD0pUfk';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    SearchRecipesScreen(),
    ChatScreen(apiKey: apiKey),
    UserProfileScreen(),
  ];

  // Handle navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}


/*
import 'package:flutter/material.dart';

import 'package:part_ia/screens/screens_home/search_recipes_screen.dart';
import 'package:part_ia/screens/screens_home/chat_screen.dart';
import 'package:part_ia/screens/screens_home/profile_screen.dart';
import 'package:part_ia/screens/screens_home/settings_screen.dart';

import 'package:part_ia/widgets/bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import '../providers/Usuario_provider.dart';


String apiKey = 'AIzaSyDE_IvbK3BRi0605Q_FwKfQZgqGaD0pUfk';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;


  // List of screens
  final List<Widget> _screens = [
    SearchRecipesScreen(),
    ChatScreen(apiKey: apiKey),
    ProfileScreen(),
    SettingsScreen(), // Add Settings screen to the list
  ];

  // Handle navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = Provider.of<UsuarioProvider>(context);

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

 */
