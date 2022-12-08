import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';
import 'package:tinder/model/user_model.dart';
import 'package:tinder/screens/that_user_screen.dart';

import '../config/const.dart';
import '../config/utils.dart';
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

class _ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  final UserModel userModelCurrent;
  final scrollController = ScrollController();
  int limit = 7;
  bool isLoadingUser = false;
  late final AnimationController animationController;

  _ChatScreenState(this.userModelCurrent);

  @override
  void initState() {
    animationController = AnimationController(vsync: this);

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
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
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
                color_black_88,
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
                          return showIfNoData(height , 'images/animation_chat.json',
                              'У вас нет сообщений', animationController, 3.5);
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
                                          const Duration(milliseconds: 950),
                                      verticalOffset: 80,
                                      curve: Curves.ease,
                                      child: FadeInAnimation(
                                        curve: Curves.easeOut,
                                        duration:
                                            const Duration(milliseconds: 2200),
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
                                                        indexAnimation = index + 1,
                                                        token = '',
                                                        state = '',
                                                        dataLastWrite,
                                                        isWriteUser = false,
                                                        isLastOpenChat = false,
                                                        isNewMessage = false,
                                                        notification = false;

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
                                                      token = asyncSnapshotUser
                                                          .data['token'];
                                                      notification =
                                                          asyncSnapshotUser
                                                                  .data[
                                                              'notification'];

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
                                                          child: InkWell(
                                                            highlightColor:
                                                                Colors
                                                                    .transparent,
                                                            splashColor: Colors
                                                                .transparent,
                                                            onTap: () {
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
                                                                      token:
                                                                          token,
                                                                      notification:
                                                                          notification,
                                                                    ),),);
                                                            },
                                                            child: Padding(
                                                              padding: const EdgeInsets.only(left: 4, bottom: 4, top: 4, right: 24),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .start,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Expanded(
                                                                    flex: 1,
                                                                    child: photoUser(
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
                                                                  SizedBox(
                                                                      width:
                                                                          width /
                                                                              40),
                                                                  Expanded(
                                                                    flex: 3,
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
                                                                                  child: animatedText(11.0, lastMsg, Colors.white.withOpacity(.3),
                                                                                      indexAnimation * 400 < 2400 ? indexAnimation  * 400 : 600, 2),
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

