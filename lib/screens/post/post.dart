import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  Post(DocumentSnapshot doc) {
    id = doc.id;
    titleText = doc['nameText'];
    url = doc['imgURL'];
    explanationText = doc['explanationText'];
  }
  late String id;
  late String titleText;
  late String url;
  late String explanationText;
}
