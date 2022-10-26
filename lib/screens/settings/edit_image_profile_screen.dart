import 'dart:io';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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
import 'package:tinder/screens/settings/settiongs_profile_screen.dart';
import '../data/const.dart';
import '../data/model/story_model.dart';
import '../data/model/user_model.dart';

class EditImageProfileScreen extends StatefulWidget {
  UserModel userModel;

  EditImageProfileScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<EditImageProfileScreen> createState() => _EditImageProfileScreen(userModel);
}

class _EditImageProfileScreen extends State<EditImageProfileScreen> {
  bool isLoading = false;
  late UserModel userModel;
  List<String> listImageUri = [];

  _EditImageProfileScreen(UserModel userModel);

  // SlideFadeTransition(
  // delayStart: Duration(milliseconds: 800),
  // child: Text(
  // '0',
  // style: Theme.of(context).textTheme.headline4,
  // ),
  // ),

  Future<void> _uploadImage(String uri) async {
    try {
      try {
        final docUser = FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid);

        final json = {
          'imageBackground': uri,
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
        .collection('ImageProfile')
        .doc('Image')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        listImageUri = List<String>.from(documentSnapshot['listProfileImage']);
      });
    });

    setState(() {

      // listImageUri.forEach((element) {
      //   if(element == userModel.imageBackground) {
      //   print(element);
      //   }
      // });
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
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context, FadeRouteAnimation(const ProfileSettingScreen()));
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                      color: Colors.white,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(),
                      child: RichText(
                        text: TextSpan(
                          text: 'Галерея',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white.withOpacity(1),
                                fontSize: 18,
                                letterSpacing: .9),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 40),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: AnimationLimiter(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      crossAxisCount: 2,
                      children: List.generate(
                        listImageUri.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 1000),
                            columnCount: 2,
                            child: ScaleAnimation(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 4, left: 4, right: 4, top: 4),
                                      child: Card(
                                        shadowColor: Colors.white30,
                                        color: color_data_input,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            side: const BorderSide(
                                              width: 0.8,
                                              color: Colors.white38,
                                            )),
                                        elevation: 6,
                                        child: CachedNetworkImage(
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(14)),
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
                                              height: 26,
                                              width: 26,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 0.8,
                                                value: progress.progress,
                                              ),
                                            ),
                                          ),
                                          imageUrl: listImageUri[index],
                                        ),
                                      ),
                                    ),
                                    // if (0 == index)
                                    //   InkWell(
                                    //     splashColor: Colors.transparent,
                                    //     highlightColor: Colors.transparent,
                                    //     onTap: () {
                                    //       _uploadImage(listImageUri[index]);
                                    //     },
                                    //     child: Padding(
                                    //       padding: const EdgeInsets.all(4),
                                    //       child: Image.asset(
                                    //         'images/ic_save.png',
                                    //         height: 24,
                                    //         width: 24,
                                    //       ),
                                    //     ),
                                    //   ),
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          _uploadImage(listImageUri[index]);
                                        },
                                        child: Container(
                                          height: 23,
                                          width: 23,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.white38),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white12),
                                          // padding: const EdgeInsets.all(10),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
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
