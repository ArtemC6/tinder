import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/that_user_screen.dart';
import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
import '../widget/button_widget.dart';
import '../widget/card_widget.dart';

class SympathyScreen extends StatefulWidget {
  late UserModel userModelCurrent;

  SympathyScreen({Key? key, required this.userModelCurrent}) : super(key: key);

  @override
  State<SympathyScreen> createState() => _SympathyScreenState(userModelCurrent);
}

class _SympathyScreenState extends State<SympathyScreen> {
  UserModel userModelCurrent;
  _SympathyScreenState(this.userModelCurrent);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    Widget buttonSympathy(String name, color, onTap) {
      return SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: const [
              BoxShadow(
                color: Colors.white38,
                blurRadius: 5.0,
                spreadRadius: 0.0,
                offset: Offset(
                  0.0,
                  1.0,
                ),
              )
            ],
            border: Border.all(width: 0.8, color: Colors.white38),
            gradient: LinearGradient(colors: color),
            borderRadius: BorderRadius.circular(20),
          ),
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              shadowColor: Colors.transparent,
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
            child: RichText(
              maxLines: 1,
              text: TextSpan(
                text: name,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white, fontSize: 10.5, letterSpacing: .0),
                ),
              ),
            ),
          ),
        ),
      );
    }

    Widget cardSympathy(AsyncSnapshot snapshot, int index) {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('User')
              .doc(snapshot.data.docs[index]['uid'])
              .collection('sympathy')
              .snapshots(),
          builder: (context, AsyncSnapshot asyncSnapshot) {
            bool isMutuallyMy = false;

            try {
              for (int i = 0; i < asyncSnapshot.data.docs.length; i++) {
                setState(() {
                  isMutuallyMy =
                      asyncSnapshot.data.docs[i]['uid'] == userModelCurrent.uid;
                });
              }
            } catch (E) {}

            return Container(
              height: width / 2.3,
              width: width,
              padding: EdgeInsets.only(
                  left: width / 20,
                  top: 0,
                  right: width / 20,
                  bottom: width / 20),
              child: Card(
                color: color_black_88,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      width: 0.8,
                      color: Colors.white10,
                    )),
                elevation: 14,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: InkWell(
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      Navigator.push(
                          context,
                          FadeRouteAnimation(ProfileScreen(
                            userModel: UserModel(
                                name: '',
                                uid: '',
                                myCity: '',
                                ageTime: Timestamp.now(),
                                userPol: '',
                                searchPol: '',
                                searchRangeStart: 0,
                                userImageUrl: [],
                                userImagePath: [],
                                imageBackground: '',
                                userInterests: [],
                                searchRangeEnd: 0,
                                ageInt: 0,
                                state: ''),
                            isBack: true,
                            idUser: snapshot.data.docs[index]['uid'],
                            userModelCurrent: userModelCurrent,
                          )));
                    },
                    child: Padding(
                      padding: EdgeInsets.all(width / 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width / 3.8,
                            height: width / 3.8,
                            child: photoUser(
                              uri: snapshot.data.docs[index]['image_uri'],
                              width: width / 3.8,
                              height: width / 3.8,
                              state: 'online',
                              padding: 5,
                            ),
                          ),
                          SizedBox(width: width / 40),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            text:
                                                '${snapshot.data.docs[index]['name']}, ${snapshot.data.docs[index]['age']}',
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  letterSpacing: .9),
                                            ),
                                          ),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: snapshot.data.docs[index]
                                                ['city'],
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(.8),
                                                  fontSize: width / 40,
                                                  letterSpacing: .5),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 20, left: 10),
                                      alignment: Alignment.topRight,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            height: 40,
                                            width: 40,
                                            child: IconButton(
                                              onPressed: () {
                                                deleteSympathy(
                                                    snapshot.data.docs[index]
                                                        ['id_doc'],
                                                    userModelCurrent.uid);
                                              },
                                              icon: const Icon(Icons.close,
                                                  size: 20),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    if (!isMutuallyMy)
                                      buttonSympathy('Принять симпатию',
                                          [color_black_88, color_black_88], () {
                                        if (!isMutuallyMy) {
                                          createSympathy(
                                              snapshot.data.docs[index]['uid'],
                                              userModelCurrent);
                                          setState(() {
                                            isMutuallyMy = !isMutuallyMy;
                                          });
                                        } else {
                                          deleteSympathyPartner(
                                              snapshot.data.docs[index]['uid'],
                                              userModelCurrent.uid);
                                          setState(() {
                                            isMutuallyMy = !isMutuallyMy;
                                          });
                                        }
                                      }),
                                    if (isMutuallyMy)
                                      buttonSympathy('У вас взаимно', [
                                        Colors.blueAccent,
                                        Colors.purpleAccent,
                                        Colors.orangeAccent
                                      ], () {
                                        if (!isMutuallyMy) {
                                          createSympathy(
                                              snapshot.data.docs[index]['uid'],
                                              userModelCurrent);
                                          setState(() {
                                            isMutuallyMy = !isMutuallyMy;
                                          });
                                        } else {
                                          deleteSympathyPartner(
                                              snapshot.data.docs[index]['uid'],
                                              userModelCurrent.uid);
                                          setState(() {
                                            isMutuallyMy = !isMutuallyMy;
                                          });
                                        }
                                      }),
                                    customIconButton(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ThatUserScreen(
                                                      friendId: snapshot.data
                                                          .docs[index]['uid'],
                                                      friendName: snapshot.data
                                                          .docs[index]['name'],
                                                      friendImage: snapshot
                                                              .data.docs[index]
                                                          ['image_uri'],
                                                    )));
                                      },
                                      path: 'images/ic_send.png',
                                      height: 34,
                                      width: 34,
                                      padding: 4,
                                    )
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
          });
    }

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
                    text: 'Симпатии',
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
                        .doc(userModelCurrent.uid)
                        .collection('sympathy')
                        .snapshots(),
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return AnimationLimiter(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: snapshot.data.docs.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              if (snapshot.hasData) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  delay: const Duration(milliseconds: 600),
                                  child: SlideAnimation(
                                    duration:
                                        const Duration(milliseconds: 2200),
                                    verticalOffset: 200,
                                    curve: Curves.ease,
                                    child: FadeInAnimation(
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      child: cardSympathy(snapshot, index),
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
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
