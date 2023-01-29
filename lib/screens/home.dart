import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_achieve_app/screens/post/post_detail.dart';
import 'package:share_achieve_app/screens/post/post_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              final postContent = model.postContentList;
              return GridView.builder(
                // Listの長さを先ほど取り出したbooksの長さにする。
                padding: const EdgeInsets.all(10),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                // indexにはListのindexが入る。
                itemCount: postContent.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Container(
                      color: Colors.blue,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 25,
                            child: Text(
                              postContent[index].titleText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 400,
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
                            imageExplanation:
                                postContent[index].explanationText,
                            postContent: postContent[index],
                          ), // SecondPageは遷移先のクラス
                        ),
                      );
                      await model.fetchPostContent();
                    },
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
