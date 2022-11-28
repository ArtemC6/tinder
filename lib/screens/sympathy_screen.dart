import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/that_user_screen.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';
import '../widget/button_widget.dart';
import '../widget/card_widget.dart';
import '../widget/component_widget.dart';

class SympathyScreen extends StatefulWidget {
  final UserModel userModelCurrent;

  const SympathyScreen({Key? key, required this.userModelCurrent})
      : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<SympathyScreen> createState() => _SympathyScreenState(userModelCurrent);
}

class _SympathyScreenState extends State<SympathyScreen> {
  final UserModel userModelCurrent;
  final scrollController = ScrollController();
  int limit = 5;

  _SympathyScreenState(this.userModelCurrent);

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() => limit += 3);
        Future.delayed(const Duration(milliseconds: 800), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent - 80,
            duration: const Duration(milliseconds: 1700),
            curve: Curves.fastOutSlowIn,
          );
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: color_black_88,
        body: SafeArea(
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                topPanel(
                  context,
                  'Симпатии',
                  Icons.favorite,
                  Colors.red,
                  false,
                ),
                SizedBox(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(userModelCurrent.uid)
                          .collection('sympathy')
                          .orderBy("time", descending: true)
                          .limit(limit)
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.length <= 0) {
                            return SizedBox(
                              height: height,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: height / 5,
                                    child: Image.asset(
                                      'images/ic_sympathy.png',
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: animatedText(
                                        16.0,
                                        'У вас нет симпатий',
                                        Colors.white,
                                        500,
                                        1),
                                  ),
                                  SizedBox(
                                    height: height / 4,
                                  )
                                ],
                              ),
                            );
                          } else {
                            return AnimationLimiter(
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.docs.length + 1,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  if (index < snapshot.data.docs.length &&
                                      snapshot.hasData) {
                                    var name = '',
                                        age = 0,
                                        imageUri = '',
                                        idDoc = '',
                                        city = '',
                                        uid = '',
                                        isMutuallyMy = false;

                                    try {
                                      uid = snapshot.data.docs[index]['uid'];
                                      name = snapshot.data.docs[index]['name'];
                                      age = snapshot.data.docs[index]['age'];
                                      city = snapshot.data.docs[index]['city'];
                                      imageUri = snapshot.data.docs[index]
                                          ['image_uri'];
                                      idDoc =
                                          snapshot.data.docs[index]['id_doc'];
                                    } catch (E) {}

                                    return AnimationConfiguration.staggeredList(
                                      position: index,
                                      delay: const Duration(milliseconds: 500),
                                      child: SlideAnimation(
                                        duration:
                                            const Duration(milliseconds: 1850),
                                        verticalOffset: 220,
                                        curve: Curves.ease,
                                        child: FadeInAnimation(
                                          curve: Curves.easeOut,
                                          duration: const Duration(
                                              milliseconds: 2800),
                                          child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('User')
                                                  .doc(uid)
                                                  .collection('sympathy')
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot asyncSnapshot) {
                                                if (asyncSnapshot.hasData &&
                                                    snapshot.hasData) {
                                                  try {
                                                    for (int i = 0;
                                                        i <
                                                            asyncSnapshot.data
                                                                .docs.length;
                                                        i++) {
                                                      isMutuallyMy =
                                                          asyncSnapshot.data
                                                                      .docs[i]
                                                                  ['uid'] ==
                                                              userModelCurrent
                                                                  .uid;
                                                      if (isMutuallyMy) {
                                                        break;
                                                      }
                                                    }
                                                  } catch (E) {}

                                                  return Container(
                                                    height: size.width / 2.3,
                                                    width: size.width,
                                                    padding: EdgeInsets.only(
                                                        left: size.width / 20,
                                                        top: 0,
                                                        right: size.width / 20,
                                                        bottom:
                                                            size.width / 20),
                                                    child: Card(
                                                      shadowColor: Colors.white
                                                          .withOpacity(.10),
                                                      color: color_black_88,
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                              side:
                                                                  const BorderSide(
                                                                width: 0.8,
                                                                color: Colors
                                                                    .white10,
                                                              )),
                                                      elevation: 14,
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: InkWell(
                                                          highlightColor: Colors
                                                              .transparent,
                                                          splashColor: Colors
                                                              .transparent,
                                                          onTap: () {
                                                            Navigator.push(
                                                                context,
                                                                FadeRouteAnimation(
                                                                    ProfileScreen(
                                                                  userModelPartner: UserModel(
                                                                      name: '',
                                                                      uid: '',
                                                                      myCity:
                                                                          '',
                                                                      ageTime:
                                                                          Timestamp
                                                                              .now(),
                                                                      userPol:
                                                                          '',
                                                                      searchPol:
                                                                          '',
                                                                      searchRangeStart:
                                                                          0,
                                                                      userImageUrl: [],
                                                                      userImagePath: [],
                                                                      imageBackground:
                                                                          '',
                                                                      userInterests: [],
                                                                      searchRangeEnd:
                                                                          0,
                                                                      ageInt: 0,
                                                                      state:
                                                                          ''),
                                                                  isBack: true,
                                                                  idUser: uid,
                                                                  userModelCurrent:
                                                                      userModelCurrent,
                                                                )));
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    size.width /
                                                                        50),
                                                            child: Row(
                                                              children: [
                                                                SizedBox(
                                                                  width:
                                                                      size.width /
                                                                          3.8,
                                                                  height:
                                                                      size.width /
                                                                          3.8,
                                                                  child:
                                                                      photoUser(
                                                                    uri:
                                                                        imageUri,
                                                                    width:
                                                                        size.width /
                                                                            3.8,
                                                                    height:
                                                                        size.width /
                                                                            3.8,
                                                                    state:
                                                                        'offline',
                                                                    padding: 5,
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        size.width /
                                                                            40),
                                                                Expanded(
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          SlideFadeTransition(
                                                                            animationDuration:
                                                                                const Duration(milliseconds: 450),
                                                                            child:
                                                                                Column(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                RichText(
                                                                                  text: TextSpan(
                                                                                    text: '${name.trim()}, $age',
                                                                                    style: GoogleFonts.lato(
                                                                                      textStyle: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: .9),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                RichText(
                                                                                  text: TextSpan(
                                                                                    text: city,
                                                                                    style: GoogleFonts.lato(
                                                                                      textStyle: TextStyle(color: Colors.white.withOpacity(.8), fontSize: size.width / 40, letterSpacing: .5),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            margin:
                                                                                const EdgeInsets.only(bottom: 20, left: 10),
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                SizedBox(
                                                                                  height: 40,
                                                                                  width: 40,
                                                                                  child: IconButton(
                                                                                    onPressed: () async {
                                                                                      deleteSympathy(idDoc, userModelCurrent.uid);
                                                                                      await CachedNetworkImage.evictFromCache(imageUri);
                                                                                    },
                                                                                    icon: const Icon(Icons.close, size: 20),
                                                                                    color: Colors.white,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceAround,
                                                                        children: [
                                                                          if (!isMutuallyMy)
                                                                            buttonSympathy('Принять симпатию', [
                                                                              color_black_88,
                                                                              color_black_88
                                                                            ], () {
                                                                              if (!isMutuallyMy) {
                                                                                createSympathy(uid, userModelCurrent).then((value) {
                                                                                  setState(() {});
                                                                                });
                                                                              }
                                                                            }),
                                                                          if (isMutuallyMy)
                                                                            buttonSympathy('У вас взаимно', [
                                                                              Colors.blueAccent,
                                                                              Colors.purpleAccent,
                                                                              Colors.orangeAccent
                                                                            ], () {
                                                                              deleteSympathyPartner(uid, userModelCurrent.uid).then((value) {
                                                                                Future.delayed(const Duration(milliseconds: 300), () {
                                                                                  setState(() {});
                                                                                });
                                                                              });
                                                                            }),
                                                                          customIconButton(
                                                                            onTap:
                                                                                () {
                                                                              Navigator.of(context).push(MaterialPageRoute(
                                                                                  builder: (context) => ChatUserScreen(
                                                                                        friendId: uid,
                                                                                        friendName: name,
                                                                                        friendImage: imageUri,
                                                                                        userModelCurrent: userModelCurrent,
                                                                                      )));
                                                                            },
                                                                            path:
                                                                                'images/ic_send.png',
                                                                            height:
                                                                                34,
                                                                            width:
                                                                                34,
                                                                            padding:
                                                                                4,
                                                                          )
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                                return const SizedBox();
                                              }),
                                        ),
                                      ),
                                    );
                                  } else {
                                    if (snapshot.data.docs.length >= limit &&
                                        snapshot.hasData) {
                                      return const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 30),
                                        child: Center(
                                          child: SizedBox(
                                            height: 24,
                                            width: 24,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 0.8,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                  return const SizedBox();
                                },
                              ),
                            );
                          }
                        } else {
                          return cardLoadingWidget(size, .14, .08);
                        }
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}

// import 'dart:async';
//
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:tinder/screens/profile_screen.dart';
// import 'package:tinder/screens/that_user_screen.dart';
//
// import '../config/const.dart';
// import '../config/firestore_operations.dart';
// import '../model/user_model.dart';
// import '../widget/animation_widget.dart';
// import '../widget/button_widget.dart';
// import '../widget/card_widget.dart';
// import '../widget/component_widget.dart';
//
// class SympathyScreen extends StatefulWidget {
//   final UserModel userModelCurrent;
//
//   const SympathyScreen({Key? key, required this.userModelCurrent})
//       : super(key: key);
//
//   @override
//   // ignore: no_logic_in_create_state
//   State<SympathyScreen> createState() => _SympathyScreenState(userModelCurrent);
// }
//
// class _SympathyScreenState extends State<SympathyScreen> {
//   final UserModel userModelCurrent;
//   final scrollController = ScrollController();
//   int limit = 5;
//
//   _SympathyScreenState(this.userModelCurrent);
//
//
//
//   @override
//   void initState() {
//     scrollController.addListener(() {
//       if (scrollController.position.maxScrollExtent ==
//           scrollController.offset) {
//         setState(() => limit += 3);
//         Future.delayed(const Duration(milliseconds: 700), () {
//           setState(() {});
//           scrollController.animateTo(
//             scrollController.position.maxScrollExtent - 80,
//             duration: const Duration(milliseconds: 2000),
//             curve: Curves.fastOutSlowIn,
//           );
//         });
//       }
//     });
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         backgroundColor: color_black_88,
//         body: SafeArea(
//           child: SingleChildScrollView(
//             controller: scrollController,
//             physics: const BouncingScrollPhysics(),
//             child: Column(
//               children: [
//                 topPanel(
//                   context,
//                   'Симпатии',
//                   Icons.favorite,
//                   Colors.red,
//                   false,
//                 ),
//                 SizedBox(
//                   child: StreamBuilder(
//                       stream: FirebaseFirestore.instance
//                           .collection('User')
//                           .doc(userModelCurrent.uid)
//                           .collection('sympathy')
//                           .orderBy("time", descending: true)
//                           .limit(limit)
//                           .snapshots(),
//                       builder: (context, AsyncSnapshot snapshot) {
//                         if (snapshot.hasData) {
//                           if (snapshot.data.docs.length <= 0) {
//                             return SizedBox(
//                               height: height,
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.center,
//                                 children: [
//                                   SizedBox(
//                                     height: height / 5,
//                                     child: Image.asset(
//                                       'images/ic_sympathy.png',
//                                     ),
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.only(top: 30),
//                                     child: animatedText(
//                                         16.0,
//                                         'У вас нет симпатий',
//                                         Colors.white,
//                                         500,
//                                         1),
//                                   ),
//                                   SizedBox(
//                                     height: height / 4,
//                                   )
//                                 ],
//                               ),
//                             );
//                           } else {
//                             return AnimationLimiter(
//                               child: ListView.builder(
//                                 physics: const BouncingScrollPhysics(),
//                                 scrollDirection: Axis.vertical,
//                                 itemCount: snapshot.data.docs.length + 1,
//                                 shrinkWrap: true,
//                                 itemBuilder: (context, index) {
//                                   if (index < snapshot.data.docs.length &&
//                                       snapshot.hasData) {
//                                     var name = '',
//                                         age = 0,
//                                         imageUri = '',
//                                         idDoc = '',
//                                         city = '',
//                                         uid = '',
//                                         isMutuallyMy = false;
//
//                                     try {
//                                       uid = snapshot.data.docs[index]['uid'];
//                                       name = snapshot.data.docs[index]['name'];
//                                       age = snapshot.data.docs[index]['age'];
//                                       city = snapshot.data.docs[index]['city'];
//                                       imageUri = snapshot.data.docs[index]
//                                       ['image_uri'];
//                                       idDoc =
//                                       snapshot.data.docs[index]['id_doc'];
//                                     } catch (E) {}
//
//                                     return AnimationConfiguration.staggeredList(
//                                       position: index,
//                                       delay: const Duration(milliseconds: 500),
//                                       child: SlideAnimation(
//                                         duration:
//                                         const Duration(milliseconds: 1850),
//                                         verticalOffset: 220,
//                                         curve: Curves.ease,
//                                         child: FadeInAnimation(
//                                           curve: Curves.easeOut,
//                                           duration: const Duration(
//                                               milliseconds: 2800),
//                                           child: StreamBuilder(
//                                               stream: FirebaseFirestore.instance
//                                                   .collection('User')
//                                                   .doc(uid)
//                                                   .collection('sympathy')
//                                                   .snapshots(),
//                                               builder: (context,
//                                                   AsyncSnapshot asyncSnapshot) {
//                                                 if (asyncSnapshot.hasData &&
//                                                     snapshot.hasData) {
//                                                   try {
//                                                     for (int i = 0;
//                                                     i <
//                                                         asyncSnapshot.data
//                                                             .docs.length;
//                                                     i++) {
//                                                       isMutuallyMy =
//                                                           asyncSnapshot.data
//                                                               .docs[i]
//                                                           ['uid'] ==
//                                                               userModelCurrent
//                                                                   .uid;
//                                                       if (isMutuallyMy) {
//                                                         break;
//                                                       }
//                                                     }
//                                                   } catch (E) {}
//
//                                                   return Container(
//                                                     height: size.width / 2.3,
//                                                     width: size.width,
//                                                     padding: EdgeInsets.only(
//                                                         left: size.width / 20,
//                                                         top: 0,
//                                                         right: size.width / 20,
//                                                         bottom:
//                                                         size.width / 20),
//                                                     child: Card(
//                                                       shadowColor: Colors.white
//                                                           .withOpacity(.10),
//                                                       color: color_black_88,
//                                                       shape:
//                                                       RoundedRectangleBorder(
//                                                           borderRadius:
//                                                           BorderRadius
//                                                               .circular(
//                                                               30),
//                                                           side:
//                                                           const BorderSide(
//                                                             width: 0.8,
//                                                             color: Colors
//                                                                 .white10,
//                                                           )),
//                                                       elevation: 14,
//                                                       child: Container(
//                                                         decoration:
//                                                         BoxDecoration(
//                                                           borderRadius:
//                                                           BorderRadius
//                                                               .circular(30),
//                                                         ),
//                                                         child: InkWell(
//                                                           highlightColor: Colors
//                                                               .transparent,
//                                                           splashColor: Colors
//                                                               .transparent,
//                                                           onTap: () {
//                                                             setState(() => limit += 3);
//                                                             // Navigator.push(
//                                                             //     context,
//                                                             //     FadeRouteAnimation(
//                                                             //         ProfileScreen(
//                                                             //       userModelPartner: UserModel(
//                                                             //           name: '',
//                                                             //           uid: '',
//                                                             //           myCity:
//                                                             //               '',
//                                                             //           ageTime:
//                                                             //               Timestamp
//                                                             //                   .now(),
//                                                             //           userPol:
//                                                             //               '',
//                                                             //           searchPol:
//                                                             //               '',
//                                                             //           searchRangeStart:
//                                                             //               0,
//                                                             //           userImageUrl: [],
//                                                             //           userImagePath: [],
//                                                             //           imageBackground:
//                                                             //               '',
//                                                             //           userInterests: [],
//                                                             //           searchRangeEnd:
//                                                             //               0,
//                                                             //           ageInt: 0,
//                                                             //           state:
//                                                             //               ''),
//                                                             //       isBack: true,
//                                                             //       idUser: uid,
//                                                             //       userModelCurrent:
//                                                             //           userModelCurrent,
//                                                             //     )));
//                                                           },
//                                                           child: Padding(
//                                                             padding:
//                                                             EdgeInsets.all(
//                                                                 size.width /
//                                                                     50),
//                                                             child: Row(
//                                                               children: [
//                                                                 SizedBox(
//                                                                   width:
//                                                                   size.width /
//                                                                       3.8,
//                                                                   height:
//                                                                   size.width /
//                                                                       3.8,
//                                                                   child:
//                                                                   photoUser(
//                                                                     uri:
//                                                                     imageUri,
//                                                                     width:
//                                                                     size.width /
//                                                                         3.8,
//                                                                     height:
//                                                                     size.width /
//                                                                         3.8,
//                                                                     state:
//                                                                     'offline',
//                                                                     padding: 5,
//                                                                   ),
//                                                                 ),
//                                                                 SizedBox(
//                                                                     width:
//                                                                     size.width /
//                                                                         40),
//                                                                 Expanded(
//                                                                   child: Column(
//                                                                     mainAxisAlignment:
//                                                                     MainAxisAlignment
//                                                                         .spaceEvenly,
//                                                                     children: [
//                                                                       Row(
//                                                                         mainAxisAlignment:
//                                                                         MainAxisAlignment.spaceBetween,
//                                                                         children: [
//                                                                           SlideFadeTransition(
//                                                                             animationDuration:
//                                                                             const Duration(milliseconds: 450),
//                                                                             child:
//                                                                             Column(
//                                                                               crossAxisAlignment: CrossAxisAlignment.start,
//                                                                               children: [
//                                                                                 RichText(
//                                                                                   text: TextSpan(
//                                                                                     text: '${name.trim()}, $age  $limit',
//                                                                                     style: GoogleFonts.lato(
//                                                                                       textStyle: const TextStyle(color: Colors.white, fontSize: 16, letterSpacing: .9),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                                 RichText(
//                                                                                   text: TextSpan(
//                                                                                     text: city,
//                                                                                     style: GoogleFonts.lato(
//                                                                                       textStyle: TextStyle(color: Colors.white.withOpacity(.8), fontSize: size.width / 40, letterSpacing: .5),
//                                                                                     ),
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                           Container(
//                                                                             margin:
//                                                                             const EdgeInsets.only(bottom: 20, left: 10),
//                                                                             alignment:
//                                                                             Alignment.topRight,
//                                                                             child:
//                                                                             Row(
//                                                                               children: [
//                                                                                 SizedBox(
//                                                                                   height: 40,
//                                                                                   width: 40,
//                                                                                   child: IconButton(
//                                                                                     onPressed: () async {
//                                                                                       deleteSympathy(idDoc, userModelCurrent.uid);
//                                                                                       await CachedNetworkImage.evictFromCache(imageUri);
//                                                                                     },
//                                                                                     icon: const Icon(Icons.close, size: 20),
//                                                                                     color: Colors.white,
//                                                                                   ),
//                                                                                 ),
//                                                                               ],
//                                                                             ),
//                                                                           ),
//                                                                         ],
//                                                                       ),
//                                                                       Row(
//                                                                         mainAxisAlignment:
//                                                                         MainAxisAlignment.spaceAround,
//                                                                         children: [
//                                                                           if (!isMutuallyMy)
//                                                                             buttonSympathy('Принять симпатию', [
//                                                                               color_black_88,
//                                                                               color_black_88
//                                                                             ], () {
//                                                                               if (!isMutuallyMy) {
//                                                                                 createSympathy(uid, userModelCurrent).then((value) {
//                                                                                   setState(() {});
//                                                                                 });
//                                                                               }
//                                                                             }),
//                                                                           if (isMutuallyMy)
//                                                                             buttonSympathy('У вас взаимно', [
//                                                                               Colors.blueAccent,
//                                                                               Colors.purpleAccent,
//                                                                               Colors.orangeAccent
//                                                                             ], () {
//                                                                               deleteSympathyPartner(uid, userModelCurrent.uid).then((value) {
//                                                                                 Future.delayed(const Duration(milliseconds: 300), () {
//                                                                                   setState(() {
//                                                                                   });
//                                                                                 });
//                                                                               });
//                                                                             }),
//                                                                           customIconButton(
//                                                                             onTap:
//                                                                                 () {
//                                                                               Navigator.of(context).push(MaterialPageRoute(
//                                                                                   builder: (context) => ChatUserScreen(
//                                                                                     friendId: uid,
//                                                                                     friendName: name,
//                                                                                     friendImage: imageUri,
//                                                                                     userModelCurrent: userModelCurrent,
//                                                                                   )));
//                                                                             },
//                                                                             path:
//                                                                             'images/ic_send.png',
//                                                                             height:
//                                                                             34,
//                                                                             width:
//                                                                             34,
//                                                                             padding:
//                                                                             4,
//                                                                           )
//                                                                         ],
//                                                                       ),
//                                                                     ],
//                                                                   ),
//                                                                 ),
//                                                               ],
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 }
//                                                 return const SizedBox();
//                                               }),
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     if (snapshot.data.docs.length >= limit &&
//                                         snapshot.hasData) {
//                                       return const Padding(
//                                         padding:
//                                         EdgeInsets.symmetric(vertical: 30),
//                                         child: Center(
//                                           child: SizedBox(
//                                             height: 24,
//                                             width: 24,
//                                             child: CircularProgressIndicator(
//                                               color: Colors.white,
//                                               strokeWidth: 0.8,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     }
//                                   }
//                                   return const SizedBox();
//                                 },
//                               ),
//                             );
//                           }
//                         } else {
//                           return cardLoadingWidget(size, .14, .08);
//                         }
//                       }),
//                 ),
//               ],
//             ),
//           ),
//         ));
//   }
// }
