import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_achieve_app/app.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
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
              // メールアドレス入力
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  labelText: 'メールアドレス',
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
                onChanged: (String value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                style: TextStyle(
                  color: Colors.white,
                ),
                decoration: const InputDecoration(
                  labelText: 'パスワード',
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
                obscureText: true,
                onChanged: (String value) {
                  setState(() {
                    password = value;
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(8),
                // メッセージ表示
                child: Text(infoText),
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                // ログイン登録ボタン
                child: ElevatedButton(
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    try {
                      // メール/パスワードでログイン
                      final FirebaseAuth auth = FirebaseAuth.instance;
                      await auth.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                      );
                      // ログインに成功した場合
                      // チャット画面に遷移＋ログイン画面を破棄
                      // ignore: use_build_context_synchronously
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) {
                          return const MyApp();
                        }),
                      );
                    } catch (e) {
                      // ログインに失敗した場合
                      setState(() {
                        infoText = "ログインに失敗しました：${e.toString()}";
                      });
                    }
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
