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
  String messageText = '';
  File? _image;
  final picker = ImagePicker();

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
    String rand = randomString(15);

    /// Firebase Cloud Storageにアップロード
    String uploadName = '$rand';
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
    storageRef.putFile(_image!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("投稿画面"), actions: <Widget>[
        IconButton(
          icon: Icon(Icons.image),
          onPressed: postdata,
        )
      ]),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 320.0, maxHeight: 320.0),
            child: Container(
                child: _image == null ? Text('画像はありません') : Image.file(_image!)),
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
            decoration: InputDecoration(labelText: '投稿メッセージ'),
            // 複数行のテキスト入力
            keyboardType: TextInputType.multiline,
            // 最大3行
            maxLines: 3,
            onChanged: (String value) {
              setState(() {
                messageText = value;
              });
            },
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              child: Text('投稿'),
              onPressed: () async {
                final date =
                    DateTime.now().toLocal().toIso8601String(); // 現在の日時
                final email = widget.user.email; // AddPostPage のデータを参照
                // 投稿メッセージ用ドキュメント作成
                await FirebaseFirestore.instance
                    .collection('posts') // コレクションID指定
                    .doc() // ドキュメントID自動生成
                    .set({'text': messageText, 'email': email, 'date': date});
                // 1つ前の画面に戻る
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      )),
    );
  }
}
