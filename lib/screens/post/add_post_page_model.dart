import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

import '../account/user.dart';

class AddPostModel extends ChangeNotifier {
  AddPostModel(
    this.authUser,
  );
  final auth.User authUser;

  final userID = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  File? image;
  final picker = ImagePicker();
  bool isLoading = false;

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

  Future getImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 3);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      notifyListeners();
    } else {
      if (kDebugMode) {
        print('No image selected.');
      }
      notifyListeners();
    }
  }

  Future postData(String nameText, String explanationText) async {
    isLoading = true;
    notifyListeners();

    String? imageURL;
    String rand = randomString(15);

    /// Firebase Cloud Storageにアップロード
    String uploadName = rand;
    final storageRef =
        FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
    final storedImage = await storageRef.putFile(image!);
    imageURL = await storedImage.ref.getDownloadURL();

    final doc =
        await FirebaseFirestore.instance.collection('users').doc(userID).get();
    final user = User(doc);

    final date = DateTime.now().toLocal().toIso8601String(); // 現在の日時
    final email = authUser.email; // AddPostPage のデータを参照
    // 投稿メッセージ用ドキュメント作成
    await FirebaseFirestore.instance
        .collection('users') // コレクションID指定
        .doc(userID) // ドキュメントID自動生成
        .collection('posts')
        .doc()
        .set({
      'nameText': nameText,
      'explanationText': explanationText,
      'email': email,
      'date': date,
      'imgURL': imageURL,
      'selfIntroduction': user.selfIntroduction,
      'userName': user.userName,
      'userImgURL': user.imgURL,
      'userId': userID,
    });
    isLoading = false;
    notifyListeners();
  }
}
