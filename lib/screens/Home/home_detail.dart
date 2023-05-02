import 'package:flutter/material.dart';
import 'package:share_achieve_app/screens/Home/report.dart';

import 'home_content.dart';

class HomeDetail extends StatefulWidget {
  const HomeDetail({
    super.key,
    required this.imageUrl,
    required this.imageTitle,
    required this.imageExplanation,
    required this.homeContent,
  });

  final String imageUrl;
  final String imageTitle;
  final String imageExplanation;
  final HomeContent homeContent;
  @override
  State<HomeDetail> createState() => _HomeDetailState();
}

class _HomeDetailState extends State<HomeDetail> {
  @override
  bool buttonEnabled = true;
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Color(0xFF262626),
        title: Text(widget.imageTitle),
        actions: [
          IconButton(
            onPressed: buttonEnabled
                ? () async {
                    // ボタンが有効な場合の処理
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ReportPage(), // SecondPageは遷移先のクラス
                      ),
                    );
                    setState(() {
                      buttonEnabled = false; // ボタンを無効化する
                    });
                  }
                : null, // タンが無効な場合はnullを設定する
            icon: const Icon(Icons.flag),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.imageTitle,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Image.network(
                      widget.imageUrl,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 6),
                    child: Text(
                      widget.imageExplanation,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
