import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinder/screens/settings/settiongs_profile_screen.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/interests_model.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';
import '../widget/button_widget.dart';
import '../widget/component_widget.dart';
import '../widget/photo_widget.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModelCurrent, userModelPartner;
  final bool isBack;
  final String idUser;

  ProfileScreen(
      {super.key,
      required this.userModelPartner,
      required this.isBack,
      required this.idUser,
      required this.userModelCurrent});

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreen(userModelPartner, isBack, idUser, userModelCurrent);
}

class _ProfileScreen extends State<ProfileScreen> {
  bool isLoading = false, isLike = false, isBack, isProprietor = false;
  UserModel userModelPartner, userModelCurrent;
  final String idUser;
  List<InterestsModel> listStory = [];
  final FirebaseStorage storage = FirebaseStorage.instance;

  _ProfileScreen(
      this.userModelPartner, this.isBack, this.idUser, this.userModelCurrent);

  Future sortingList() async {
   await readInterestsFirebase().then((map) {
      for (var elementMain in userModelPartner.userInterests) {
        map.forEach((key, value) {
          if (elementMain == key) {
            if (userModelPartner.userInterests.length != listStory.length) {
              listStory.add(InterestsModel(name: key, id: '', uri: value));
            }
          }
        });
      }
    });
  }

  Future readFirebase() async {
    try {
      if (userModelPartner.uid == '' && idUser != '') {
        await readUserFirebase(idUser).then((user) {
          setState(() {
            userModelPartner = UserModel(
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
                state: user.state,
                token: user.token,
                notification: user.notification);
            isLoading = true;
          });
        });
        await sortingList();
      } else {
        await sortingList();
      }

      putLike(userModelCurrent, userModelPartner, false).then((value) {
        setState(() {
          if (userModelCurrent.uid == userModelPartner.uid) {
            isProprietor = true;
          } else {
            isProprietor = false;
          }
          isLike = !value;
          isLoading = true;
        });
      });
    } catch (error) {}
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
                          imageUrl: userModelPartner.imageBackground,
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
                                    userModel: userModelPartner,
                                    listInterests: listStory,
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
                                photoProfile(uri: userModelPartner.userImageUrl[0]),
                                buttonLike(
                                    isLike: isLike,
                                    userModelFriend: userModelPartner,
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
                                    animatedText(
                                        15.0,
                                        '${userModelPartner.name}, ${userModelPartner.ageInt}',
                                        Colors.white,
                                        600,
                                        1),
                                    animatedText(11.0, userModelPartner.myCity,
                                        Colors.white.withOpacity(.8), 600, 1),
                                  ],
                                ),
                              ),
                              if (isProprietor)
                                buttonProfileMy(userModelPartner),
                              if (!isProprietor)
                                buttonProfileUser(
                                  userModelCurrent,
                                  userModelPartner,
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
                                infoPanelWidget(userModel: userModelPartner),
                                slideInterests(listStory),
                                photoProfileGallery(
                                    userModelPartner.userImageUrl),
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
