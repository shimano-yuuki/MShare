import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_achieve_app/screens/Home/home_model.dart';
import 'package:share_achieve_app/screens/post/post_detail.dart';

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
            title: const Text('皆んなの投稿'),
          ),
          body: Consumer<PostModel>(
            builder: (context, model, child) {
              // FirestoreのドキュメントのList booksを取り出す。
              final postContent = model.postContentList;
              return ListView.builder(
                itemCount: postContent.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      height: 400,
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            height: 55,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  child: const CircleAvatar(),
                                  onTap: () {},
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "せりざわ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        postContent[index].titleText,
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              width: 500,
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
