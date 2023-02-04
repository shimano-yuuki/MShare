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
          child: Column(
            children: [
              Expanded(
                child: Container(
                  color: Colors.blue,
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              Text(imageExplanation),
            ],
          ),
        ),
      ),
    );
  }
}
