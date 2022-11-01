import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/settings/settiongs_profile_screen.dart';
import 'package:tinder/screens/widget/component_widget.dart';
import '../config/const.dart';
import '../model/interests_model.dart';
import '../model/user_model.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userModel;
  bool isBack;
  String idUser;

  ProfileScreen(
      {required this.userModel, required this.isBack, required this.idUser});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreen(userModel, isBack, idUser);
}

class _ProfileScreen extends State<ProfileScreen> {
  bool isLoading = false, isLike = false, isBack, isProprietor = false;
  late UserModel userModel;
  String idUser;
  List<InterestsModel> listStory = [];
  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  _ProfileScreen(this.userModel, this.isBack, this.idUser);

  Future<void> _putLike() async {
    final docUser = FirebaseFirestore.instance.collection('Like').doc();

    final json = {FirebaseAuth.instance.currentUser!.uid: true};
    if (isLike) {
      final docLike = FirebaseFirestore.instance.collection('Like');

      docLike.doc().delete();
    } else {
      docUser.set(json).then((value) {});
    }

    setState(() {});
  }

  Future<bool> changedata(status) async {
    setState(() {
      isLike = !isLike;
    });
    _putLike();
    return Future.value(!isLike);
  }

  void readFirebase() async {
    if (userModel.uid == '' && idUser == '') {
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
              ageInt: data['ageInt']);
        });
      });
    }

    if (userModel.uid == '' && idUser != '') {
      await FirebaseFirestore.instance
          .collection('User')
          .doc(idUser)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        Map<String, dynamic> data =
            documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
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
              ageInt: data['ageInt']);
        });
      });
    }

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
      if (FirebaseAuth.instance.currentUser?.uid == userModel.uid) {
        isProprietor = true;
      } else {
        isProprietor = false;
      }
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
              child: AnimationLimiter(
                  child: AnimationConfiguration.staggeredList(
            position: 1,
            delay: const Duration(milliseconds: 250),
            child: SlideAnimation(
              duration: const Duration(milliseconds: 2200),
              horizontalOffset: 250,
              curve: Curves.ease,
              child: FadeInAnimation(
                curve: Curves.easeOut,
                duration: const Duration(milliseconds: 3000),
                child: Stack(
                  children: [
                    Positioned(
                      child: SizedBox(
                        height: size.height * .28,
                        width: size.width,
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: userModel.imageBackground,
                        ),
                      ),
                    ),
                    if (isBack)
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
                    if (isProprietor)
                      Positioned(
                        child: Container(
                          padding: const EdgeInsets.only(top: 24, right: 24),
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  FadeRouteAnimation(ProfileSettingScreen(
                                    userModel: userModel,
                                  )));
                            },
                            icon: const Icon(Icons.settings, size: 20),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    Container(
                      margin: EdgeInsets.only(top: size.height * .20),
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
                                if (!isProprietor)
                                  Container(
                                    margin: const EdgeInsets.only(right: 30),
                                    child: LikeButton(
                                      isLiked: isLike,
                                      size: 30,
                                      circleColor: const CircleColor(
                                          start: Color(0xff00ddff),
                                          end: Color(0xff0099cc)),
                                      bubblesColor: const BubblesColor(
                                        dotPrimaryColor: Color(0xff33b5e5),
                                        dotSecondaryColor: Color(0xff0099cc),
                                      ),
                                      likeBuilder: (bool isLiked) {
                                        return Icon(
                                          isLiked
                                              ? Icons.favorite
                                              : Icons.favorite_border_sharp,
                                          color: isLiked
                                              ? Colors.red
                                              : Colors.grey,
                                          size: 30,
                                        );
                                      },
                                      onTap: (isLiked) {
                                        return changedata(
                                          isLiked,
                                        );
                                      },
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.only(top: 10, left: 14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            '${userModel.name}, ${userModel.ageInt}',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(1),
                                              fontSize: 16,
                                              letterSpacing: .8),
                                        ),
                                      ),
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: userModel.myCity,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
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
                              buttonProfile(
                                  userModel: userModel,
                                  isProprietor: isProprietor),
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
                                infoPanelWidget(userModel: userModel),
                                slideInterests(listStory),
                                photoProfile(userModel.userImageUrl),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ))));
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
