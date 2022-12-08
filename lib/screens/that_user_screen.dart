import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../config/utils.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';
import '../widget/component_widget.dart';
import '../widget/dialog_widget.dart';
import '../widget/message_widget.dart';

class ChatUserScreen extends StatefulWidget {
  final String friendName, friendId, friendImage, token;
  final bool notification;
  final UserModel userModelCurrent;

  const ChatUserScreen({
    super.key,
    required this.friendId,
    required this.token,
    required this.friendName,
    required this.notification,
    required this.friendImage,
    required this.userModelCurrent,
  });

  @override
  State<ChatUserScreen> createState() => _ChatUserScreenState(
      friendId, friendName, friendImage, userModelCurrent, token, notification);
}

class _ChatUserScreenState extends State<ChatUserScreen>
    with TickerProviderStateMixin {
  String friendId, friendName, friendImage, token;
  bool notification;
  final UserModel userModelCurrent;
  final scrollController = ScrollController();
  int limit = 20;
  bool isLoading = false;
  late final AnimationController animationController;

  _ChatUserScreenState(this.friendId, this.friendName, this.friendImage,
      this.userModelCurrent, this.token, this.notification);

  @override
  void initState() {
    readUser();
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          limit += 10;
        });
        Future.delayed(const Duration(milliseconds: 300), () {
          scrollController.animateTo(
            scrollController.position.maxScrollExtent - 60,
            duration: const Duration(milliseconds: 1500),
            curve: Curves.fastOutSlowIn,
          );
        });
      }
    });
    createLastOpenChat(userModelCurrent.uid, widget.friendId);
    super.initState();
  }

  Future readUser() async {
    animationController = AnimationController(vsync: this);
    if (friendName.isEmpty && friendImage.isEmpty && token.isEmpty) {
      await readUserFirebase(friendId).then((user) {
        setState(() {
          friendName = user.name;
          friendImage = user.userImageUrl[0];
          token = user.token;
          notification = user.notification;
        });
        isLoading = true;
      });
    }
    setState(() => isLoading = true);
  }

  @override
  void dispose() {
    animationController.dispose();
    createLastOpenChat(userModelCurrent.uid, widget.friendId);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_black_88,
        body: SafeArea(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 80,
                  color: color_black_88,
                  padding: const EdgeInsets.only(
                    left: 14,
                    top: 0,
                    right: 14,
                  ),
                  child: topPanelChat(
                    userModelCurrent: userModelCurrent,
                    friendId: friendId,
                    friendImage: friendImage,
                    friendName: friendName,
                  ),
                ),
                Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: color_black_88,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(25),
                              topRight: Radius.circular(25))),
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection("User")
                              .doc(userModelCurrent.uid)
                              .collection('messages')
                              .doc(friendId)
                              .collection('chats')
                              .limit(limit)
                              .orderBy("date", descending: true)
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshotMy) {
                            return StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection("User")
                                  .doc(friendId)
                                  .collection('messages')
                                  .doc(userModelCurrent.uid)
                                  .collection('chats')
                                  .limit(limit)
                                  .orderBy("date", descending: true)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshotMy.hasData && snapshot.hasData) {
                                  int lengthDoc = snapshotMy.data.docs.length;
                              if (snapshotMy.data.docs.length <= 0) {
                                return showAnimationGif(height, 'images/animation_user_chat.json', animationController);
                              } else {
                                return AnimationLimiter(
                                  child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.vertical,
                                    controller: scrollController,
                                    itemCount: lengthDoc + 1,
                                    reverse: true,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      if (index < snapshotMy.data.docs.length) {
                                        var myIdMessage = '',
                                            message = '',
                                            date = Timestamp.now(),
                                            isMe = false;
                                        try {
                                          myIdMessage = snapshotMy
                                              .data.docs[index]['idDoc'];
                                          message = snapshotMy.data.docs[index]
                                              ['message'];
                                          date = snapshotMy.data.docs[index]
                                              ['date'];
                                          isMe = snapshotMy.data.docs[index]
                                                  ['senderId'] ==
                                              userModelCurrent.uid;
                                        } catch (E) {}
                                        return AnimationConfiguration
                                            .staggeredList(
                                          position: index,
                                          delay:
                                              const Duration(milliseconds: 100),
                                          child: SlideAnimation(
                                            duration: const Duration(
                                                milliseconds: 1400),
                                            horizontalOffset: 200,
                                            curve: Curves.ease,
                                            child: FadeInAnimation(
                                              curve: Curves.easeOut,
                                              duration: const Duration(
                                                  milliseconds: 2200),
                                              child: InkWell(
                                                onLongPress: () async {
                                                  bool isLastMessage = false;
                                                  int indexRevers = index == 0
                                                      ? lengthDoc
                                                      : index;
                                                  if (indexRevers ==
                                                      lengthDoc) {
                                                    isLastMessage = true;
                                                  }
                                                  showAlertDialogDeleteMessage(
                                                      context,
                                                      friendId,
                                                      userModelCurrent.uid,
                                                      friendName,
                                                      myIdMessage,
                                                      snapshot.data!.docs[index]
                                                          ['idDoc'],
                                                      snapshotMy,
                                                      index + 1,
                                                      isLastMessage);
                                                },
                                                child: MessagesItem(
                                                    message,
                                                    isMe,
                                                    getDataTime(date),
                                                    friendImage),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        bool isLimitMax =
                                            snapshotMy.data.docs.length >=
                                                limit;
                                        if (isLimitMax) {
                                          return const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Center(
                                              child: SizedBox(
                                                height: 24,
                                                width: 24,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 0.8,
                                                ),
                                              ),
                                            ),
                                          );
                                        } else {
                                          return const SizedBox();
                                        }
                                      }
                                    },
                                  ),
                                );
                              }
                            }
                                return const Center(
                                  child: SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 0.8,
                                    ),
                                  ),
                                );
                              },
                            );
                          }),
                    )),
                MessageTextField(userModelCurrent.uid, friendId, token,
                    friendName, notification),
                const SizedBox(
                  width: .09,
                )
              ],
            ),
          ),
        ),
      );
    }
    return const Center(
      child: SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: Colors.white,
          strokeWidth: 0.8,
        ),
      ),
    );
  }
}
