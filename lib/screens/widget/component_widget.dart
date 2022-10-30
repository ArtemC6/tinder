import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../data/const.dart';
import '../data/model/story_model.dart';
import '../data/model/user_model.dart';
import '../profile_screen.dart';
import '../settings/edit_profile_screen.dart';

class slideStory extends StatelessWidget {
  List<StoryModel> listStory = [];

  slideStory(this.listStory, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 22, top: 22, bottom: 22),
          child: RichText(
            text: TextSpan(
              text: 'Интересы',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: AnimationLimiter(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 1500),
                      horizontalOffset: 160,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 2000),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(left: 22, right: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (listStory.length > index)
                                  Card(
                                    shadowColor: Colors.white30,
                                    color: color_data_input,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        side: const BorderSide(
                                          width: 0.8,
                                          color: Colors.white54,
                                        )),
                                    elevation: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: SizedBox(
                                            height: 70,
                                            width: 70,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 1,
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                        imageUrl: listStory[index].uri,
                                        fit: BoxFit.cover,
                                        // height: 166,
                                        // width: MediaQuery.of(context).size.width
                                      ),
                                    ),
                                  ),
                                if (listStory.length > index)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4, top: 3),
                                    child: RichText(
                                      text: TextSpan(
                                        text: listStory[index].name,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: 10,
                                              letterSpacing: .9),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class slideStorySettings extends StatelessWidget {
  List<StoryModel> listStory = [];

  late UserModel userModel;

  slideStorySettings(this.listStory, this.userModel, {super.key});

  @override
  Widget build(BuildContext context) {
    // listInterests.clear();
    // Future<void> _imageRemove(int index) async {
    //   print(index);
    //   print(listStory.length);
    //   listStory.removeAt(index);
    //
    //   listStory.removeAt(index);
    //
    //   listStory.forEach((element) {
    //     listInterests.add(element.name);
    //   });
    //
    //   final docUser = FirebaseFirestore.instance
    //       .collection('User')
    //       .doc(FirebaseAuth.instance.currentUser?.uid);
    //
    //   final json = {'listInterests': listInterests};
    //
    //   docUser.update(json).then((value) {
    //     Navigator.pushReplacement(
    //         context, FadeRouteAnimation(const ProfileSettingScreen()));
    //   });
    // }

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 22, top: 22, bottom: 22),
          child: RichText(
            text: TextSpan(
              text: 'Интересы',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: AnimationLimiter(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 1500),
                      horizontalOffset: 160,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 2000),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                  shadowColor: Colors.white30,
                                  color: color_data_input,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: const BorderSide(
                                        width: 0.8,
                                        color: Colors.white30,
                                      )),
                                  elevation: 4,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      if (listStory.length > index)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    Center(
                                              child: SizedBox(
                                                height: 70,
                                                width: 70,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 1,
                                                  value: progress.progress,
                                                ),
                                              ),
                                            ),
                                            imageUrl: listStory[index].uri,
                                            fit: BoxFit.cover,
                                            // height: 166,
                                            // width: MediaQuery.of(context).size.width
                                          ),
                                        ),
                                      if (0 == index)
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    EditProfileScreen(
                                                  isFirst: false,
                                                  userModel: userModel,
                                                )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Image.asset(
                                              'images/edit_icon.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                        ),
                                      if (listStory.length > index &&
                                          index != 0)
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    EditProfileScreen(
                                                  isFirst: false,
                                                  userModel: userModel,
                                                )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(1),
                                            child: Image.asset(
                                              'images/ic_remove.png',
                                              height: 23,
                                              width: 23,
                                            ),
                                          ),
                                        ),
                                      if (listStory.length <= index &&
                                          listStory.length >= 1)
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    EditProfileScreen(
                                                  isFirst: false,
                                                  userModel: userModel,
                                                )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(6),
                                            child: Image.asset(
                                              'images/ic_add.png',
                                              height: 21,
                                              width: 21,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                if (listStory.length > index)
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4, top: 3),
                                    child: RichText(
                                      text: TextSpan(
                                        text: listStory[index].name,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: 10,
                                              letterSpacing: .9),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class photoProfile extends StatelessWidget {
  List<String> listPhoto = [];

  photoProfile(this.listPhoto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 26, top: 20, bottom: 18),
          child: RichText(
            text: TextSpan(
              text: 'Фото',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
            height: 380,
            child: AnimationLimiter(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 18, right: 18),
                crossAxisCount: 3,
                children: List.generate(
                  listPhoto.length,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 2200),
                      columnCount: 3,
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 2200),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5, left: 5, right: 5, top: 5),
                            child: Card(
                              shadowColor: Colors.white30,
                              color: color_data_input,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    width: 0.8,
                                    color: Colors.white38,
                                  )),
                              elevation: 6,
                              child: CachedNetworkImage(
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    color: color_data_input,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: SizedBox(
                                    height: 26,
                                    width: 26,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 0.8,
                                      value: progress.progress,
                                    ),
                                  ),
                                ),
                                imageUrl: listPhoto[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}

