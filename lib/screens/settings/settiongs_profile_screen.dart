import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' as path;
import '../data/const.dart';
import '../data/model/story_model.dart';
import '../data/model/user_model.dart';
import '../data/widget/component_widget.dart';
import 'edit_profile_screen.dart';

class ProfileSettingScreen extends StatefulWidget {
  const ProfileSettingScreen({Key? key}) : super(key: key);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreen();
}

class _ProfileSettingScreen extends State<ProfileSettingScreen> {
  bool isLoading = false;
  late UserModel userModel;
  List<StoryModel> listStory = [];
  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;

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
              context, FadeRouteAnimation(const ProfileSettingScreen()));
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
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        userModel = UserModel(
            name: data['name'],
            uid: data['uid'],
            age: data['myAge'],
            userPol: data['myPol'],
            searchPol: data['searchPol'],
            searchRangeStart: data['rangeStart'],
            userInterests: List<String>.from(data['listInterests']),
            userImagePath: List<String>.from(data['listImagePath']),
            userImageUrl: List<String>.from(data['listImageUri']),
            searchRangeEnd: data['rangeEnd'],
            myCity: data['myCity']);
      });
    });

    // print('--${userModel.userInterests.length}');

    for (var elementMain in userModel.userInterests) {
      for (var element in listStoryMain) {
        if (elementMain == element.name) {
          if (userModel.userInterests.length != listStory.length) {
            listStory.add(element);
          }
        }
      }
    }

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
              SizedBox(
                height: 250,
                width: size.width,
                child: Image.asset('images/ic_road.jpg', fit: BoxFit.cover),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 10, top: 30),
                child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
                  color: Colors.white,
                ),
              ),

              // InkWell(
              //   splashColor: Colors.transparent,
              //   highlightColor: Colors.transparent,
              //   onTap: () {
              //
              //   },
              //   child: Container(
              //     height: 40,
              //     width: 40,
              //     padding: const EdgeInsets.only(top: 40, right: 20),
              //     // transform: Matrix4.translationValues(66, -2, 0),
              //     alignment: Alignment.centerRight,
              //
              //     child: Image.asset(
              //       'images/ic_images.png',
              //       height: 25,
              //       width: 25,
              //     ),
              //   ),
              // ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    color: Colors.transparent,
                    padding: const EdgeInsets.only(top: 50),
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.bottomRight,
                          children: [
                            // if (userModel.userImageUrl.isEmpty)
                            //   const SizedBox(
                            //     height: 110,
                            //     width: 110,
                            //   ),
                            if (userModel.userImageUrl.isNotEmpty)
                              SizedBox(
                                height: 110,
                                width: 110,
                                child: Card(
                                  shadowColor: Colors.white30,
                                  color: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: const BorderSide(
                                        width: 0.8,
                                        color: Colors.white30,
                                      )),
                                  elevation: 4,
                                  child: CachedNetworkImage(
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
                                      child: SizedBox(
                                        height: 110,
                                        width: 110,
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
                                            Radius.circular(100)),
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
                              child: Padding(
                                padding: const EdgeInsets.all(6),
                                child: Image.asset(
                                  'images/edit_icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 10),
                          color: Colors.black12,
                          child: Column(
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                      '${userModel.name}, ${DateTime.now().year - getDataTimeDate(userModel.age).year}',
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
                                              fontSize: 11.5,
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
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  )
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 230),
                child: Column(
                  children: [
                    Container(
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
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 20, bottom: 20),
                            // transform: Matrix4.translationValues(0, -22, 0),
                            child: Row(
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(),

                                // LikeButton(
                                //   size: 30,
                                //   circleColor: const CircleColor(
                                //       start: Color(0xff00ddff),
                                //       end: Color(0xff0099cc)),
                                //   bubblesColor: BubblesColor(
                                //     dotPrimaryColor: Color(0xff33b5e5),
                                //     dotSecondaryColor: Color(0xff0099cc),
                                //   ),
                                //   likeBuilder: (bool isLiked) {
                                //     return Icon(
                                //       isLiked
                                //           ? Icons.favorite
                                //           : Icons.favorite_border_sharp,
                                //       color: isLiked ? Colors.red : Colors.grey,
                                //       size: 30,
                                //     );
                                //   },
                                //
                                // ),

                                SizedBox(
                                  height: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
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
                                            FadeRouteAnimation(
                                                EditProfileScreen(
                                              isFirst: false,
                                            )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
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
                              ],
                            ),
                          ),
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
                                    RichText(
                                      text: TextSpan(
                                        text: 23.toString(),
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
                          slideStorySettings(listStory),
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
