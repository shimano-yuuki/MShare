import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_achieve_app/screens/Home/home_content.dart';

import '../../auth/auth_page.dart';

class HomeModel extends ChangeNotifier {
  // ListView.builderで使うためのBookのList booksを用意しておく。
  final userID = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  List<HomeContent> homeContentList = [];
  List<String>? blockIds;

  Future<void> blockList() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userID)
        .collection('blocks')
        .where('blockUserId', isNotEqualTo: userID) // 〜と等しくない
        .get();

    final List<String>? blockIds =
        snapshot.docs.map((DocumentSnapshot document) {
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;

      final String blockUserId = data['blockUserId'];
      return (blockUserId);
    }).toList();

    this.blockIds = blockIds;
    notifyListeners();
  }

  Future<void> fetchHomeContent() async {
    // Firestoreからコレクション'books'(QuerySnapshot)を取得してdocsに代入。
    final docs = await FirebaseFirestore.instance
        .collectionGroup('posts')
        .orderBy('date', descending: true)
        .get();
    // getter docs: docs(List<QueryDocumentSnapshot<T>>型)のドキュメント全てをリストにして取り出す。
    // map(): Listの各要素をBookに変換
    // toList(): Map()から返ってきたIterable→Listに変換する。
    final homeContent = docs.docs.map((doc) => HomeContent(doc)).toList();
    homeContentList = homeContent;
    notifyListeners();
  }

  Future<void> deletePost(String postId) async {
    await FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  Future logoutDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("ログアウト"),
          content: Text('ログアウトしますか？'),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                // ログアウト処理
                // 内部で保持しているログイン情報等が初期化される
                // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
                await FirebaseAuth.instance.signOut();
                // ログイン画面に遷移＋チャット画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return AuthPage();
                  }),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future deleteDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: Text("アカウント削除"),
          content: Text('アカウント削除しますか？'),
          actions: [
            TextButton(
              child: Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text("はい"),
              onPressed: () async {
                // ログアウト処理
                // 内部で保持しているログイン情報等が初期化される
                // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
                final user = FirebaseAuth.instance.currentUser; // ?つけないとエラーが出る!
                await user?.delete();
                // ログイン画面に遷移＋チャット画面を破棄
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) {
                    return AuthPage();
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
