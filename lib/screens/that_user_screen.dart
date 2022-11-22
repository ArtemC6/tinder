import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../config/const.dart';
import '../model/user_model.dart';
import '../widget/component_widget.dart';
import '../widget/dialog_widget.dart';
import '../widget/message_widget.dart';

class ChatUserScreen extends StatefulWidget {
  final String friendName, friendId, friendImage;
  final UserModel userModelCurrent;

  const ChatUserScreen({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
    required this.userModelCurrent,
  });

  @override
  State<ChatUserScreen> createState() =>
      _ChatUserScreenState(friendId, friendName, friendImage, userModelCurrent);
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  final String friendId, friendName, friendImage;
  final UserModel userModelCurrent;
  final scrollController = ScrollController();
  int limit = 20;

  _ChatUserScreenState(
      this.friendId, this.friendName, this.friendImage, this.userModelCurrent);

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          limit += 10;
        });
      }
    });

    FirebaseFirestore.instance
        .collection('User')
        .doc(userModelCurrent.uid)
        .collection('messages')
        .doc(widget.friendId)
        .update({
      'last_date_open_hat': DateTime.now(),
    });

    super.initState();
  }

  @override
  void dispose() {
    FirebaseFirestore.instance
        .collection('User')
        .doc(userModelCurrent.uid)
        .collection('messages')
        .doc(widget.friendId)
        .update({
      'last_date_open_hat': DateTime.now(),
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color_black_88,
        body: SingleChildScrollView(
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
                    top: 10,
                    right: 14,
                  ),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(friendId)
                          .snapshots(),
                      builder:
                          (BuildContext context, AsyncSnapshot asyncSnapshot) {
                        if (asyncSnapshot.hasData) {
                          return topPanelChat(context, asyncSnapshot, friendId,
                              friendImage, friendName, userModelCurrent);
                        } else {
                          return const SizedBox();
                        }
                      }),
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
                        if (snapshotMy.hasData) {
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
                                return AnimationLimiter(
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      controller: scrollController,
                                      itemCount:
                                          snapshotMy.data.docs.length + 1,
                                      reverse: true,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        if (index <
                                            snapshotMy.data.docs.length) {
                                          bool isMe = snapshotMy.data
                                                  .docs[index]['senderId'] ==
                                              userModelCurrent.uid;
                                          return AnimationConfiguration
                                              .staggeredList(
                                            position: index,
                                            delay: const Duration(
                                                milliseconds: 100),
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
                                                        showAlertDialogDeleteMessage(
                                                            context,
                                                            friendId,
                                                            userModelCurrent
                                                                .uid,
                                                            friendName,
                                                            snapshotMy.data
                                                                    .docs[index]
                                                                ['idDoc'],
                                                            snapshot.data!
                                                                    .docs[index]
                                                                ['idDoc']);
                                                      },
                                                      child: MessagesItem(
                                                          snapshotMy.data
                                                                  .docs[index]
                                                              ['message'],
                                                          isMe,
                                                          getDataTimeDate(
                                                              snapshotMy.data
                                                                          .docs[
                                                                      index]
                                                                  ['date']),
                                                          friendImage))),
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
                                      }),
                                );
                              });
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
                      }),
                )),
                MessageTextField(userModelCurrent.uid, friendId),
                const SizedBox(
                  width: .09,
                )
              ],
            ),
          ),
        ));
  }
}
