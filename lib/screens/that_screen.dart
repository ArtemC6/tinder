import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../config/const.dart';
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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                child: RichText(
                  text: TextSpan(
                    text: 'Чат',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white.withOpacity(.8),
                          fontSize: 20,
                          letterSpacing: .5),
                    ),
                  ),
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
                                        duration:
                                            const Duration(milliseconds: 1800),
                                        verticalOffset: 140,
                                        curve: Curves.ease,
                                        child: FadeInAnimation(
                                            curve: Curves.easeOut,
                                            duration: const Duration(
                                                milliseconds: 2500),
                                            child: FutureBuilder(
                                              future: FirebaseFirestore.instance
                                                  .collection('User')
                                                  .doc(friendId)
                                                  .get(),
                                              builder: (context,
                                                  AsyncSnapshot asyncSnapshot) {
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
                      return Center(
                        child: LoadingAnimationWidget.dotsTriangle(
                          size: 44,
                          color: Colors.blueAccent,
                        ),
                      );
                    }),
              ),
            ],
          ),
        ));
  }
}
