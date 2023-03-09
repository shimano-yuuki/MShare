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
    selfIntroduction = doc['selfIntroduction'];
    userName = doc['userName'];
    userImgURL = doc['userImgURL'];
    uid = doc['userId'];
  }
  // Bookで扱うフィールドを定義しておく。
  late String id;
  late String titleText;
  late String url;
  late String explanationText;
  late String selfIntroduction;
  late String userName;
  late String userImgURL;
  late String uid;
}
