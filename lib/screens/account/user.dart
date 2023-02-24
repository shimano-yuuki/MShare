import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  // ドキュメントを扱うDocumentSnapshotを引数にしたコンストラクタを作る
  User(DocumentSnapshot doc) {
    selfIntroduction = doc['selfIntroduction'];
    userName = doc['userName'];
  }
  late String selfIntroduction;
  late String userName;
}
