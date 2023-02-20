import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_achieve_app/screens/post/add_post_page_model.dart';

import '../../widget/text_form_field.dart';

class PostPage extends StatefulWidget {
  // 引数からユーザー情報を受け取る
  const PostPage(this.user, {super.key});
  // ユーザー情報
  final User user;

  @override
  // ignore: library_private_types_in_public_api
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  String nameText = '';
  String explanationText = '';
  final picker = ImagePicker();

  /// ユーザIDの取得
  final userID = FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddPostModel>(
      create: (_) => AddPostModel(
        widget.user,
      ),
      child: Scaffold(
        appBar: AppBar(title: const Text("投稿画面")),
        body: Consumer<AddPostModel>(builder: (context, model, child) {
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
                          ? const Text('画像はありません')
                          : Image.file(model.image!)),
                ),
                const SizedBox(
                  height: 30,
                ),
                FloatingActionButton(
                  onPressed: model.getImage,
                  child: const Icon(Icons.image),
                ),

                // 投稿メッセージ入力
                CommonTextFormField(
                  labelText: '題名',
                  maxLines: 1,
                  onChanged: (String value) {
                    setState(() {
                      nameText = value;
                    });
                  },
                ),
                CommonTextFormField(
                  labelText: '説明',
                  maxLines: 5,
                  onChanged: (String value) {
                    setState(() {
                      explanationText = value;
                    });
                  },
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        await model.postData(nameText, explanationText);
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                      },
                      child: const Text('投稿')),
                ),
              ],
            ),
          ));
        }),
      ),
    );
  }
}
