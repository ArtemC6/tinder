import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
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

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() => limit += 4);
        Future.delayed(const Duration(milliseconds: 600), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent - 70,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.fastOutSlowIn,
          );
        });
      }
    });

    // Isolate.spawn((message) {
    //
    // }, message)
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshotFriendId) {
                      if (snapshotFriendId.hasData) {
                        if (snapshotFriendId.data.docs.length <= 0) {
                          return SizedBox(
                            height: height,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height / 5,
                                  child: Image.asset(
                                    'images/ic_chat_logo.png',
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 30),
                                  child: animatedText(
                                      16.0,
                                      'У вас нет сообщений',
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
                                                stream: FirebaseFirestore
                                                    .instance
                                                    .collection('User')
                                                    .doc(userModelCurrent.uid)
                                                    .collection('messages')
                                                    .doc(friendId)
                                                    .snapshots(),
                                                builder: (context,
                                                    AsyncSnapshot
                                                        snapshotChat) {
                                                  if (snapshotChat.hasData &&
                                                      asyncSnapshotUser
                                                          .hasData &&
                                                      snapshotFriendId
                                                          .hasData) {
                                                    var timeLastMessage =
                                                            Timestamp.now(),
                                                        lastMsg = '',
                                                        nameUser = '',
                                                        imageUri = '',
                                                        state = '',
                                                        dataLastWrite,
                                                        isWriteUser = false,
                                                        isLastOpenChat = false,
                                                        isNewMessage = false;

                                                    try {
                                                      dataLastWrite =
                                                          snapshotChat.data[
                                                              'writeLastData'];

                                                      lastMsg = snapshotChat
                                                          .data['last_msg'];
                                                      nameUser =
                                                          asyncSnapshotUser
                                                              .data['name'];
                                                      imageUri =
                                                          asyncSnapshotUser
                                                                  .data[
                                                              'listImageUri'][0];
                                                      state = asyncSnapshotUser
                                                          .data['state'];

                                                      timeLastMessage =
                                                          snapshotChat
                                                              .data['date'];
                                                      isLastOpenChat = snapshotChat
                                                                  .data[
                                                              'last_date_open_chat'] ==
                                                          '';

                                                      if (dataLastWrite != '') {
                                                        if (DateTime.now()
                                                                .difference(
                                                                    getDataTime(
                                                                        dataLastWrite))
                                                                .inSeconds <
                                                            4) {
                                                          Future.delayed(
                                                              const Duration(
                                                                  milliseconds:
                                                                      4000),
                                                              () {
                                                            getState(4500)
                                                                .then((value) {
                                                              setState(() {
                                                                isWriteUser =
                                                                    value;
                                                              });
                                                            });
                                                          });
                                                          isWriteUser = true;
                                                          if (isLastOpenChat) {
                                                            isNewMessage = true;
                                                          }
                                                        }
                                                      }
                                                      if (isLastOpenChat) {
                                                        isNewMessage = true;
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
                                                            const EdgeInsets
                                                                .all(8),
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
                                                                try {
                                                                  Navigator.push(
                                                                      context,
                                                                      FadeRouteAnimation(ChatUserScreen(
                                                                        friendId:
                                                                            friendId,
                                                                        friendName:
                                                                            nameUser,
                                                                        friendImage:
                                                                            imageUri,
                                                                        userModelCurrent:
                                                                            userModelCurrent,
                                                                      )));
                                                                } catch (E) {}
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
                                                                    ],
                                                                  ),
                                                                  SizedBox(
                                                                      width:
                                                                          width /
                                                                              40),
                                                                  SizedBox(
                                                                    width:
                                                                        width /
                                                                            1.6,
                                                                    child:
                                                                        Column(
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
                                                                                0,
                                                                                1),
                                                                            const SizedBox(
                                                                              height: 2,
                                                                            ),
                                                                            animatedText(
                                                                                10.5,
                                                                                filterDate(timeLastMessage),
                                                                                Colors.white.withOpacity(.5),
                                                                                400,
                                                                                1),
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
                                                                              Expanded(
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(right: 10),
                                                                                  child: animatedText(11.0, lastMsg, Colors.white.withOpacity(.3), 400, 2),
                                                                                ),
                                                                              ),
                                                                            if (isWriteUser)
                                                                              showProgressWrite(),
                                                                            if (isNewMessage)
                                                                              SlideFadeTransition(
                                                                                animationDuration: const Duration(milliseconds: 400),
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.only(top: 6),
                                                                                  alignment: Alignment.center,
                                                                                  width: 16,
                                                                                  height: 16,
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(50), color: Colors.deepPurpleAccent),
                                                                                  child: animatedText(9.0, '1', Colors.white, 0, 1),
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
                                  return const SizedBox();
                                }
                              },
                            ),
                          );
                        }
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

