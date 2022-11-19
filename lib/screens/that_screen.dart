import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinder/model/user_model.dart';

import '../config/const.dart';
import '../widget/card_widget.dart';
import '../widget/component_widget.dart';



class ChatScreen extends StatelessWidget {
  final UserModel userModelCurrent;

  const ChatScreen({Key? key, required this.userModelCurrent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: color_black_88,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                topPanel(context, 'Чаты', Icons.message,  Colors.deepPurpleAccent, false,),
                SizedBox(
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(userModelCurrent.uid)
                          .collection('messages')
                          .snapshots(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.length < 1) {
                            return const Center(
                              child: Text(""),
                            );
                          }
                          return AnimationLimiter(
                            child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemCount: snapshot.data.docs.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  var friendId = snapshot.data.docs[index].id;
                                  var lastMsg =
                                      snapshot.data.docs[index]['last_msg'];
                                  var date = snapshot.data.docs[index]['date'];
                                  return AnimationConfiguration.staggeredList(
                                      position: index,
                                      delay: const Duration(milliseconds: 400),
                                      child: SlideAnimation(
                                          duration: const Duration(
                                              milliseconds: 1600),
                                          verticalOffset: 180,
                                          curve: Curves.ease,
                                          child: FadeInAnimation(
                                              curve: Curves.easeOut,
                                              duration: const Duration(
                                                  milliseconds: 2500),
                                              child: FutureBuilder(
                                                future: FirebaseFirestore
                                                    .instance
                                                    .collection('User')
                                                    .doc(friendId)
                                                    .get(),
                                                builder: (context,
                                                    AsyncSnapshot
                                                        asyncSnapshot) {
                                                  if (asyncSnapshot.hasData) {
                                                      var friend =
                                                        asyncSnapshot.data;
                                                      return itemUserChat(
                                                          friendId: friendId,
                                                          friend: friend,
                                                          lastMessage: lastMsg,
                                                          date: date,
                                                          userModelCurrent:
                                                          userModelCurrent);
                                                  }
                                                  return const SizedBox();
                                                },
                                              ))));
                                }),
                          );
                        }
                        return cardLoadingWidget(size, .12, .07);
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
