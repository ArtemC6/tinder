import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../model/user_model.dart';
import '../screens/manager_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings/edit_profile_screen.dart';
import '../widget/dialog_widget.dart';
import 'const.dart';

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
                  ageInt: 0,
                  state: ''),
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
    BuildContext context, UserModel userModelCurrent, bool isScreen) async {
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

      await storage.ref(userModelCurrent.userImagePath[0]).delete();

      userModelCurrent.userImageUrl.removeAt(0);
      userModelCurrent.userImagePath.removeAt(0);

      listImagePath.add(fileName);
      listImageUri.add(urlDownload);

      listImagePath.addAll(userModelCurrent.userImagePath);
      listImageUri.addAll(userModelCurrent.userImageUrl);

      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(userModelCurrent.uid);

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
                    ageInt: 0,
                    state: ''),
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
  try {
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
  } on FirebaseException {}
}

Future<void> deleteSympathy(String idDoc, idUser) async {
  try {
    final docUser = FirebaseFirestore.instance
        .collection("User")
        .doc(idUser)
        .collection('sympathy');
    docUser.doc(idDoc).delete().then((value) {});
  } on FirebaseException {}
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

Future<void> uploadImageAdd(
    BuildContext context, UserModel userModelCurrent) async {
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

      userModelCurrent.userImageUrl.add(urlDownload);
      userModelCurrent.userImagePath.add(fileName);

      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final json = {
        'listImageUri': userModelCurrent.userImageUrl,
        'listImagePath': userModelCurrent.userImagePath
      };

      docUser.update(json).then((value) {
        Navigator.pushReplacement(
            context,
            FadeRouteAnimation(ProfileScreen(
              userModelPartner: userModelCurrent,
              isBack: false,
              idUser: '',
              userModelCurrent: userModelCurrent,
            )));
      });
    } on FirebaseException {
      Navigator.pop(context);
    }
  } catch (err) {}
}

Future<void> imageRemove(
    int index, BuildContext context, UserModel userModelCurrent) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  try {
    try {
      showAlertDialogLoading(context);
      await storage.ref(userModelCurrent.userImagePath[index]).delete();

      userModelCurrent.userImageUrl.removeAt(index);
      userModelCurrent.userImagePath.removeAt(index);
      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final json = {
        'listImageUri': userModelCurrent.userImageUrl,
        'listImagePath': userModelCurrent.userImagePath
      };

      docUser.update(json).then((value) {
        Navigator.pushReplacement(
            context,
            FadeRouteAnimation(ProfileScreen(
              userModelPartner: userModelCurrent,
              isBack: false,
              idUser: '',
              userModelCurrent: userModelCurrent,
            )));
      });
    } on FirebaseException {
      Navigator.pop(context);
    }
  } catch (err) {}
}

Future<void> setStateFirebase(String state) async {
  try {
    final docUser = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final json = {
      'state': state,
      if (state == 'offline') 'lastDateOnline': DateTime.now(),
    };
    await docUser.update(json);
  } on FirebaseException {}
}

Future deleteChatFirebase(bool isDeletePartner, String friendId, bool isBack,
    BuildContext context) async {
  if (isDeletePartner) {
    FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('messages')
        .doc(friendId)
        .delete()
        .then((value) async {
      if (isBack) {
        Navigator.pop(context);
      }
      var collection = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('messages')
          .doc(friendId)
          .collection('chats');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    }).then((value) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(friendId)
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();
    }).then((value) async {
      var collection = FirebaseFirestore.instance
          .collection('User')
          .doc(friendId)
          .collection('messages')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('chats');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    });
  } else {
    FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .collection('messages')
        .doc(friendId)
        .delete()
        .then((value) async {
      Navigator.pop(context);

      var collection = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('messages')
          .doc(friendId)
          .collection('chats');
      var snapshots = await collection.get();
      for (var doc in snapshots.docs) {
        await doc.reference.delete();
      }
    });
  }
}

Future<void> uploadImagePhotoProfile(String uri, BuildContext context) async {
  try {
    final docUser = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final json = {
      'imageBackground': uri,
    };

    docUser.update(json).then((value) {
      Navigator.pushReplacement(
          context,
          FadeRouteAnimation(
            ManagerScreen(currentIndex: 3),
          ));
    });
  } on FirebaseException {}
}

