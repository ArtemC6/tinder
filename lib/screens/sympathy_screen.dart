import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/that_user_screen.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/sympathy_model.dart';
import '../model/user_model.dart';

class SympathyScreen extends StatefulWidget {
  late UserModel userModelCurrent;

  SympathyScreen({Key? key, required this.userModelCurrent}) : super(key: key);

  @override
  State<SympathyScreen> createState() => _SympathyScreenState(userModelCurrent);
}

class _SympathyScreenState extends State<SympathyScreen> {
  bool isLike = false,
      isLikeButton = false,
      isLook = false,
      isLoading = false;
  List<SympathyModel> listSympathy = [];
  UserModel userModelCurrent;

  _SympathyScreenState(this.userModelCurrent);

  void readFirebase() async {
    setState(() {
      isLoading = true;
    });
  }


  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardSympathy(SympathyModel sympathyModel, int index) {
      double width = MediaQuery
          .of(context)
          .size
          .width;

      return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(sympathyModel.uid)
            .collection('sympathy')
            .snapshots(),

        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          bool isMutually = false;

          try {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              isMutually = snapshot.data.docs[i]['uid'] ==
                  userModelCurrent.uid;
            }
          } catch (E) {}

          // print(snapshot.data.docs[index]['name']);
          return Container(
            height: width / 2.3,
            width: width,
            padding: EdgeInsets.only(
                left: width / 20,
                top: 0,
                right: width / 20,
                bottom: width / 20),
            child: Card(
              color: color_data_input,
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
                              ageInt: 0),
                          isBack: true,
                          idUser: sympathyModel.uid, userModelCurrent: userModelCurrent,
                        )));
                  },
                  child: Padding(
                    padding: EdgeInsets.all(width / 50),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
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
                                  (context, url, progress) =>
                                  Center(
                                    child: SizedBox(
                                      height: 100,
                                      width: 100,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 0.8,
                                        value: progress.progress,
                                      ),
                                    ),
                                  ),
                              imageUrl: sympathyModel.uri,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                            ),
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
                                          '${sympathyModel
                                              .name}, ${sympathyModel.age}',
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
                                          text: sympathyModel.city,
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
                                                  sympathyModel.id_doc,
                                                  userModelCurrent.uid);
                                              setState(() {
                                                listSympathy.removeAt(index);
                                              });
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
                              const SizedBox(),
                              Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.only(left: 10),
                                    height: 40,
                                    child: DecoratedBox(
                                      decoration: isMutually
                                          ? BoxDecoration(
                                        gradient: const LinearGradient(
                                            colors: [
                                              Colors.blueAccent,
                                              Colors.purpleAccent,
                                              Colors.orangeAccent
                                            ]),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 0.7,
                                            color: Colors.white30),
                                      )
                                          : BoxDecoration(
                                        color:
                                        Colors.white.withOpacity(.08),
                                        borderRadius:
                                        BorderRadius.circular(20),
                                        border: Border.all(
                                            width: 0.7,
                                            color: Colors.white30),
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (!isMutually) {
                                            createSympathy(sympathyModel.uid,
                                                userModelCurrent);
                                            setState(() {
                                              isMutually = !isMutually;
                                            });
                                          } else {
                                            deleteSympathyPartner(
                                                sympathyModel.uid,
                                                userModelCurrent.uid);
                                            setState(() {
                                              isMutually = !isMutually;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          shadowColor: Colors.transparent,
                                          backgroundColor: Colors.transparent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(20)),
                                        ),
                                        child: RichText(
                                          text: TextSpan(
                                            text: isMutually
                                                ? 'У вас взаимно'
                                                : 'Принять симпатию',
                                            style: GoogleFonts.lato(
                                              textStyle: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  letterSpacing: .1),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.all(4),
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ThatUserScreen(
                                                        friendId:
                                                        sympathyModel.uid,
                                                        friendName:
                                                        sympathyModel.name,
                                                        friendImage:
                                                        sympathyModel.uri,
                                                      )));
                                        },
                                        icon:
                                        Image.asset('images/ic_send.png')),
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
        },
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
                  height: MediaQuery
                      .of(context)
                      .size
                      .height,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('User')
                          .doc(userModelCurrent.uid)
                          .collection('sympathy')
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
                                  if (snapshot.hasData) {
                                    return AnimationConfiguration.staggeredList(
                                        position: index,
                                        delay: const Duration(
                                            milliseconds: 600),
                                        child: SlideAnimation(
                                          duration: const Duration(milliseconds:
                                          2200),
                                          verticalOffset: 200,
                                          curve: Curves.ease,
                                          child: FadeInAnimation(
                                              curve: Curves.easeOut,
                                              duration: const Duration(
                                                  milliseconds: 2500),
                                              child: cardSympathy(SympathyModel(
                                                  name: snapshot.data
                                                      .docs[index]['name'],
                                                  id_doc: snapshot.data
                                                      .docs[index]['id_doc'],
                                                  uid: snapshot.data
                                                      .docs[index]['uid'],
                                                  city: snapshot.data
                                                      .docs[index]['city'],
                                                  uri: snapshot.data
                                                      .docs[index]['image_uri'],
                                                  age: snapshot.data
                                                      .docs[index]['age'],
                                                  time: snapshot.data
                                                      .docs[index]['time']
                                              )
                                                  ,
                                                  index
                                              )
                                          ),
                                        )
                                    );
                                  }
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
