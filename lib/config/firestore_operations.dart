import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import '../model/user_model.dart';
import '../screens/manager_screen.dart';
import '../screens/profile_screen.dart';
import 'const.dart';
import '../screens/settings/edit_profile_screen.dart';

Future<void> uploadFirstImage(BuildContext context, List<String> userImageUrl,
    List<String> userImagePath) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  XFile? pickedImage;
  try {
    pickedImage = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 28, maxWidth: 1920);

    final String fileName = path.basename(pickedImage!.path);
    File imageFile = File(pickedImage.path);

    try {
      var task = storage.ref(fileName).putFile(imageFile);

      if (task == null) return;
      showAlertDialogLoading(context);

      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      userImagePath.add(fileName);
      userImageUrl.add(urlDownload);

      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final json = {
        'listImageUri': userImageUrl,
        'listImagePath': userImagePath
      };

      docUser.update(json).then((value) {
        Navigator.pop(context);
        Navigator.pushReplacement(
            context,
            FadeRouteAnimation(EditProfileScreen(
              isFirst: false,
              userModel: UserModel(
                  name: '',
                  uid: '',
                  myCity: '',
                  ageTime: Timestamp.now(),
                  userPol: '',
                  searchPol: '',
                  searchRangeStart: 0,
                  userImageUrl: [],
                  userImagePath: [],
                  imageBackground: '',
                  userInterests: [],
                  searchRangeEnd: 0,
                  ageInt: 0),
            )));
      });
    } on FirebaseException {
      Navigator.pop(context);
    }
  } catch (err) {
    // Navigator.pop(context);
  }
}

Future<void> uploadImage(
    BuildContext context, UserModel modelUser, bool isScreen) async {
  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  final picker = ImagePicker();
  XFile? pickedImage;
  try {
    pickedImage = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 24, maxWidth: 1920);

    final String fileName = path.basename(pickedImage!.path);
    File imageFile = File(pickedImage.path);

    try {
      var task = storage.ref(fileName).putFile(imageFile);

      if (task == null) return;

      showAlertDialogLoading(context);

      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      await storage.ref(modelUser.userImagePath[0]).delete();

      modelUser.userImageUrl.removeAt(0);
      modelUser.userImagePath.removeAt(0);

      listImagePath.add(fileName);
      listImageUri.add(urlDownload);

      listImagePath.addAll(modelUser.userImagePath);
      listImageUri.addAll(modelUser.userImageUrl);

      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final json = {
        'listImageUri': listImageUri,
        'listImagePath': listImagePath
      };

      docUser.update(json).then((value) {
        Navigator.pop(context);
        if (isScreen) {
          Navigator.pushReplacement(
              context,
              FadeRouteAnimation(EditProfileScreen(
                isFirst: false,
                userModel: UserModel(
                    name: '',
                    uid: '',
                    myCity: '',
                    ageTime: Timestamp.now(),
                    userPol: '',
                    searchPol: '',
                    searchRangeStart: 0,
                    userImageUrl: [],
                    userImagePath: [],
                    imageBackground: '',
                    userInterests: [],
                    searchRangeEnd: 0,
                    ageInt: 0),
              )));
        } else {
          Navigator.pushReplacement(
              context,
              FadeRouteAnimation(ManagerScreen(
                currentIndex: 3,
              )));
        }
      });
    } on FirebaseException {
      Navigator.pop(context);
    }
  } catch (err) {
    // Navigator.pop(context);
  }
}

