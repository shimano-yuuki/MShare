import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_achieve_app/screens/post/add_post_page.dart';
import 'package:share_achieve_app/screens/post/post_detail_page.dart';
import 'package:share_achieve_app/screens/post/post_page_model.dart';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PostModel>(
      create: (_) => PostModel()..fetchPostContent(),
      child: Scaffold(
        backgroundColor: Color(0xFF262626),
        appBar: AppBar(
          title: const Text('投稿一覧'),
        ),
        body: Consumer<PostModel>(
          builder: (context, model, child) {
            // FirestoreのドキュメントのList booksを取り出す。
            final postContent = model.postContentList;
            return GridView.builder(
              // Listの長さを先ほど取り出したbooksの長さにする。
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              // indexにはListのindexが入る。
              itemCount: postContent.length,
              itemBuilder: (context, index) {
                return InkWell(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.white, width: 0.3)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: SizedBox(
                            width: 200,
                            child: Image.network(
                              postContent[index].url,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PostDetail(
                          imageUrl: postContent[index].url,
                          imageTitle: postContent[index].titleText,
                          imageExplanation: postContent[index].explanationText,
                          postContent: postContent[index],
                        ),
                      ),
                    );
                    await model.fetchPostContent();
                  },
                );
              },
            );
          },
        ),
        floatingActionButton: Consumer<PostModel>(
          builder: (context, model, child) {
            return FloatingActionButton(
              backgroundColor: Colors.blue,
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PostPage(FirebaseAuth
                        .instance.currentUser!), // SecondPageは遷移先のクラス
                  ),
                );
                await model.fetchPostContent();
              },
              child: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
    );
  }
}
