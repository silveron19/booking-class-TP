import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import 'homepage.dart';
import 'main.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);

  const MyAppBar({super.key, required this.name});
  final String name;
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 5,
      automaticallyImplyLeading: false,
      backgroundColor: customWhite,
      title: Text(
        name,
        style: TextStyle(color: indigoDye, fontWeight: FontWeight.bold),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Symbols.notifications,
              color: dimGrey,
            )),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Symbols.person,
              color: dimGrey,
            ))
      ],
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentPage = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    // SchedulePage(),
    // RequestPage()
  ];

  void changePage(currentIndex) {
    setState(() {
      currentPage = currentIndex;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const MyAppBar(name: 'Home'),
      body: Center(
        child: _pages.elementAt(0),
      ),
      bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: indigoDye,
          currentIndex: currentPage,
          onTap: changePage,
          type: BottomNavigationBarType.fixed,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Symbols.home_filled_rounded,
                  size: 32,
                  fill: 1,
                ),
                icon: Icon(
                  Symbols.home_rounded,
                  size: 32,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Symbols.calendar_month_rounded,
                  fill: 1,
                  size: 32,
                ),
                icon: Icon(
                  Symbols.calendar_month_rounded,
                  size: 32,
                ),
                label: 'Schedule'),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Symbols.mail_rounded,
                  size: 32,
                  fill: 1,
                ),
                icon: Icon(
                  Symbols.mail_outline_rounded,
                  size: 32,
                ),
                label: 'Request'),
            BottomNavigationBarItem(
                activeIcon: Icon(
                  Symbols.domain_rounded,
                  size: 32,
                  weight: 700,
                ),
                icon: Icon(
                  Symbols.domain_rounded,
                  size: 32,
                  weight: 300,
                ),
                label: 'Classroom')
          ]),
    );
  }
}
