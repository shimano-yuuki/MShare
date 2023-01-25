// firestoreのドキュメントを扱うクラスBookを作る。
import 'package:cloud_firestore/cloud_firestore.dart';

class PostContent {
  // ドキュメントを扱うDocumentSnapshotを引数にしたコンストラクタを作る
  PostContent(DocumentSnapshot doc) {
    id = doc.id;
    //　ドキュメントの持っているフィールド'text'をこのPostContentのフィールドtextに代入
    titleText = doc['titleText'];
    url = doc['imgURL'];
    explanationText = doc['explanationText'];
  }
  // Bookで扱うフィールドを定義しておく。
  late String id;
  late String titleText;
  late String url;
  late String explanationText;
}
