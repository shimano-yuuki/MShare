import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'account_content.dart';

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
  final AccountContent accountContent;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(imageTitle),
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
                  style: TextStyle(
                    fontSize: 25,
                  ),
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
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
