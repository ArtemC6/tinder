import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/that_user_screen.dart';

import 'data/const.dart';
import 'data/model/sympathy_model.dart';
import 'home_manager.dart';

class ThatScreen extends StatefulWidget {
  const ThatScreen({Key? key}) : super(key: key);

  @override
  State<ThatScreen> createState() => _ThatScreenState();
}

class _ThatScreenState extends State<ThatScreen> {
  bool isLike = false, isLikeButton = false, isLook = false, isLoading = false;
  List<SympathyModel> listSympathy = [];

  void readFirebase() async {
    Future.delayed(const Duration(milliseconds: 0), () {});

    setState(() {
      isLoading = true;
    });
  }

  Future<void> deleteSympathy(String id) async {
    final docUser = FirebaseFirestore.instance
        .collection("Sympathy")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Like');
    docUser.doc(id).delete().then((value) {
      Navigator.pushReplacement(
          context,
          FadeRouteAnimation(
            HomeMain(currentIndex: 1),
          ));
    });
  }

  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardSympathy(friend, friendId, lastMessage, date) {
      double width = MediaQuery.of(context).size.width;
      return Container(
        height: width / 3.7,
        width: width,
        padding: EdgeInsets.only(
            left: width / 30, top: 0, right: width / 30, bottom: width / 30),
        child: Card(
          // shadowColor: Colors.white30,
          color: color_data_input,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            // side: const BorderSide(
            //   width: 0.8,
            //   color: Colors.white10,
            // )
          ),
          elevation: 14,
          child: Container(
            padding:
                const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 10),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ThatUserScreen(
                          friendId: friendId,
                          friendName: friend['name'],
                          friendImage: friend['listImageUri'][0],
                        )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      SizedBox(
                        child: Card(
                          shadowColor: Colors.white38,
                          color: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                              side: const BorderSide(
                                width: 0.8,
                                color: Colors.white30,
                              )),
                          elevation: 4,
                          child: CachedNetworkImage(
                            progressIndicatorBuilder:
                                (context, url, progress) => Center(
                              child: SizedBox(
                                height: 58,
                                width: 58,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 0.8,
                                  value: progress.progress,
                                ),
                              ),
                            ),
                            imageUrl: friend['listImageUri'][0],
                            imageBuilder: (context, imageProvider) => Container(
                              height: 58,
                              width: 58,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () {
                          // _uploadFirstImage();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Image.asset(
                            'images/ic_green_dot.png',

                            // 'images/ic_orange_dot.png',
                            height: 27,
                            width: 27,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width / 40),
                  SizedBox(
                    width: width / 1.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: friend['name'],
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                    '${getDataTimeDate(date).hour}: ${getDataTimeDate(date).minute}',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white.withOpacity(.4),
                                      fontSize: 10.5,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width / 1.9,
                              child: RichText(
                                maxLines: 2,
                                text: TextSpan(
                                  text: lastMessage,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(.4),
                                        fontSize: 11,
                                        letterSpacing: .5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.deepPurpleAccent),
                              child: RichText(
                                text: TextSpan(
                                  text: '1',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        letterSpacing: .0),
                                  ),
                                ),
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
      );
    }

    if (isLoading) {
      return Scaffold(
          backgroundColor: color_data_input,
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
                                      delay: const Duration(milliseconds: 700),
                                      child: SlideAnimation(
                                          duration: const Duration(
                                              milliseconds: 2200),
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

                                                    return cardSympathy(
                                                        friend,
                                                        friendId,
                                                        lastMsg,
                                                        date);
                                                  }
                                                  return const SizedBox();
                                                },
                                              ))));
                                }),
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
                      }),
                ),
              ],
            ),
          ));
    }
    return Scaffold(
        backgroundColor: color_data_input,
        body: Center(
          child: LoadingAnimationWidget.dotsTriangle(
            size: 44,
            color: Colors.blueAccent,
          ),
        ));
  }
}
