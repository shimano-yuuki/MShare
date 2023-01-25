import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostPage extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  PostPage(this.user);
  // ユーザー情報
  final User user;

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String titleText = '';
  File? _image;
  final picker = ImagePicker();
  String explanationText = "";

  /// ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  ///ランダムに名前を取得する
  String randomString(int length) {
    const _randomChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const _charsLength = _randomChars.length;

    final rand = new Random();
    final codeUnits = new List.generate(
      length,
      (index) {
        final n = rand.nextInt(_charsLength);
        return _randomChars.codeUnitAt(n);
      },
    );
    return new String.fromCharCodes(codeUnits);
  }

  Future _getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future postdata() async {
    String? imageURL = null;
    String rand = randomString(15);

    /// Firebase Cloud Storageにアップロード
    String uploadName = '$rand';
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
    final storedImage = await storageRef.putFile(_image!);
    imageURL = await storedImage.ref.getDownloadURL();

    final date = DateTime.now().toLocal().toIso8601String(); // 現在の日時
    final email = widget.user.email; // AddPostPage のデータを参照
    // 投稿メッセージ用ドキュメント作成
    await FirebaseFirestore.instance
        .collection('posts') // コレクションID指定
        .doc() // ドキュメントID自動生成
        .set({
      'titleText': titleText,
      'explanationText': explanationText,
      'email': email,
      'date': date,
      'imgURL': imageURL,
    });

    // 1つ前の画面に戻る
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("投稿画面")),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200.0, maxHeight: 200.0),
              child: Container(
                  child:
                      _image == null ? Text('画像はありません') : Image.file(_image!)),
            ),
            SizedBox(
              height: 30,
            ),
            FloatingActionButton(
              onPressed: _getImage,
              child: Icon(Icons.image),
            ),

            // 投稿メッセージ入力
            TextFormField(
              decoration: InputDecoration(labelText: '題名'),
              // 複数行のテキスト入力
              keyboardType: TextInputType.multiline,
              // 最大3行
              maxLines: 2,
              onChanged: (String value) {
                setState(() {
                  titleText = value;
                });
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: '説明'),
              // 複数行のテキスト入力
              keyboardType: TextInputType.multiline,
              // 最大3行
              maxLines: 5,
              onChanged: (String value) {
                setState(() {
                  explanationText = value;
                });
              },
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              child: ElevatedButton(child: Text('投稿'), onPressed: postdata),
            ),
          ],
        ),
      )),
    );
  }
}
