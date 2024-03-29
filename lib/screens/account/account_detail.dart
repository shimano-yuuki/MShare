import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'account.dart';

final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

class AccountDetail extends StatelessWidget {
  const AccountDetail({
    super.key,
    required this.imageUrl,
    required this.imageTitle,
    required this.imageExplanation,
    required this.accountContent,
  });

  final String imageUrl;
  final String imageTitle;
  final String imageExplanation;
  final Account accountContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Color(0xFF262626),
        title: Text(imageTitle),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  imageTitle,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Image.network(
                      imageUrl,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 6),
                    child: Text(
                      imageExplanation,
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
