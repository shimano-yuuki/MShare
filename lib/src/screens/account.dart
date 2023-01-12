import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);
// 引数からユーザー情報を受け取れるようにする

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('マイページ')),
      body:
          const Center(child: Text('マイページ', style: TextStyle(fontSize: 32.0))),
    );
  }
}
