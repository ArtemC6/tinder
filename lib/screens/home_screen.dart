import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/config/firestore_operations.dart';
import 'package:tinder/screens/profile_screen.dart';
import '../config/const.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../model/user_model.dart';

class HomeScreen extends StatefulWidget {
  UserModel userModelCurrent;

  HomeScreen({Key? key, required this.userModelCurrent}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen(userModelCurrent);
}

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late CardController controllerCard;
  late AnimationController controllerHeart;
  late CurvedAnimation curveHeart, curveCancel;
  bool isLike = false, isLikeButton = false, isLook = false, isLoading = false;
  List<UserModel> userModel = [];
  UserModel userModelCurrent;

  _HomeScreen(this.userModelCurrent);

  Future readFirebase() async {
    await FirebaseFirestore.instance
        .collection('User')
        // .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('myPol', isEqualTo: userModelCurrent.searchPol)
        // .where('ageInt', isGreaterThanOrEqualTo: userModelCurrent.searchRangeStart)
        // .where('ageInt', isLessThanOrEqualTo: userModelCurrent.searchRangeStart)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (userModelCurrent.searchRangeStart <= data['ageInt'] &&
            userModelCurrent.searchRangeEnd >= data['ageInt']) {
          setState(() {
            userModel.add(UserModel(
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
                state: data['state']));
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
    super.initState();

    readFirebase();

    controllerHeart = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    curveHeart = CurvedAnimation(
        parent: controllerHeart, curve: Curves.fastLinearToSlowEaseIn);
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  void dispose() {
    controllerHeart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardSympathy(int index) {
      return Card(
        shadowColor: Colors.white30,
        color: color_black_88,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
            side: const BorderSide(
              width: 0.8,
              color: Colors.white38,
            )),
        elevation: 10,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.bottomLeft,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22),
              child: CachedNetworkImage(
                  useOldImageOnUrlChange: false,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 0.8,
                            value: progress.progress,
                          ),
                        ),
                      ),
                  imageUrl: userModel[index].userImageUrl[0],
                  fit: BoxFit.cover,
                  // height: 166,
                  width: MediaQuery.of(context).size.width),
            ),
            Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.only(bottom: 20, left: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      text:
                          '${userModel[index].name}, ${userModel[index].ageInt} \n${userModel[index].myCity}',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: .0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return Scaffold(
        backgroundColor: color_black_88,
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: AnimationLimiter(
                child: AnimationConfiguration.staggeredList(
                  position: 1,
                  delay: const Duration(milliseconds: 300),
                  child: SlideAnimation(
                    duration: const Duration(milliseconds: 2500),
                    verticalOffset: 250,
                    curve: Curves.ease,
                    child: FadeInAnimation(
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 3500),
                      child: Column(
                        children: <Widget>[
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 10),
                                height:
                                    MediaQuery.of(context).size.height / 1.4,
                                child: TinderSwapCard(
                                  animDuration: 850,
                                  swipeUp: false,
                                  swipeDown: false,
                                  orientation: AmassOrientation.BOTTOM,
                                  allowVerticalMovement: true,
                                  totalNum: userModel.length,
                                  stackNum: 3,
                                  swipeEdge: 3.0,
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 1,
                                  maxHeight:
                                      MediaQuery.of(context).size.width / 1,
                                  minWidth:
                                      MediaQuery.of(context).size.width / 1.1,
                                  minHeight:
                                      MediaQuery.of(context).size.width / 1.1,
                                  cardBuilder: (context, index) => SizedBox(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfileScreen(
                                                      userModel:
                                                          userModel[index],
                                                      isBack: true,
                                                      idUser: '',
                                                      userModelCurrent:
                                                          userModelCurrent,
                                                    )));
                                      },
                                      child: cardSympathy(index),
                                    ),
                                  ),
                                  cardController: controllerCard =
                                      CardController(),
                                  swipeUpdateCallback:
                                      (DragUpdateDetails details,
                                          Alignment align) {
                                    if (align.x < 0) {
                                      setState(() {
                                        isLike = false;
                                        isLook = true;
                                      });
                                      controllerHeart.forward();
                                      Future.delayed(
                                          const Duration(milliseconds: 400),
                                          () {
                                        controllerHeart.reset();
                                        setState(() {
                                          isLook = false;
                                        });
                                      });
                                    } else if (align.x > 0) {
                                      setState(() {
                                        isLike = true;
                                        isLook = true;
                                      });
                                      controllerHeart.forward();
                                      Future.delayed(
                                          const Duration(milliseconds: 600),
                                          () {
                                        controllerHeart.reset();
                                        setState(() {
                                          isLook = false;
                                        });
                                      });
                                    }
                                  },
                                  swipeCompleteCallback:
                                      (CardSwipeOrientation orientation,
                                          int index) async {
                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.LEFT') {
                                      await CachedNetworkImage.evictFromCache(
                                          userModel[index].userImageUrl[0]);
                                      // setState(() {
                                      //   isLike = false;
                                      //   isLook = true;
                                      // });
                                      // controllerHeart.forward();
                                      // Future.delayed(
                                      //     const Duration(milliseconds: 600),
                                      //     () {
                                      //   controllerHeart.reset();
                                      //   setState(() {
                                      //     isLook = false;
                                      //     // isLikeButton = false;
                                      //   });
                                      // });
                                    }

                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.RIGHT') {
                                      createSympathy(userModel[index].uid,
                                          userModelCurrent);
                                      // await CachedNetworkImage.evictFromCache(userModel[index].userImageUrl[0]);

                                      // setState(() {
                                      //   isLike = true;
                                      //   isLook = true;
                                      // });
                                      // controllerHeart.forward();
                                      // Future.delayed(
                                      //     const Duration(milliseconds: 600),
                                      //     () {
                                      //   controllerHeart.reset();
                                      //   setState(() {
                                      //     isLook = false;
                                      //   });
                                      // });
                                    }

                                    /// Get orientation & index of swiped card!
                                  },
                                ),
                              ),
                              if (isLook)
                                if (isLike)
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2.9,
                                    child: FadeTransition(
                                        opacity: controllerHeart,
                                        child: Image.asset(
                                            'images/ic_heart.png',
                                            fit: BoxFit.contain)),
                                  ),
                              if (isLook)
                                if (!isLike)
                                  Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2.9,
                                    child: FadeTransition(
                                      opacity: curveHeart,
                                      child: Image.asset('images/ic_remove.png',
                                          fit: BoxFit.contain),
                                    ),
                                  ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  controllerCard.triggerLeft();
                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: AvatarGlow(
                                    glowColor: Colors.blueAccent,
                                    endRadius: 60,
                                    repeatPauseDuration:
                                        const Duration(milliseconds: 1500),
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    repeat: true,
                                    showTwoGlows: true,
                                    curve: Curves.easeOutQuad,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(99)),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.black,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                highlightColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                onTap: () {
                                  controllerCard.triggerRight();
                                },
                                child: SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height / 5,
                                  width: MediaQuery.of(context).size.width / 2,
                                  child: AvatarGlow(
                                    glowColor: Colors.blueAccent,
                                    endRadius: 60,
                                    duration:
                                        const Duration(milliseconds: 2000),
                                    repeat: true,
                                    showTwoGlows: true,
                                    curve: Curves.easeOutQuad,
                                    child: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(99)),
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
      );
    }
    return Scaffold(
      backgroundColor: color_black_88,
      body: Center(
        child: LoadingAnimationWidget.dotsTriangle(
          size: 44,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
