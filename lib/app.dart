//全体共有
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_achieve_app/screens/Home/home.dart';
import 'package:share_achieve_app/screens/account/account_page.dart';
import 'package:share_achieve_app/screens/post/post_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _screens = [
    const HomeScreen(),
    const PostScreen(),
    if (FirebaseAuth.instance.currentUser != null)
      AccountScreen(FirebaseAuth.instance.currentUser!.uid)
  ];

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          backgroundColor: Color(0xFF0d4680),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ホーム'),
            BottomNavigationBarItem(icon: Icon(Icons.post_add), label: '投稿'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'アカウント'),
          ],
          type: BottomNavigationBarType.fixed,
        ));
  }
}
