import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_achieve_app/screens/post/post_model.dart';
import 'package:share_achieve_app/screens/post/post_page.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ChangeNotifierProvider<PostModel>(
        create: (_) => PostModel()..fetchPostContent(),
        child: Scaffold(
          appBar: AppBar(
            title: const Text('投稿'),
          ),
          body: Consumer<PostModel>(
            builder: (context, model, child) {
              // FirestoreのドキュメントのList booksを取り出す。
              final post_content = model.post_content;
              return ListView.builder(
                // Listの長さを先ほど取り出したbooksの長さにする。
                itemCount: post_content.length,
                // indexにはListのindexが入る。
                itemBuilder: (context, index) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          child: Text(
                        post_content[index].text,
                      )),
                      Container(
                        child: Image.network(
                          post_content[index].url,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  );
                },
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.blue,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostPage(
                      FirebaseAuth.instance.currentUser!), // SecondPageは遷移先のクラス
                ),
              );
            },
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}
