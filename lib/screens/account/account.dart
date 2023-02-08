import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../auth.dart';
import 'account_detail.dart';
import 'account_model.dart';
import 'profile_setting.dart';

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
              title: const Text(''),
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
            body: Column(
              children: [
                Container(
                  height: 140,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 18),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 25),
                            child: InkWell(
                              child: const CircleAvatar(
                                radius: 45,
                              ),
                              onTap: () {},
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 50, left: 18),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "data",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      width: 220,
                                      height: 50,
                                      child: Text(
                                          "datafafjiefjeifjejijeijejiejfifjeifjefjiejfejfejfifjifwojowjfejifjfowejeifejifefjifjfifowowfjeijfjeijfjjjeijfiefjefjwojifejfieis"))
                                ]),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 44, left: 14),
                              child: InkWell(
                                child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.black, width: 0.7),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Text("編集")),
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                          FirebaseAuth.instance.currentUser!),
                                    ),
                                  );
                                },
                              ))
                        ]),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Consumer<AccountModel>(
                      builder: (context, model, child) {
                        // FirestoreのドキュメントのList booksを取り出す。
                        final accountContent = model.accountContentList;
                        return GridView.builder(
                          // Listの長さを先ほど取り出したbooksの長さにする。
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                          ),
                          // indexにはListのindexが入る。
                          itemCount: accountContent.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              child: Container(
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
                                      imageTitle:
                                          accountContent[index].titleText,
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
                ),
              ],
            ),
          ),
        ));
  }
}
