import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_achieve_app/screens/post/add_post_page.dart';
import 'package:share_achieve_app/screens/post/post_detail.dart';
import 'package:share_achieve_app/screens/post/post_model.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
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
              final post_content = model.postContentList;
              return GridView.builder(
                // Listの長さを先ほど取り出したbooksの長さにする。
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                // indexにはListのindexが入る。
                itemCount: post_content.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Container(
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 25,
                            child: Text(
                              post_content[index].titleText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              width: 200,
                              child: Image.network(
                                post_content[index].url,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetail(
                            imageUrl: post_content[index].url,
                            imageTitle: post_content[index].titleText,
                            imageExplanation:
                                post_content[index].explanationText,
                          ), // SecondPageは遷移先のクラス
                        ),
                      );
                    },
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
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
