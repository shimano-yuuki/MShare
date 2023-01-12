import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

int upload = 1;

class PostPage extends StatefulWidget {
  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final picker = ImagePicker();

  /// ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  Future getImageFromCamera() async {
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.camera);
      File _image = File(pickedFile!.path);

      /// Firebase Cloud Storageにアップロード
      String uploadName = 'image.png$upload';
      upload = upload + 1;
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
      storageRef.putFile(_image);
    } catch (e) {
      print(e);
    }
  }

  Future _getImage() async {
    try {
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      File _image = File(pickedFile!.path);

      /// Firebase Cloud Storageにアップロード
      String uploadName = 'image.png$upload';
      upload = upload + 1;
      final storageRef =
          FirebaseStorage.instance.ref().child('users/$userID/$uploadName');
      storageRef.putFile(_image);
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("投稿画面"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 30,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              FloatingActionButton(
                onPressed: getImageFromCamera,
                child: Icon(Icons.add_a_photo),
              ),
              FloatingActionButton(
                onPressed: _getImage,
                child: Icon(Icons.image),
              ),
            ],
          )
        ],
      )),
    );
  }
}
