import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name;
  String uid;
  String userPol;
  String searchPol;
  String myCity;
  String imageBackground;
  num ageInt;
  num searchRangeStart;
  num searchRangeEnd;
  List<String> userInterests;
  List<String> userImageUrl;
  List<String> userImagePath;
  Timestamp ageTime;

  UserModel(
      {required this.name,
      required this.uid,
      required this.myCity,
      required this.ageInt,
      required this.ageTime,
      required this.userPol,
      required this.searchPol,
      required this.searchRangeStart,
      required this.userImageUrl,
      required this.userImagePath,
      required this.imageBackground,
      required this.userInterests,
      required this.searchRangeEnd});
}