Future<void> createSympathy(
    String idPartner, UserModel userModelCurrent) async {
  bool isSympathy = false;
  await FirebaseFirestore.instance
      .collection('User')
      .doc(idPartner)
      .collection('sympathy')
      .get()
      .then((querySnapshot) {
    for (var result in querySnapshot.docs) {
      Map<String, dynamic> data = result.data();
      if (userModelCurrent.uid == data['uid']) {
        isSympathy = true;
      }
    }

    if (!isSympathy) {
      final docUser = FirebaseFirestore.instance
          .collection("User")
          .doc(idPartner)
          .collection('sympathy')
          .doc();
      docUser.set({
        'id_doc': docUser.id,
        'uid': userModelCurrent.uid,
        'time': DateTime.now(),
        'image_uri': userModelCurrent.userImageUrl[0],
        'name': userModelCurrent.name,
        'age': userModelCurrent.ageInt,
        'city': userModelCurrent.myCity
      });
    }
  });
}

Future<void> deleteSympathy(String idDoc, idUser) async {
  final docUser = FirebaseFirestore.instance
      .collection("User")
      .doc(idUser)
      .collection('sympathy');
  docUser.doc(idDoc).delete().then((value) {});
}

Future<void> deleteSympathyPartner(String idPartner, String idUser) async {
  await FirebaseFirestore.instance
      .collection('User')
      .doc(idPartner)
      .collection('sympathy')
      .get()
      .then((querySnapshot) {
    for (var result in querySnapshot.docs) {
      Map<String, dynamic> data = result.data();

      if (idUser == data['uid']) {
        final docUser = FirebaseFirestore.instance
            .collection("User")
            .doc(idPartner)
            .collection('sympathy');
        docUser.doc(data['id_doc']).delete().then((value) {});
      }
    }
  });
}

Future<void> uploadImageAdd(BuildContext context, UserModel userModel) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  final picker = ImagePicker();
  XFile? pickedImage;
  try {
    pickedImage = await picker.pickImage(
        source: ImageSource.gallery, imageQuality: 24, maxWidth: 1920);

    final String fileName = path.basename(pickedImage!.path);
    File imageFile = File(pickedImage.path);

    try {
      var task = storage.ref(fileName).putFile(imageFile);

      if (task == null) return;
      showAlertDialogLoading(context);

      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();

      userModel.userImageUrl.add(urlDownload);
      userModel.userImagePath.add(fileName);

      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final json = {
        'listImageUri': userModel.userImageUrl,
        'listImagePath': userModel.userImagePath
      };

      docUser.update(json).then((value) {
        Navigator.pushReplacement(
            context,
            FadeRouteAnimation(ProfileScreen(
              userModel: UserModel(
                  name: '',
                  uid: '',
                  myCity: '',
                  ageTime: Timestamp.now(),
                  userPol: '',
                  searchPol: '',
                  searchRangeStart: 0,
                  userImageUrl: [],
                  userImagePath: [],
                  imageBackground: '',
                  userInterests: [],
                  searchRangeEnd: 0,
                  ageInt: 0),
              isBack: false,
              idUser: '',
              userModelCurrent: userModel,
            )));
      });
    } on FirebaseException {
      Navigator.pop(context);
    }
  } catch (err) {}
}

Future<void> imageRemove(
    int index, BuildContext context, UserModel userModel) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  try {
    try {
      showAlertDialogLoading(context);
      await storage.ref(userModel.userImagePath[index]).delete();

      userModel.userImageUrl.removeAt(index);
      userModel.userImagePath.removeAt(index);
      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final json = {
        'listImageUri': userModel.userImageUrl,
        'listImagePath': userModel.userImagePath
      };

      docUser.update(json).then((value) {
        Navigator.pushReplacement(
            context,
            FadeRouteAnimation(ProfileScreen(
              userModel: UserModel(
                  name: '',
                  uid: '',
                  myCity: '',
                  ageTime: Timestamp.now(),
                  userPol: '',
                  searchPol: '',
                  searchRangeStart: 0,
                  userImageUrl: [],
                  userImagePath: [],
                  imageBackground: '',
                  userInterests: [],
                  searchRangeEnd: 0,
                  ageInt: 0),
              isBack: false,
              idUser: '',
              userModelCurrent: userModel,
            )));
      });
    } on FirebaseException {
      Navigator.pop(context);
    }
  } catch (err) {}
}
