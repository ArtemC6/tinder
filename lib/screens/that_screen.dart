import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/model/user_model.dart';
import 'package:tinder/screens/that_user_screen.dart';

import '../config/const.dart';
import '../widget/animation_widget.dart';
import '../widget/card_widget.dart';
import '../widget/component_widget.dart';
import '../widget/dialog_widget.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModelCurrent;

  const ChatScreen({Key? key, required this.userModelCurrent})
      : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState(userModelCurrent);
}

class _ChatScreenState extends State<ChatScreen> {
  final UserModel userModelCurrent;
  final scrollController = ScrollController();
  int limit = 7;
  bool isLoadingUser = false;

  _ChatScreenState(this.userModelCurrent);

  void startTimer() {
    int time = 0;
    Timer timer = Timer.periodic(
      const Duration(seconds: 3),
      (Timer timer) {
        time++;
        setState(() {});
        if(time == 2) {
          timer.cancel();
        }
      },
    );
  }

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          limit += 4;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                'Сообщения',
                Icons.message,
                Colors.deepPurpleAccent,
                false,
              ),
              SizedBox(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.userModelCurrent.uid)
                        .collection('messages')
                        .limit(limit)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshotFriendId) {
                      if (snapshotFriendId.hasData) {
                        return AnimationLimiter(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshotFriendId.data.docs.length + 1,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (index < snapshotFriendId.data.docs.length) {
                                var friendId =
                                    snapshotFriendId.data.docs[index].id;
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  delay: const Duration(milliseconds: 300),
                                  child: SlideAnimation(
                                    duration:
                                        const Duration(milliseconds: 1000),
                                    verticalOffset: 80,
                                    curve: Curves.ease,
                                    child: FadeInAnimation(
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 2000),
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(friendId)
                                            .snapshots(),
                                        builder: (context,
                                            AsyncSnapshot asyncSnapshotUser) {
                                          return SizedBox(
                                            child: StreamBuilder(
                                              stream: FirebaseFirestore.instance
                                                  .collection('User')
                                                  .doc(userModelCurrent.uid)
                                                  .collection('messages')
                                                  .doc(friendId)
                                                  .snapshots(),
                                              builder: (context,
                                                  AsyncSnapshot snapshotChat) {
                                                if (snapshotChat.hasData &&
                                                    asyncSnapshotUser.hasData &&
                                                    snapshotFriendId.hasData) {
                                                  var timeLastMessage =
                                                          Timestamp.now(),
                                                      lastMsg = '',
                                                      nameUser = '',
                                                      imageUri = '',
                                                      state = '',
                                                      isWriteUser = false,
                                                      isNewMessage = false;

                                                  try {
                                                    lastMsg = snapshotChat
                                                        .data['last_msg'];
                                                    nameUser = asyncSnapshotUser
                                                        .data['name'];
                                                    imageUri =
                                                        asyncSnapshotUser.data[
                                                            'listImageUri'][0];
                                                    state = asyncSnapshotUser
                                                        .data['state'];
                                                    timeLastMessage =
                                                        snapshotChat
                                                            .data['date'];

                                                    if (snapshotChat.data[
                                                            'writeLastData'] !=
                                                        '') {
                                                      if (DateTime.now()
                                                              .difference(getDataTimeDate(
                                                                  snapshotChat
                                                                          .data[
                                                                      'writeLastData']))
                                                              .inMilliseconds <
                                                          3500) {
                                                        setState(() {
                                                          startTimer();
                                                          isWriteUser = true;
                                                          if (snapshotChat.data[
                                                                  'last_date_open_chat'] ==
                                                              '') {
                                                            isNewMessage = true;
                                                          }
                                                        });
                                                      }
                                                    }
                                                    if (snapshotChat.data[
                                                            'last_date_open_chat'] ==
                                                        '') {
                                                      setState(() {
                                                        isNewMessage = true;
                                                      });
                                                    }
                                                  } catch (errro) {}

                                                  return InkWell(
                                                    highlightColor:
                                                        Colors.transparent,
                                                    splashColor:
                                                        Colors.transparent,
                                                    onLongPress: () {
                                                      showAlertDialogDeleteChat(
                                                          context,
                                                          friendId,
                                                          nameUser,
                                                          false,
                                                          imageUri);
                                                    },
                                                    child: Container(
                                                      height: width * 0.30,
                                                      width: width,
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8),
                                                      child: Card(
                                                        shadowColor: Colors
                                                            .white
                                                            .withOpacity(.08),
                                                        color: color_black_88,
                                                        shape:
                                                            RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18),
                                                                side:
                                                                    const BorderSide(
                                                                  width: 0.2,
                                                                  color: Colors
                                                                      .white10,
                                                                )),
                                                        elevation: 14,
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(10),
                                                          child: InkWell(
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            splashColor: Colors
                                                                .transparent,
                                                            onTap: () {
                                                              Navigator.push(
                                                                  context,
                                                                  FadeRouteAnimation(
                                                                      ChatUserScreen(
                                                                    friendId:
                                                                        friendId,
                                                                    friendName:
                                                                        nameUser,
                                                                    friendImage:
                                                                        imageUri,
                                                                    userModelCurrent:
                                                                        userModelCurrent,
                                                                  )));
                                                            },
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Stack(
                                                                  alignment:
                                                                      Alignment
                                                                          .bottomLeft,
                                                                  children: [
                                                                    SizedBox(
                                                                      child:
                                                                          photoUser(
                                                                        uri:
                                                                            imageUri,
                                                                        width: width *
                                                                            0.17,
                                                                        height: width *
                                                                            0.17,
                                                                        state:
                                                                            state,
                                                                        padding:
                                                                            0,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(
                                                                    width:
                                                                        width /
                                                                            40),
                                                                SizedBox(
                                                                  width: width /
                                                                      1.6,
                                                                  child: Column(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          animatedText(
                                                                              14.0,
                                                                              nameUser,
                                                                              Colors.white,
                                                                              0),
                                                                          const SizedBox(
                                                                            height:
                                                                                2,
                                                                          ),
                                                                          animatedText(
                                                                              10.5,
                                                                              filterDate(timeLastMessage),
                                                                              Colors.white.withOpacity(.5),
                                                                              400),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(
                                                                        height:
                                                                            4,
                                                                      ),
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          if (!isWriteUser)
                                                                            SizedBox(
                                                                              width: width / 1.9,
                                                                              child: animatedText(11.0, lastMsg, Colors.white.withOpacity(.3), 400),
                                                                            ),
                                                                          if (isWriteUser)
                                                                            SlideFadeTransition(
                                                                              animationDuration: const Duration(milliseconds: 400),
                                                                              child: Row(
                                                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                                children: [
                                                                                  LoadingAnimationWidget.horizontalRotatingDots(
                                                                                    size: 20,
                                                                                    color: Colors.blueAccent,
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.only(left: 5, bottom: 2),
                                                                                    child: RichText(
                                                                                      text: TextSpan(
                                                                                        text: 'печатает...',
                                                                                        style: GoogleFonts.lato(
                                                                                          textStyle: const TextStyle(color: Colors.blueAccent, fontSize: 10.5, letterSpacing: .7),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                          if (isNewMessage)
                                                                            SlideFadeTransition(
                                                                              animationDuration: const Duration(milliseconds: 400),
                                                                              child: Container(
                                                                                margin: const EdgeInsets.only(top: 6),
                                                                                alignment: Alignment.center,
                                                                                width: 16,
                                                                                height: 16,
                                                                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.deepPurpleAccent),
                                                                                child: animatedText(9.0, '1', Colors.white, 0),
                                                                              ),
                                                                            ),
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
                                              },
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              } else {
                                if (snapshotFriendId.data.docs.length >=
                                        limit &&
                                    snapshotFriendId.hasData) {
                                  return const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 30),
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
                                return const SizedBox();
                              }
                            },
                          ),
                        );
                      }
                      return const SizedBox();
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

