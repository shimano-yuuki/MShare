import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../app.dart';

class FirstProfileScreen extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  const FirstProfileScreen(this.user, {super.key});
  // ユーザー情報
  final User user;
  @override
  // ignore: library_private_types_in_public_api
  _FirstProfileScreenState createState() => _FirstProfileScreenState();
}

class _FirstProfileScreenState extends State<FirstProfileScreen> {
  File? _image;
  final picker = ImagePicker();
  String userName = "";
  String selfIntroduction = "";
  bool isLoading = false;

  /// ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  ///ランダムに名前を取得する
  String randomString(int length) {
    const randomChars =
        "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    const charsLength = randomChars.length;
    final rand = Random();
    final codeUnits = List.generate(
      length,
      (index) {
        final n = rand.nextInt(charsLength);
        return randomChars.codeUnitAt(n);
      },
    );
    return String.fromCharCodes(codeUnits);
  }

  Future _getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 3);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        if (kDebugMode) {
          print('No image selected.');
        }
      }
    });
  }

  Future profileData() async {
    setState(() {
      isLoading = true;
    });
    String? imageURL;
    String rand = randomString(15);

    /// Firebase Cloud Storageにアップロード
    String uploadName = rand;
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
    final storedImage = await storageRef.putFile(_image!);
    imageURL = await storedImage.ref.getDownloadURL();
    // AddPostPage のデータを参照
    // 投稿メッセージ用ドキュメント作成

    await FirebaseFirestore.instance
        .collection('users') // コレクションID指定
        .doc(userID) // ドキュメントID自動生成
        .set(
      {
        'imgURL': imageURL,
        'userName': userName,
        'selfIntroduction': selfIntroduction,
      },
    );

    setState(() {
      isLoading = false;
    });
    // ignore: use_build_context_synchronously
    await Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) {
        return const MyApp();
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF262626),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
          backgroundColor: Color(0xFF262626),
          title: const Text(
            "プロフィール設定",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
      body: Center(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ConstrainedBox(
              constraints:
                  const BoxConstraints(maxWidth: 200.0, maxHeight: 200.0),
              child: Container(
                  child: _image == null
                      ? const Text(
                          '（必須）画像',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      : Image.file(_image!)),
            ),
            const SizedBox(
              height: 30,
            ),
            FloatingActionButton(
              backgroundColor: Color(0xFF0d4680),
              onPressed: _getImage,
              child: const Icon(Icons.image),
            ),
            SizedBox(height: 20),
            TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: '（必須）名前',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              // 複数行のテキスト入力
              keyboardType: TextInputType.multiline,
              // 最大3行
              maxLines: 1,
              onChanged: (String value) {
                setState(() {
                  userName = value;
                });
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              style: TextStyle(
                color: Colors.white,
              ),
              decoration: const InputDecoration(
                labelText: '（任意）自己紹介',
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                  ),
                ),
              ),
              // 複数行のテキスト入力
              keyboardType: TextInputType.multiline,
              // 最大3行
              maxLines: 4,
              onChanged: (String value) {
                setState(() {
                  selfIntroduction = value;
                });
              },
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: profileData,
                  child: const Text(
                    '設定',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  )),
            ),
          ],
        ),
      )),
    );
  }
}
