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
        appBar: AppBar(title: const Text("プロフィール設定")),
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
                          ? const Text('画像を選んでください')
                          : Image.file(model.image!)),
                ),
                const SizedBox(
                  height: 30,
                ),
                FloatingActionButton(
                  onPressed: model.getImage,
                  child: const Icon(Icons.image),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: '名前'),
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
                TextFormField(
                  decoration: const InputDecoration(labelText: '自己紹介'),
                  // 複数行のテキスト入力
                  keyboardType: TextInputType.multiline,
                  // 最大3行
                  maxLines: 6,
                  onChanged: (String value) {
                    setState(() {
                      selfIntroduction = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
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
