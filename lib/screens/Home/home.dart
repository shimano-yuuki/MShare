import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../account/account_page.dart';
import 'home_detail.dart';
import 'home_model.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final userID = auth.FirebaseAuth.instance.currentUser?.uid ?? '';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeModel>(
      create: (_) => HomeModel()
        ..blockList()
        ..fetchHomeContent()
        ..blockList(),
      child: Scaffold(
        backgroundColor: Color(0xFF262626),
        appBar: AppBar(
          backgroundColor: Color(0xFF262626),
          title: const Text('皆んなの投稿'),
        ),
        body: Consumer<HomeModel>(
          builder: (context, model, child) {
            // FirestoreのドキュメントのList booksを取り出す。
            final homeContent = model.homeContentList;
            return ListView.builder(
              itemCount: homeContent.length,
              itemBuilder: (context, index) {
                return Visibility(
                  visible: !(model.blockIds?.contains(homeContent[index].uid) ??
                      false),
                  child: InkWell(
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
                                  child: CircleAvatar(
                                    backgroundColor: Colors.grey,
                                    backgroundImage: NetworkImage(
                                        homeContent[index].userImgURL),
                                  ),
                                  onTap: () async {
                                    print(model.blockIds);
                                    final uid = homeContent[index].uid;
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AccountScreen(
                                            uid), // SecondPageは遷移先のクラス
                                      ),
                                    );
                                  },
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        homeContent[index].userName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        homeContent[index].titleText,
                                        style: const TextStyle(
                                          color: Colors.white,
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
                            imageExplanation:
                                homeContent[index].explanationText,
                            homeContent: homeContent[index],
                          ), // SecondPageは遷移先のクラス
                        ),
                      );
                      await model.fetchHomeContent();
                    },
                  ),
                );
              },
            );
          },
        ),
        drawer: Consumer<HomeModel>(builder: (context, model, child) {
          return Drawer(
            backgroundColor: Color(0xFF262626),
            child: ListView(
              children: [
                ListTile(
                    title: Text('ログアウト',
                        style: TextStyle(
                          color: Colors.white,
                        )),
                    onTap: () {
                      model.logoutDialog(context);
                    }),
                ListTile(
                  title: Text('アカウント削除',
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  onTap: () {
                    model.deleteDialog(context);
                  },
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
