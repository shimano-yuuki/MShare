import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_achieve_app/app.dart';
import 'package:share_achieve_app/auth/sign_up_page.dart';
import 'package:url_launcher/link.dart';

import 'log_in_page.dart';

class AuthWidget extends StatelessWidget {
  const AuthWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // スプラッシュ画面などに書き換えても良い
            return const SizedBox();
          }
          if (snapshot.hasData) {
            // User が null でなない、つまりサインイン済みのホーム画面へ
            return const MyApp();
          }
          // User が null である、つまり未サインインのサインイン画面へ
          return const AuthPage();
        },
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  // メッセージ表示用
  String infoText = '';
  // 入力したメールアドレス・パスワード
  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 200,
                  child: Image.asset('assets/images/transparent_icon.png')),
              SizedBox(
                height: 100,
              ),
              Link(
                // 開きたいWebページのURLを指定
                uri: Uri.parse(
                    'https://spangled-crush-a71.notion.site/168ee57df1f645b58acb7780ba1ac016'),
                // targetについては後述
                target: LinkTarget.blank,
                builder: (BuildContext ctx, FollowLink? openLink) {
                  return TextButton(
                    onPressed: openLink,
                    child: const Text(
                      '利用規約',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      // minimumSize:
                      //     MaterialStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  );
                },
              ),
              Link(
                // 開きたいWebページのURLを指定
                uri: Uri.parse(
                    'https://spangled-crush-a71.notion.site/aa67e0fb55264eb3a0bd34425eac5d4e'),
                // targetについては後述
                target: LinkTarget.blank,
                builder: (BuildContext ctx, FollowLink? openLink) {
                  return TextButton(
                    onPressed: openLink,
                    child: const Text(
                      'プライバシーポリシー',
                      style: TextStyle(fontSize: 12),
                    ),
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.zero),
                      // minimumSize:
                      //     MaterialStateProperty.all(Size.zero),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  );
                },
              ),
              SizedBox(
                width: double.infinity,
                // ユーザー登録ボタン
                child: ElevatedButton(
                  child: const Text(
                    'ユーザー登録',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return SignUpPage();
                      }),
                    );
                  },
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                // ログイン登録ボタン
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Colors.white, //枠線の色
                    ),
                  ),
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) {
                        return const LogInPage();
                      }),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
