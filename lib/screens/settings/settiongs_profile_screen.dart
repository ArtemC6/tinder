import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/data/widget/component_widget.dart';
import 'package:tinder/screens/settings/edit_profile_screen.dart';
import '../data/const.dart';
import '../data/model/story_model.dart';
import '../data/model/user_model.dart';
import '../profile_screen.dart';
import 'edit_image_profile_screen.dart';

class ProfileSettingScreen extends StatefulWidget {
  UserModel userModel;

  ProfileSettingScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreen(userModel);
}

class _ProfileSettingScreen extends State<ProfileSettingScreen> {
  bool isLoading = false, isLike = false;
  late UserModel userModel;
  List<StoryModel> listStory = [];
  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  _ProfileSettingScreen(this.userModel);

  // SlideFadeTransition(
  // delayStart: Duration(milliseconds: 800),
  // child: Text(
  // '0',
  // style: Theme.of(context).textTheme.headline4,
  // ),
  // ),

  Future<void> _uploadImage() async {
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
                isBack: true, idUser: '',
              )));
        });

        setState(() {});
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

  void readFirebase() async {
    // await FirebaseFirestore.instance
    //     .collection('User')
    //     .doc(FirebaseAuth.instance.currentUser?.uid)
    //     .get()
    //     .then((DocumentSnapshot documentSnapshot) {
    //   Map<String, dynamic> data =
    //       documentSnapshot.data() as Map<String, dynamic>;
    //
    //   setState(() {
    //     userModel = UserModel(
    //         name: data['name'],
    //         uid: data['uid'],
    //         age: data['myAge'],
    //         userPol: data['myPol'],
    //         searchPol: data['searchPol'],
    //         searchRangeStart: data['rangeStart'],
    //         userInterests: List<String>.from(data['listInterests']),
    //         userImagePath: List<String>.from(data['listImagePath']),
    //         userImageUrl: List<String>.from(data['listImageUri']),
    //         searchRangeEnd: data['rangeEnd'],
    //         myCity: data['myCity'],
    //         imageBackground: data['imageBackground']);
    //   });
    // });

    for (var elementMain in userModel.userInterests) {
      for (var element in listStoryMain) {
        if (elementMain == element.name) {
          if (userModel.userInterests.length != listStory.length) {
            listStory.add(element);
          }
        }
      }
    }

    FirebaseFirestore.instance
        .collection('Like')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        if (data[FirebaseAuth.instance.currentUser!.uid] == null) {
          setState(() {
            isLike = false;
          });
        } else {
          setState(() {
            isLike = true;
          });
        }
      });
    });

    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_data_input,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  height: 210,
                  width: size.width,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: userModel.imageBackground,
                  ),
                ),
              ),
              if (isLoading)
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                      color: Colors.white,
                    ),
                  ),
                ),
              if (isLoading)
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, right: 24),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            FadeRouteAnimation(EditImageProfileScreen(
                              bacImage: userModel.imageBackground,
                            )));
                      },
                      icon: Image.asset(
                        'images/ic_image.png',
                        height: 25,
                        width: 25,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              Container(
                margin: const EdgeInsets.only(top: 150),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      color: Colors.transparent,
                      // padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(alignment: Alignment.bottomRight, children: [
                            SizedBox(
                              height: 110,
                              width: 110,
                              child: Card(
                                shadowColor: Colors.white38,
                                color: color_data_input,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      width: 0.8,
                                      color: Colors.white30,
                                    )),
                                elevation: 4,
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 0.8,
                                        value: progress.progress,
                                      ),
                                    ),
                                  ),
                                  imageUrl: userModel.userImageUrl[0],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 110,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                _uploadImage();
                              },
                              child: Image.asset(
                                'images/edit_icon.png',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, left: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                      '${userModel.name}, ${userModel.ageInt}',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(1),
                                        fontSize: 16,
                                        letterSpacing: .8),
                                  ),
                                ),
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: userModel.myCity,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: 11,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(right: 20),
                          height: 40,
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(width: 0.7, color: Colors.white30),
                              gradient: const LinearGradient(colors: [
                                Colors.blueAccent,
                                Colors.purpleAccent
                              ]),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    FadeRouteAnimation(EditProfileScreen(
                                      isFirst: false,
                                      userModel: userModel,
                                    )));
                              },
                              style: ElevatedButton.styleFrom(
                                shadowColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              child: RichText(
                                text: TextSpan(
                                  text: 'Изменить',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                        letterSpacing: .1),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox()
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                          color: color_data_input,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 48),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: userModel.userImageUrl.length
                                            .toString(),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 14.5,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Фото',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontSize: 11,
                                              letterSpacing: .1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                  child: VerticalDivider(
                                    endIndent: 4,
                                    color: Colors.white.withOpacity(0.7),
                                    thickness: 1,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Like')
                                          .where(userModel.uid, isEqualTo: true)
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (snapshot.hasData) {
                                          return RichText(
                                            text: TextSpan(
                                              text: snapshot.data!.size
                                                  .toString()
                                                  .toString(),
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.9),
                                                    fontSize: 14.5,
                                                    letterSpacing: .5),
                                              ),
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Лайки',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontSize: 11,
                                              letterSpacing: .1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 24,
                                  child: VerticalDivider(
                                    endIndent: 4,
                                    color: Colors.white.withOpacity(0.7),
                                    thickness: 1,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: userModel.userInterests.length
                                            .toString(),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 14.5,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Итересы',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontSize: 11,
                                              letterSpacing: .1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          slideStorySettings(listStory, userModel),
                          photoProfileSettings(userModel),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
        backgroundColor: color_data_input,
        body: Center(
          child: LoadingAnimationWidget.dotsTriangle(
            size: 44,
            color: Colors.blueAccent,
          ),
        ));
  }
}
