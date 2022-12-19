import 'package:flutter/material.dart';
import 'package:share_achieve_app/src/screens/post_page.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('投稿'),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PostPage(), // SecondPageは遷移先のクラス
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
