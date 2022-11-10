import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../config/const.dart';
import '../widget/animation_widget.dart';
import '../widget/card_widget.dart';

class ThatScreen extends StatefulWidget {
  const ThatScreen({Key? key}) : super(key: key);

  @override
  State<ThatScreen> createState() => _ThatScreenState();
}

class _ThatScreenState extends State<ThatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color_black_88,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: const TextSpan(
                          text: 'Чаты',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              letterSpacing: .4),
                        ),
                      ),
                      Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            borderRadius: BorderRadius.circular(99)),
                        child: const Icon(
                          Icons.message,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(FirebaseAuth.instance.currentUser!.uid)
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
                                      delay: const Duration(milliseconds: 500),
                                      child: SlideAnimation(
                                          duration: const Duration(
                                              milliseconds: 1800),
                                          verticalOffset: 140,
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
                                                    return itemUser(
                                                      friendId: friendId,
                                                      friend: friend,
                                                      lastMessage: lastMsg,
                                                      date: date,
                                                    );
                                                  }
                                                  return const SizedBox();
                                                },
                                              ))));
                                }),
                          );
                        }
                        return const loadingCustom();
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
