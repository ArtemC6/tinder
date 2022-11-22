import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinder/model/user_model.dart';

import '../config/const.dart';
import '../widget/card_widget.dart';
import '../widget/component_widget.dart';

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
  int limit = 8;
  bool isLoadingUser = false;

  _ChatScreenState(this.userModelCurrent);

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          limit += 6;
        });
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  'Чаты',
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
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return AnimationLimiter(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.docs.length + 1,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                if (index < snapshot.data.docs.length) {
                                  var friendId = snapshot.data.docs[index].id;
                                  var lastMsg =
                                      snapshot.data.docs[index]['last_msg'];
                                  var date = snapshot.data.docs[index]['date'];
                                  return AnimationConfiguration.staggeredList(
                                    position: index,
                                    delay: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      duration:
                                          const Duration(milliseconds: 1300),
                                      verticalOffset: 220,
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
                                              AsyncSnapshot asyncSnapshot) {
                                            if (asyncSnapshot.hasData) {
                                              var friend = asyncSnapshot.data;
                                              return itemUserChat(
                                                  friendId: friendId,
                                                  friend: friend,
                                                  lastMessage: lastMsg,
                                                  date: date,
                                                  userModelCurrent:
                                                      widget.userModelCurrent);
                                            }
                                            return SizedBox();
                                          },
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  bool isLimitMax =
                                      snapshot.data.docs.length >= limit;
                                  if (isLimitMax && snapshot.hasData) {
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
                        return SizedBox();
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