class photoProfileSettings extends StatelessWidget {
  UserModel userModel;

  photoProfileSettings(this.userModel, {super.key});

  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    Future<void> _uploadImage() async {
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

          final snapshot = await task.whenComplete(() {});
          final urlDownload = await snapshot.ref.getDownloadURL();

          await storage.ref(userModel.userImagePath[0]).delete();

          userModel.userImageUrl.removeAt(0);
          userModel.userImagePath.removeAt(0);

          listImagePath.add(fileName);
          listImageUri.add(urlDownload);

          listImagePath.addAll(userModel.userImagePath);
          listImageUri.addAll(userModel.userImageUrl);

          final docUser = FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser?.uid);

          final json = {
            'listImageUri': listImageUri,
            'listImagePath': listImagePath
          };

          docUser.update(json).then((value) {
            Navigator.pushReplacement(
                context, FadeRouteAnimation(ProfileScreen(userModel: UserModel(
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
                searchRangeEnd: 0, ageInt: 0), isBack: false, idUser: '',)));
          });
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

    Future<void> _uploadImageAdd() async {
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
                context, FadeRouteAnimation(ProfileScreen(userModel: UserModel(
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
                searchRangeEnd: 0, ageInt: 0), isBack: false, idUser: '',)));
          });
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

    Future<void> _imageRemove(int index) async {
      try {
        try {
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
                context, FadeRouteAnimation(ProfileScreen(userModel: UserModel(
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
                searchRangeEnd: 0, ageInt: 0), isBack: false, idUser: '',)));
          });
        } on FirebaseException catch (error) {
          if (kDebugMode) {
            print(error);
          }
        }
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 26, top: 20, bottom: 18),
          child: RichText(
            text: TextSpan(
              text: 'Фото',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
            height: 380,
            child: AnimationLimiter(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 18, right: 18, top: 0),
                crossAxisCount: 3,
                children: List.generate(
                  9,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 2200),
                      columnCount: 3,
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 2200),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5, left: 5, right: 5, top: 5),
                            child: Card(
                              shadowColor: Colors.white30,
                              color: color_data_input,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    width: 0.8,
                                    color: Colors.white38,
                                  )),
                              elevation: 6,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  if (userModel.userImageUrl.length > index)
                                    CachedNetworkImage(
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14)),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: SizedBox(
                                          height: 26,
                                          width: 26,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 0.8,
                                            value: progress.progress,
                                          ),
                                        ),
                                      ),
                                      imageUrl: userModel.userImageUrl[index],
                                    ),
                                  if (0 == index)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        _uploadImage();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Image.asset(
                                          'images/edit_icon.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                  if (userModel.userImageUrl.length > index &&
                                      index != 0)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        _imageRemove(index);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(2),
                                        child: Image.asset(
                                          'images/ic_remove.png',
                                          height: 25,
                                          width: 25,
                                        ),
                                      ),
                                    ),
                                  if (userModel.userImageUrl.length <= index &&
                                      userModel.userImageUrl.isNotEmpty)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        _uploadImageAdd();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6),
                                        child: Image.asset(
                                          'images/ic_add.png',
                                          height: 21,
                                          width: 21,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}

class buttonComponent extends StatelessWidget {
  String name;
  double width;
  VoidCallback voidCallback;

  buttonComponent(this.name, this.width, this.voidCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: voidCallback,
          child: Container(
            height: size.width / 8,
            width: size.width / width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Text(
              name,
              style: TextStyle(color: Colors.white.withOpacity(.8)),
            ),
          ),
        ),
      ),
    );
  }
}
