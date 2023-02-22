// firestoreのドキュメントを扱うクラスBookを作る。
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeContent {
  // ドキュメントを扱うDocumentSnapshotを引数にしたコンストラクタを作る
  HomeContent(DocumentSnapshot doc) {
    id = doc.id;
    //　ドキュメントの持っているフィールド'text'をこのPostContentのフィールドtextに代入
    titleText = doc['nameText'];
    url = doc['imgURL'];
    explanationText = doc['explanationText'];
  }
  // Bookで扱うフィールドを定義しておく。
  late String id;
  late String titleText;
  late String url;
  late String explanationText;
}

class HomeUserContent {
  HomeUserContent(DocumentSnapshot doc) {
    selfIntroduction = doc['selfIntroduction'];
    userName = doc['userName'];
  }
  late String selfIntroduction;
  late String userName;
}
