// firestoreのドキュメントを扱うクラスBookを作る。
import 'package:cloud_firestore/cloud_firestore.dart';

class PostContent {
  // ドキュメントを扱うDocumentSnapshotを引数にしたコンストラクタを作る
  PostContent(DocumentSnapshot doc) {
    //　ドキュメントの持っているフィールド'text'をこのPostContentのフィールドtextに代入
    text = doc['text'];
    // url = doc['imgURL'];
  }
  // Bookで扱うフィールドを定義しておく。
  // late String url;
  late String text;
}
