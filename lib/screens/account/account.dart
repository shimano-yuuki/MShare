import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth.dart';
import 'account_detail.dart';
import 'account_model.dart';

class AccountScreen extends StatelessWidget {
// 引数からユーザー情報を受け取れるようにする
  const AccountScreen(this.user, {super.key});
  // ユーザー情報
  final User user;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primarySwatch: Colors.blue),
        home: ChangeNotifierProvider<AccountModel>(
          create: (_) => AccountModel()..fetchAccountContent(),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('アカウント画面'),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () async {
                    // ログアウト処理
                    // 内部で保持しているログイン情報等が初期化される
                    // （現時点ではログアウト時はこの処理を呼び出せばOKと、思うぐらいで大丈夫です）
                    await FirebaseAuth.instance.signOut();
                    // ログイン画面に遷移＋チャット画面を破棄
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }),
                    );
                  },
                ),
              ],
            ),
            body: Consumer<AccountModel>(
              builder: (context, model, child) {
                // FirestoreのドキュメントのList booksを取り出す。
                final accountContent = model.accountContentList;
                return GridView.builder(
                  // Listの長さを先ほど取り出したbooksの長さにする。
                  padding: const EdgeInsets.all(10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  // indexにはListのindexが入る。
                  itemCount: accountContent.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: Colors.black, width: 0.3)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: SizedBox(
                                width: 200,
                                child: Image.network(
                                  accountContent[index].url,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // SizedBox(
                            //   height: 25,
                            //   child: Text(
                            //     post_content[index].titleText,
                            //     style: const TextStyle(
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AccountDetail(
                              imageUrl: accountContent[index].url,
                              imageTitle: accountContent[index].titleText,
                              imageExplanation:
                                  accountContent[index].explanationText,
                              accountContent: accountContent[index],
                            ), // SecondPageは遷移先のクラス
                          ),
                        );
                        await model.fetchAccountContent();
                      },
                    );
                  },
                );
              },
            ),
          ),
        ));
  }
}