Future<UserModel> readUserFirebase([String? idUser]) async {
  UserModel userModel = UserModel(
      name: '',
      uid: '',
      state: '',
      myCity: '',
      ageInt: 0,
      ageTime: Timestamp.now(),
      userPol: '',
      searchPol: '',
      searchRangeStart: 0,
      userImageUrl: [],
      userImagePath: [],
      imageBackground: '',
      userInterests: [],
      searchRangeEnd: 0);
  try {
    await FirebaseFirestore.instance
        .collection('User')
        // .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .doc(idUser ?? FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      userModel = UserModel(
          name: data['name'],
          uid: data['uid'],
          ageTime: data['ageTime'],
          userPol: data['myPol'],
          searchPol: data['searchPol'],
          searchRangeStart: data['rangeStart'],
          userInterests: List<String>.from(data['listInterests']),
          userImagePath: List<String>.from(data['listImagePath']),
          userImageUrl: List<String>.from(data['listImageUri']),
          searchRangeEnd: data['rangeEnd'],
          myCity: data['myCity'],
          imageBackground: data['imageBackground'],
          ageInt: data['ageInt'],
          state: data['state']);
    });
  } on FirebaseException {}
  return userModel;
}

Future<List<String>> readDislikeFirebase(String idUser) async {
 List<String> listDislike = [];
  try {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(idUser)
        .collection('dislike')
        .get()
        .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
            listDislike.add(result.id);
        }
    });
  } on FirebaseException {}
  return listDislike;
}
Future<List<String>> readLikeFirebase(String idUser) async {
 List<String> listDislike = [];
  try {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(idUser)
        .collection('likes')
        .get()
        .then((querySnapshot) {
        for (var result in querySnapshot.docs) {
            listDislike.add(result.id);
        }
    });
  } on FirebaseException {}
  return listDislike;
}

Future deleteDislike(String idUser) async {
  try {
    var collection = FirebaseFirestore.instance
        .collection('User')
        .doc(idUser)
        .collection('dislike');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  } on FirebaseException {}
}

Future deleteMessageFirebase(
    String myId,
    String friendId,
    String deleteMessageIdMy,
    bool isDeletePartner,
    String deleteMessageIdPartner) async {
  try {
    FirebaseFirestore.instance
        .collection('User')
        .doc(myId)
        .collection('messages')
        .doc(friendId)
        .collection('chats')
        .doc(deleteMessageIdMy)
        .delete()
        .then((value) {
      if (isDeletePartner) {
        FirebaseFirestore.instance
            .collection('User')
            .doc(friendId)
            .collection('messages')
            .doc(myId)
            .collection('chats')
            .doc(deleteMessageIdPartner)
            .delete();
      }
    });
  } on FirebaseException {}
}

Future<bool> putLike(
    UserModel userModelCurrent, UserModel userModel, bool isLikeOnTap) async {
  bool isLike = false;
  try {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(userModel.uid)
        .collection('likes')
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        if (userModelCurrent.uid == result.id) {
          isLike = true;
        }
      }

      if (isLikeOnTap) {
        if (!isLike) {
          FirebaseFirestore.instance
              .collection("User")
              .doc(userModel.uid)
              .collection('likes')
              .doc(userModelCurrent.uid)
              .set({});
        } else {
          FirebaseFirestore.instance
              .collection("User")
              .doc(userModel.uid)
              .collection('likes')
              .doc(userModelCurrent.uid)
              .delete();
        }
      }
    });
  } on FirebaseException {}

  return Future.value(!isLike);
}

Future putUserWrites(
  String currentId,
  String friendId,
) async {
  try {
    print('object +');
    FirebaseFirestore.instance
        .collection("User")
        .doc(friendId)
        .collection('messages')
        .doc(currentId)
        .update({'writeLastData': DateTime.now()});
  } on FirebaseException {}
}

Future createDisLike(UserModel userModelCurrent, UserModel userModel) async {
  try {
    FirebaseFirestore.instance
        .collection("User")
        .doc(userModelCurrent.uid)
        .collection('dislike')
        .doc(userModel.uid)
        .set({});
  } on FirebaseException {}
}
