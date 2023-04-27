import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_detail.dart';
import 'account_page_model.dart';
import 'account_profile_setting.dart';

class AccountScreen extends StatelessWidget {
// 引数からユーザー情報を受け取れるようにする
  const AccountScreen(this.uid, {super.key});

  // ユーザー情報
  final String uid;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountModel>(
      create: (_) => AccountModel(uid)
        ..fetchAccountContent()
        ..fetchUser(),
      child: Consumer<AccountModel>(builder: (context, model, child) {
        // FirestoreのドキュメントのList booksを取り出す。
        final user = model.user;
        return Scaffold(
          backgroundColor: Color(0xFF262626),
          appBar: AppBar(
            backgroundColor: Color(0xFF262626),
            actions: <Widget>[
              if (FirebaseAuth.instance.currentUser!.uid != uid)
                IconButton(
                  icon: const Icon(Icons.not_interested_outlined),
                  onPressed: () async {
                    model.blockUserDialog(context, uid);
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage: NetworkImage(
                            user?.imgURL ??
                                'https://pics.prcm.jp/8fa8ecb4210ea/85340511/png/85340511_480x480.png',
                          ),
                          radius: 45,
                        ),
                        SizedBox(width: 20),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                user?.userName ?? "",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                user?.selfIntroduction ?? "",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              )
                            ]),
                        Spacer(),
                        if (FirebaseAuth.instance.currentUser!.uid == uid)
                          InkWell(
                            child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.white, width: 0.7),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  "編集",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                )),
                            onTap: () async {
                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                      FirebaseAuth.instance.currentUser!),
                                ),
                              );
                            },
                          ),
                        SizedBox(
                          width: 30,
                        )
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
              ),
            ],
          ),
        );
      }),
    );
  }
}
