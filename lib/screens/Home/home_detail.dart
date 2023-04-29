import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

import 'home_content.dart';

class HomeDetail extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF262626),
      appBar: AppBar(
        backgroundColor: Color(0xFF262626),
        title: Text(imageTitle),
        actions: [
          Link(
            // 開きたいWebページのURLを指定
            uri: Uri.parse(
                'https://docs.google.com/forms/d/e/1FAIpQLSdxS56BChlXhdZNrq710DS7o2e_3j5eIDwNAaVYdgL6RXBmDQ/viewform'),
            // targetについては後述
            target: LinkTarget.blank,
            builder: (BuildContext ctx, FollowLink? openLink) {
              return IconButton(
                onPressed: openLink,
                icon: const Icon(Icons.flag),
              );
            },
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
                  imageTitle,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 14),
                    child: Image.network(
                      imageUrl,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 6),
                    child: Text(
                      imageExplanation,
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
