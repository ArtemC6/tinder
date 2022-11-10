import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/config/firestore_operations.dart';
import 'package:tinder/screens/profile_screen.dart';

import '../config/const.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';

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
  double colorIndex = 0;
  int limit = 1;
  bool isLike = false, isLook = false, isLoading = false;
  List<UserModel> userModel = [];
  UserModel userModelCurrent;
  final scrollController = ScrollController();

  _HomeScreen(this.userModelCurrent);

  Future readFirebase() async {
    await FirebaseFirestore.instance
        .collection('User')
        // .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('myPol', isEqualTo: userModelCurrent.searchPol)
        // .where('ageInt', isGreaterThanOrEqualTo: userModelCurrent.searchRangeStart)
        // .where('ageInt', isLessThanOrEqualTo: userModelCurrent.searchRangeStart)
        .limit(limit)
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
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                                  totalNum: userModel.length + 1,
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
                                  cardBuilder: (context, index) {
                                    if (index < userModel.length) {
                                      return SizedBox(
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
                                      );
                                    } else {
                                      limit += 1;
                                      readFirebase();
                                      print('object');
                                      return Center(
                                        child:
                                            LoadingAnimationWidget.dotsTriangle(
                                          size: 44,
                                          color: Colors.blueAccent,
                                        ),
                                      );
                                    }
                                  },
                                  cardController: controllerCard =
                                      CardController(),
                                  swipeUpdateCallback:
                                      (DragUpdateDetails details,
                                          Alignment align) {
                                    if (align.x < 0) {
                                      int incline = int.parse(align.x
                                          .toStringAsFixed(1)
                                          .substring(1, 2));
                                      setState(() {
                                        if (incline <= 10 && incline > 3) {
                                          colorIndex =
                                              double.parse('0.$incline');
                                          isLook = true;
                                          isLike = true;
                                        } else {
                                          isLook = false;
                                        }
                                      });
                                    } else if (align.x > 0) {
                                      setState(() {
                                        if (align.y.toDouble() < 1 &&
                                            align.y.toDouble() > 0.3) {
                                          colorIndex = double.parse(
                                              '0.${align.x.toInt()}');
                                          isLook = true;
                                          isLike = false;
                                        } else {
                                          isLook = false;
                                        }
                                      });
                                    }
                                  },
                                  swipeCompleteCallback:
                                      (CardSwipeOrientation orientation,
                                          int index) async {
                                    print(index);

                                    if (index < userModel.length + 1) {
                                      print('Go');
                                    } else {
                                      print('No');
                                    }

                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.LEFT') {
                                      setState(() {
                                        isLook = false;
                                      });
                                      await CachedNetworkImage.evictFromCache(
                                          userModel[index].userImageUrl[0]);
                                    }

                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.RIGHT') {
                                      setState(() {
                                        isLook = false;
                                      });
                                      createSympathy(userModel[index].uid,
                                          userModelCurrent);
                                    }
                                  },
                                ),
                              ),
                              if (isLook && !isLike)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLook = false;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2.9,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: const AssetImage(
                                                'images/ic_heart.png'),
                                            colorFilter: ColorFilter.mode(
                                              Colors.white
                                                  .withOpacity(colorIndex),
                                              BlendMode.modulate,
                                            ))),
                                  ),
                                ),
                              if (isLook && isLike)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isLook = false;
                                    });
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: MediaQuery.of(context).size.width,
                                    height: MediaQuery.of(context).size.height /
                                        2.9,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: const AssetImage(
                                                'images/ic_remove.png'),
                                            colorFilter: ColorFilter.mode(
                                              Colors.white
                                                  .withOpacity(colorIndex),
                                              BlendMode.modulate,
                                            ))),
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
    return const loadingCustom();
  }
}
