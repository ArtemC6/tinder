import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String uid;
  Timestamp age;
  String userPol;
  String searchPol;
  num searchRangeStart;
  num searchRangeEnd;
  List<String> userInterests;
  List<String> userImageUrl;
  List<String> userImagePath;

  UserModel(
      {required this.name,
      required this.uid,
      required this.age,
      required this.userPol,
      required this.searchPol,
      required this.searchRangeStart,
      required this.userImageUrl,
      required this.userImagePath,
      required this.userInterests,
      required this.searchRangeEnd});
}
