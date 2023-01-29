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
                          SizedBox(
                            height: 25,
                            child: Text(
                              post_content[index].titleText,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
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
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetail(
                            imageUrl: post_content[index].url,
                            imageTitle: post_content[index].titleText,
                            imageExplanation:
                                post_content[index].explanationText,
                            postContent: post_content[index],
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
