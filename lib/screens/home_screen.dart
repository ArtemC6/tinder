import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/config/firestore_operations.dart';
import 'package:tinder/screens/profile_screen.dart';

import '../config/const.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';
import '../widget/card_widget.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModelCurrent;

  const HomeScreen({Key? key, required this.userModelCurrent})
      : super(key: key);

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
  List<UserModel> userModelPartner = [];
  List<String> listDisLike = [];
  final UserModel userModelCurrent;
  final scrollController = ScrollController();

  _HomeScreen(this.userModelCurrent);

  Future readFirebase() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(userModelCurrent.uid)
        .collection('dislike')
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        setState(() {
          listDisLike.add(result.id);
        });
      }
    });

    await FirebaseFirestore.instance
        .collection('User')
        // .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('myPol', isEqualTo: userModelCurrent.searchPol)
        // .where('ageInt', isGreaterThanOrEqualTo: userModelCurrent.searchRangeStart)
        // .where('ageInt', isLessThanOrEqualTo: userModelCurrent.searchRangeStart)
        // .limit(limit)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (userModelCurrent.searchRangeStart <= data['ageInt'] &&
            userModelCurrent.searchRangeEnd >= data['ageInt']) {



          bool isUser = true;

          Future.forEach(listDisLike, (element) {
            // print(
            //     'my: $element:${data['name']} ${element !=
            //         data['name']}');
            //
            // if (element == data['name']) {
            //   isUser = true;
            //   print('');
            //   // print('true');
            // } else {
            //   isUser = false;
            //   // print('false');
            //
            // }

            // return 'sdfdsf';


          }).then((value) {

            print(isUser);
            if(isUser) {
              userModelPartner.add(UserModel(
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
              setState(() {});
            }
          });

          //  Future.delayed(const Duration(milliseconds: 100), () async {
          //   bool isUser = true;
          //   for (String dislike in listDisLike) {
          //     print(
          //         'my: $dislike:${data['name']} ${dislike !=
          //             data['name']}');
          //
          //     if (dislike != data['name']) {
          //       isUser = false;
          //     } else {
          //       isUser = true;
          //     }
          //   }
          //
          //   return isUser;
          // }).then((value) {
          //    print('');
          //    print('Ready: $value');
          //   if (value) {
          //     userModelPartner.add(UserModel(
          //         name: data['name'],
          //         uid: data['uid'],
          //         ageTime: data['ageTime'],
          //         userPol: data['myPol'],
          //         searchPol: data['searchPol'],
          //         searchRangeStart: data['rangeStart'],
          //         userInterests: List<String>.from(data['listInterests']),
          //         userImagePath: List<String>.from(data['listImagePath']),
          //         userImageUrl: List<String>.from(data['listImageUri']),
          //         searchRangeEnd: data['rangeEnd'],
          //         myCity: data['myCity'],
          //         imageBackground: data['imageBackground'],
          //         ageInt: data['ageInt'],
          //         state: data['state']));
          //     setState(() {});
          //   }
          // });
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
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;
    Widget cardPartner(int index) {
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
                  progressIndicatorBuilder: (context, url, progress) =>
                      Center(child: cardLoading(size, 22)),
                  imageUrl: userModelPartner[index].userImageUrl[0],
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
                          '${userModelPartner[index].name}, ${userModelPartner[index].ageInt} \n${userModelPartner[index].myCity}',
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
                                  totalNum: userModelPartner.length + 1,
                                  stackNum: 3,
                                  swipeEdge: 3.0,
                                  maxWidth: width / 1,
                                  maxHeight: width / 1,
                                  minWidth: width / 1.1,
                                  minHeight: width / 1.1,
                                  cardBuilder: (context, index) {
                                    if (index < userModelPartner.length) {
                                      return SizedBox(
                                        child: InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    ProfileScreen(
                                                  userModelPartner:
                                                      userModelPartner[index],
                                                  isBack: true,
                                                  idUser: '',
                                                  userModelCurrent:
                                                      userModelCurrent,
                                                )));
                                          },
                                          child: cardPartner(index),
                                        ),
                                      );
                                    } else {
                                      // limit += 1;
                                      // readFirebase();
                                      return cardLoading(size, 22);
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
                                    if (index < userModelPartner.length + 1) {
                                    } else {}

                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.LEFT') {
                                      setState(() {
                                        isLook = false;
                                      });
                                      CachedNetworkImage.evictFromCache(
                                          userModelPartner[index]
                                              .userImageUrl[0]);
                                      createDisLike(userModelCurrent,
                                          userModelPartner[index]);
                                    }

                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.RIGHT') {
                                      setState(() {
                                        isLook = false;
                                      });
                                      createSympathy(
                                          userModelPartner[index].uid,
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
                                    width: width,
                                    height: height / 2.9,
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
                                    width: width,
                                    height: height / 2.9,
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
                                  height: height / 5,
                                  width: width / 2,
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
                                  height: height / 5,
                                  width: width / 2,
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
