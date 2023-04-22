import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';

import '../../app.dart';
import 'account.dart';
import 'user.dart';

class AccountModel extends ChangeNotifier {
  final String uid;
  final userID = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  // ユーザー情報
  AccountModel(this.uid);
  // ListView.builderで使うためのBookのList booksを用意しておく。
  List<Account> accountContentList = [];
  User? user;

  Future<void> fetchAccountContent() async {
    // Firestoreからコレクション'books'(QuerySnapshot)を取得してdocsに代入。
    final docs = await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('posts')
        .orderBy('date', descending: true)
        .get();

    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final accountContent = docs.docs.map((doc) => Account(doc)).toList();
    accountContentList = accountContent;
    notifyListeners();
  }

  Future fetchUser() async {
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final user = User(doc);
    this.user = user;
    notifyListeners();
  }

  Future<void> blockUser() async {
    FirebaseFirestore.instance
        .collection('users') // コレクションID指定
        .doc(userID)
        .collection('blocks')
        .doc()
        .set({
      'blockUserId': uid,
    });
    notifyListeners();
  }

  Future blockUserDialog(BuildContext context, String uid) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("ブロックの確認"),
          content: Text('このユーザーをブロックしますか？'),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                blockUser();
                print('userId; $uid');
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('投稿者をブロックしました'),
                    behavior: SnackBarBehavior.fixed, //デフォルト設定
                  ),
                );
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return MyApp();
                  }),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
