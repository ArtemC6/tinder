import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/that_user_screen.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
import '../widget/button_widget.dart';
import '../widget/card_widget.dart';
import '../widget/component_widget.dart';

class SympathyScreen extends StatefulWidget {
  final UserModel userModelCurrent;

  SympathyScreen({Key? key, required this.userModelCurrent}) : super(key: key);

  @override
  State<SympathyScreen> createState() => _SympathyScreenState(userModelCurrent);
}

class _SympathyScreenState extends State<SympathyScreen> {
  final UserModel userModelCurrent;

  _SympathyScreenState(this.userModelCurrent);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
                isMutuallyMy =
                    asyncSnapshot.data.docs[i]['uid'] == userModelCurrent.uid;
                if (isMutuallyMy) {
                  setState(() {});
                }
              }
            } catch (eroor) {}

            return Container(
              height: size.width / 2.3,
              width: size.width,
              padding: EdgeInsets.only(
                  left: size.width / 20,
                  top: 0,
                  right: size.width / 20,
                  bottom: size.width / 20),
              child: Card(
                shadowColor: Colors.white.withOpacity(.10),
                color: color_black_88,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                    side: const BorderSide(
                      width: 0.8,
                      color: Colors.white10,
                    )
                ),
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
                            userModelPartner: UserModel(
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
                      padding: EdgeInsets.all(size.width / 50),
                      child: Row(
                        children: [
                          SizedBox(
                            width: size.width / 3.8,
                            height: size.width / 3.8,
                            child: photoUser(
                              uri: snapshot.data.docs[index]['image_uri'],
                              width: size.width / 3.8,
                              height: size.width / 3.8,
                              state: 'offline',
                              padding: 5,
                            ),
                          ),
                          SizedBox(width: size.width / 40),
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
                                                  fontSize: size.width / 40,
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
                                              onPressed: () async {
                                                deleteSympathy(
                                                    snapshot.data.docs[index]
                                                        ['id_doc'],
                                                    userModelCurrent.uid);
                                                await CachedNetworkImage
                                                    .evictFromCache(snapshot
                                                            .data.docs[index]
                                                        ['image_uri']);
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
                                                    ChatUserScreen(
                                                      friendId: snapshot.data
                                                          .docs[index]['uid'],
                                                      friendName: snapshot.data
                                                          .docs[index]['name'],
                                                      friendImage: snapshot
                                                              .data.docs[index]
                                                          ['image_uri'],
                                                      userModelCurrent:
                                                          userModelCurrent,
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
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                topPanel(context, 'Симпатии', Icons.favorite,  Colors.red, false,),
                SizedBox(
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
                                    delay: const Duration(milliseconds: 500),
                                    child: SlideAnimation(
                                      duration:
                                      const Duration(milliseconds: 1750),
                                      verticalOffset: 220,
                                      curve: Curves.ease,
                                      child: FadeInAnimation(
                                        curve: Curves.easeOut,
                                        duration:
                                        const Duration(milliseconds: 2800),
                                        child: cardSympathy(snapshot, index),
                                      ),
                                    ),
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          );
                        }
                        return cardLoadingWidget(size, .14, .08);
                        // return const loadingCustom();
                      }),
                ),
              ],
            ),
          ),
        ));
  }
}
