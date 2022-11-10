import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/screens/settings/settiongs_profile_screen.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/interests_model.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';
import '../widget/button_widget.dart';
import '../widget/component_widget.dart';

class ProfileScreen extends StatefulWidget {
  UserModel userModelCurrent, userModel;
  bool isBack;
  String idUser;

  ProfileScreen(
      {super.key,
      required this.userModel,
      required this.isBack,
      required this.idUser,
      required this.userModelCurrent});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreen(userModel, isBack, idUser, userModelCurrent);
}

class _ProfileScreen extends State<ProfileScreen> {
  bool isLoading = false, isLike = false, isBack, isProprietor = false;
  UserModel userModel, userModelCurrent;
  String idUser;
  List<InterestsModel> listStory = [];
  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  _ProfileScreen(
      this.userModel, this.isBack, this.idUser, this.userModelCurrent);

  Future readFirebase() async {
    if (userModel.uid == '' && idUser != '') {
      readUserFirebase(idUser).then((user) {
        setState(() {
          userModel = UserModel(
              name: user.name,
              uid: user.uid,
              ageTime: user.ageTime,
              userPol: user.userPol,
              searchPol: user.searchPol,
              searchRangeStart: user.searchRangeStart,
              userInterests: user.userInterests,
              userImagePath: user.userImagePath,
              userImageUrl: user.userImageUrl,
              searchRangeEnd: user.searchRangeEnd,
              myCity: user.myCity,
              imageBackground: user.imageBackground,
              ageInt: user.ageInt,
              state: user.state);
          isLoading = true;
        });
      });
    }

    for (var elementMain in userModel.userInterests) {
      for (var element in listStoryMain) {
        if (userModel.userInterests.length != listStory.length) {
          listStory.add(element);
        }
        if (elementMain == element.name) {}
      }
    }

    setState(() {
      if (userModelCurrent.uid == userModel.uid) {
        isProprietor = true;
      } else {
        isProprietor = false;
      }
      putLike(userModelCurrent, userModel, false).then((value) {
        setState(() {
          isLike = !value;
        });
      });
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
          backgroundColor: color_black_88,
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
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 110,
                                  width: 110,
                                  child: Card(
                                    shadowColor: Colors.white38,
                                    color: color_black_88,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        side: const BorderSide(
                                          width: 0.8,
                                          color: Colors.white30,
                                        )),
                                    elevation: 4,
                                    child: CachedNetworkImage(
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
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
                                buttonLike(
                                    isLike: isLike,
                                    userModel: userModel,
                                    userModelCurrent: userModelCurrent),
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
                              if (isProprietor) buttonProfileMy(userModel),
                              if (!isProprietor)
                                buttonProfileUser(
                                  userModel,
                                  userModelCurrent,
                                ),
                              const SizedBox()
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            alignment: Alignment.topLeft,
                            decoration: const BoxDecoration(
                                color: color_black_88,
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
    return const loadingCustom();
  }
}
