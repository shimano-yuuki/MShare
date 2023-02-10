import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'home_detail.dart';
import 'home_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()..fetchHomeContent(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('皆んなの投稿'),
        ),
        body: Consumer<HomeModel>(
          builder: (context, model, child) {
            // FirestoreのドキュメントのList booksを取り出す。
            final homeContent = model.homeContentList;
            return ListView.builder(
              itemCount: homeContent.length,
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "せりざわ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      homeContent[index].titleText,
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
                              homeContent[index].url,
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
                        builder: (context) => HomeDetail(
                          imageUrl: homeContent[index].url,
                          imageTitle: homeContent[index].titleText,
                          imageExplanation: homeContent[index].explanationText,
                          homeContent: homeContent[index],
                        ), // SecondPageは遷移先のクラス
                      ),
                    );
                    await model.fetchHomeContent();
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
