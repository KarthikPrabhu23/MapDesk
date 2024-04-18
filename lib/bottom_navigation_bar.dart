import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:awesome_bottom_bar/widgets/inspired/inspired.dart';
import 'package:flutter/material.dart';
import 'package:map1/Chat/chat_screen.dart';
import 'package:map1/Home/home_page.dart';
import 'package:map1/Home/profile_page.dart';
import 'package:map1/Record/record.dart';
import 'package:map1/my_colors.dart';

class MyBottomNavigationBar extends StatefulWidget {
  const MyBottomNavigationBar({super.key});

  @override
  _MyBottomNavigationBarState createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int _selectedIndex = 0; // Index of the selected item

  static const List<TabItem> items = [
    TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    TabItem(
      icon: Icons.book,
      title: 'Records',
    ),
    TabItem(
      icon: Icons.map,
      title: 'Map',
    ),
    TabItem(
      icon: Icons.message,
      title: 'Chat',
    ),
    TabItem(
      icon: Icons.account_box,
      title: 'profile',
    ),
  ];

  // List of pages corresponding to each item
  final List<Widget> _pages = [
    const MyHomePage(),
    const RecordLog(),
    const ProfilePage(),
    const ChatScreen(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          scaffoldBackgroundColor: 
          body: _pages[_selectedIndex],
          bottomNavigationBar: BottomBarInspiredInside(
            items: items,
            backgroundColor: MyColors.ButtonBlue,
            color: Colors.white,
            colorSelected: Colors.white,
            indexSelected: _selectedIndex,
            onTap: (int index) => setState(() {
              _selectedIndex = index;
            }),
            chipStyle: const ChipStyle(convexBridge: true),
            itemStyle: ItemStyle.circle,
            animated: false,
          ),
        ),
      ),
    );
  }
}
