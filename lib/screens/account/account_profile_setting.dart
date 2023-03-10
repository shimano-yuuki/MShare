import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'account_profile_setting_model.dart';

class ProfileScreen extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  const ProfileScreen(this.user, {super.key});
  // ユーザー情報
  final User user;
  @override
  // ignore: library_private_types_in_public_api
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userName = '';
  String selfIntroduction = '';

  /// ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AccountProfileSettingModel>(
      create: (_) => AccountProfileSettingModel(
        widget.user,
      ),
      child: Scaffold(
        backgroundColor: Color(0xFF262626),
        appBar: AppBar(
          title: const Text("プロフィール設定"),
          backgroundColor: Color(0xFF262626),
        ),
        body: Consumer<AccountProfileSettingModel>(
            builder: (context, model, child) {
          if (model.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Center(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(maxWidth: 200.0, maxHeight: 200.0),
                  child: Container(
                      child: model.image == null
                          ? const Text('画像を選んでください',
                              style: TextStyle(color: Colors.white))
                          : Image.file(model.image!)),
                ),
                const SizedBox(
                  height: 30,
                ),
                FloatingActionButton(
                  backgroundColor: Color(0xFF0d4680),
                  onPressed: model.getImage,
                  child: const Icon(Icons.image),
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: '名前',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // 複数行のテキスト入力
                  keyboardType: TextInputType.multiline,
                  // 最大3行
                  maxLines: 1,
                  onChanged: (String value) {
                    setState(() {
                      userName = value;
                    });
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: const InputDecoration(
                    labelText: '自己紹介',
                    labelStyle: TextStyle(
                      color: Colors.white,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  // 複数行のテキスト入力
                  keyboardType: TextInputType.multiline,
                  // 最大3行
                  maxLines: 4,
                  onChanged: (String value) {
                    setState(() {
                      selfIntroduction = value;
                    });
                  },
                ),
                const SizedBox(height: 25),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        await model.profileData(userName, selfIntroduction);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text('設定')),
                ),
              ],
            ),
          ));
        }),
      ),
    );
  }
}
