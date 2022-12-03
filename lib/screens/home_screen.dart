import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:tinder/config/firestore_operations.dart';
import 'package:tinder/screens/profile_screen.dart';

import '../config/const.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';
import '../widget/button_widget.dart';
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
  double colorIndex = 0;
  int limit = 0;
  bool isLike = false,
      isLook = false,
      isLoading = false,
      isReadDislike = false,
      isWrite = false;
  List<UserModel> userModelPartner = [];
  List<String> listDisLike = [];
  final UserModel userModelCurrent;
  final scrollController = ScrollController();

  _HomeScreen(this.userModelCurrent);

  Future readFirebase(
      int setLimit, bool isDeleteDislike, bool isReadDislike) async {
    // userModelPartner.clear();
    limit += setLimit;
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        isWrite = true;
      });
    });

    // userModelPartner.clear();

    // for (var elementMain in listDisLike) {
    //   for (var element in userModelPartner) {
    //     if (elementMain == element.uid) {
    //       print(element.name);
    //     }
    //   }
    // }

    if (isReadDislike) {
      await readDislikeFirebase(userModelCurrent.uid).then((list) {
        listDisLike.addAll(list);
      });
    }

    FirebaseFirestore.instance
        .collection('User')
        .where('myPol', isEqualTo: userModelCurrent.searchPol)
        // .where('myCity', isEqualTo: userModelCurrent.myCity)
        .limit(limit)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        if (userModelCurrent.searchRangeStart <= data['ageInt'] &&
            userModelCurrent.searchRangeEnd >= data['ageInt']) {
          bool isDislike = true;
          Future.forEach(listDisLike, (idUser) {
            if (idUser == data['uid']) {
              isDislike = false;
            }
          }).then((value) async {
            if (isDislike) {
              userModelPartner.add(UserModel(
                  name: data['name'],
                  uid: data['uid'],
                  ageTime: Timestamp.now(),
                  userPol: data['myPol'],
                  searchPol: '',
                  searchRangeStart: 0,
                  userInterests: List<String>.from(data['listInterests']),
                  userImagePath: [],
                  userImageUrl: List<String>.from(data['listImageUri']),
                  searchRangeEnd: 0,
                  myCity: data['myCity'],
                  imageBackground: data['imageBackground'],
                  ageInt: data['ageInt'],
                  state: data['state'],
                  token: data['token'],
                  notification: data['notification']));
              setState(() {});
            } else {
              if (isDeleteDislike) {
                setState(() {
                  listDisLike.clear();
                });
                deleteDislike(userModelCurrent.uid);
              }
            }
          });
        }
      }
    }).then((value) {
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readFirebase(12, false, true);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var size = MediaQuery.of(context).size;

    if (isLook) {
      Future.delayed(const Duration(milliseconds: 5000), () {
        setState(() {
          isLook = false;
        });
      });
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
                delay: const Duration(milliseconds: 200),
                child: SlideAnimation(
                  duration: const Duration(milliseconds: 2000),
                  verticalOffset: 250,
                  curve: Curves.ease,
                  child: FadeInAnimation(
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 3700),
                    child: Column(
                      children: <Widget>[
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              height: MediaQuery.of(context).size.height / 1.4,
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
                                              FadeRouteAnimation(ProfileScreen(
                                                userModelPartner:
                                                    userModelPartner[index],
                                                isBack: true,
                                                idUser: '',
                                                userModelCurrent:
                                                    userModelCurrent,
                                              )));
                                        },
                                        child: cardPartner(index,
                                            userModelPartner, size, context),
                                      ),
                                    );
                                  } else {
                                    if (isWrite) {
                                      // print('index: $index list:${userModelPartner.length}');
                                      isWrite = false;
                                      readFirebase(3, true, false);
                                    }

                                    return cardLoading(size, 22);
                                  }
                                },
                                cardController: controllerCard =
                                    CardController(),
                                swipeUpdateCallback: (DragUpdateDetails details,
                                    Alignment align) {
                                  setState(() {
                                    if (align.x < 0) {
                                      int incline = int.parse(align.x
                                          .toStringAsFixed(1)
                                          .substring(1, 2));

                                      if (incline <= 10 && incline > 3) {
                                        colorIndex = double.parse('0.$incline');
                                        isLike = true;
                                        isLook = true;
                                      } else {
                                        isLook = false;
                                      }
                                    } else if (align.x > 0) {
                                      if (align.y.toDouble() < 1 &&
                                          align.y.toDouble() > 0.3) {
                                          colorIndex = double.parse(
                                              '0.${align.x.toInt()}');
                                          isLook = true;
                                          isLike = false;
                                        } else {
                                          isLook = false;
                                        }
                                      }
                                    });
                                  },
                                  swipeCompleteCallback:
                                      (CardSwipeOrientation orientation,
                                          int index) async {
                                        setState(() async {

                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.LEFT') {
                                      isLook = false;
                                      listDisLike
                                          .add(userModelPartner[index].uid);
                                      createDisLike(userModelCurrent,
                                              userModelPartner[index])
                                          .then((value) {
                                        CachedNetworkImage.evictFromCache(
                                            userModelPartner[index]
                                                .userImageUrl[0]);
                                      });
                                    }

                                    if (orientation.toString() ==
                                        'CardSwipeOrientation.RIGHT') {
                                      isLook = false;
                                      listDisLike
                                          .add(userModelPartner[index].uid);

                                      createSympathy(
                                              userModelPartner[index].uid,
                                              userModelCurrent)
                                          .then((value) async {
                                        if (userModelPartner[index].token !=
                                                '' &&
                                            userModelPartner[index]
                                                .notification) {
                                          await sendFcmMessage(
                                              'tinder',
                                              'У вас симпатия',
                                              userModelPartner[index].token,
                                              'sympathy',
                                              userModelCurrent.uid,
                                              userModelCurrent.userImageUrl[0]);
                                        }
                                        CachedNetworkImage.evictFromCache(
                                            userModelPartner[index]
                                                .userImageUrl[0]);
                                      });
                                    }
                                  });
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
                            homeAnimationButton(height, width, () {
                              controllerCard.triggerLeft();
                            }, Colors.black, Icons.close, 1800),
                            homeAnimationButton(height, width, () {
                              controllerCard.triggerRight();
                            }, Colors.red, Icons.favorite, 2400),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return const loadingCustom();
  }
}
