import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../model/user_model.dart';
import '../screens/manager_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/settings/edit_profile_screen.dart';
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
              userModelPartner: UserModel(
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
              userModelPartner: UserModel(
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

Future<void> setStateFirebase(String state) async {
  try {
    final docUser = FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final json = {
      'state': state,
    };
    docUser.update(json);
  } on FirebaseException {}
}

showAlertDialogDeleteChat(
    BuildContext context, String friendId, String friendName, bool isBack) {
  bool isDelete = false;
  Widget cancelButton = TextButton(
    child: const Text("Отмена"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Удалить"),
    onPressed: () {
      if (isBack) {
        Navigator.pop(context);
      }

      if (isDelete) {
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
    },
  );

  showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: color_black_88,
              title: RichText(
                text: TextSpan(
                  text: 'Удалить чат',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 17, letterSpacing: .8),
                  ),
                ),
              ),
              content: CheckboxListTile(
                activeColor: Colors.blue,
                title: RichText(
                  text: TextSpan(
                    text: "Также удалить для $friendName",
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 12, letterSpacing: .3),
                    ),
                  ),
                ),
                value: isDelete,
                onChanged: (newValue) {
                  setState(() {
                    isDelete = !isDelete;
                  });
                },
                controlAffinity:
                    ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              actions: <Widget>[
                cancelButton,
                continueButton,
              ],
            );
          },
        );
      });
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

showAlertDialogDeleteMessage(
    BuildContext context, AsyncSnapshot snapshot, int index, String friendId) {
  Widget cancelButton = TextButton(
    child: const Text("Отмена"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: const Text("Удалить"),
    onPressed: () {
      Navigator.pop(context);
      FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('messages')
          .doc(friendId)
          .collection('chats')
          .doc(snapshot.data.docs[index]['idDoc'])
          .delete()
          .then((value) {
        FirebaseFirestore.instance
            .collection('users')
            .doc(friendId)
            .collection('messages')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .collection('chats')
            .doc(snapshot.data.docs[index]['idDoc'])
            .delete();
      });
    },
  );

  AlertDialog alert = AlertDialog(
    backgroundColor: color_black_88,
    title: RichText(
      text: TextSpan(
        text: 'Удалить сообщение',
        style: GoogleFonts.lato(
          textStyle: const TextStyle(
              color: Colors.white, fontSize: 17, letterSpacing: .4),
        ),
      ),
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
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

Future createDisLike(UserModel userModelCurrent, UserModel userModel) async {
  try {
    FirebaseFirestore.instance
        .collection("User")
        .doc(userModelCurrent.uid)
        .collection('dislike')
        .doc(userModel.name)
        .set({});

    // FirebaseFirestore.instance
    //     .collection("User")
    //     .doc(userModel.uid)
    //     .collection('likes')
    //     .doc(userModelCurrent.uid)
    //     .delete();
  } on FirebaseException {}
}
