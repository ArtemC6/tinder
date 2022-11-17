import 'dart:ui';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:like_button/like_button.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
import '../screens/settings/edit_profile_screen.dart';
import '../screens/that_user_screen.dart';

class buttonAuth extends StatelessWidget {
  String name;
  double width;
  VoidCallback voidCallback;

  buttonAuth(this.name, this.width, this.voidCallback, {super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 15, sigmaX: 15),
        child: InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          onTap: voidCallback,
          child: Container(
            height: size.width / 8,
            width: size.width / width,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              border: Border.all(color: Colors.white10, width: 0.5),
              borderRadius: BorderRadius.circular(15),
            ),
            child: RichText(
              text: TextSpan(
                text: name,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white.withOpacity(.8),
                      fontSize: 12,
                      letterSpacing: .5),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class customIconButton extends StatelessWidget {
  String path;
  double height, width, padding;
  VoidCallback onTap;

  customIconButton(
      {Key? key,
      required this.path,
      required this.height,
      required this.width,
      required this.padding,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: Image.asset(
          path,
          height: height,
          width: width,
        ),
      ),
    );
  }
}

class buttonProfileUser extends StatefulWidget {
  UserModel userModel;
  UserModel userModelCurrent;

  buttonProfileUser(
    this.userModelCurrent,
    this.userModel, {
    super.key,
    Key,
  });

  @override
  State<buttonProfileUser> createState() =>
      _buttonProfileState(userModel, userModelCurrent);
}

class _buttonProfileState extends State<buttonProfileUser> {
  UserModel userModel;
  UserModel userModelCurrent;

  _buttonProfileState(this.userModel, this.userModelCurrent);

  @override
  Widget build(BuildContext context) {
    Widget button(String name, color, onTap) {
      return Container(
        padding: const EdgeInsets.only(right: 20),
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
              text: TextSpan(
                text: name,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white, fontSize: 11, letterSpacing: .1),
                ),
              ),
            ),
          ),
        ),
      );
    }

    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('User')
            .doc(userModelCurrent.uid)
            .collection('sympathy')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          bool isMutuallyMain = false;

          try {
            for (int i = 0; i < snapshot.data.docs.length; i++) {
              isMutuallyMain = snapshot.data.docs[i]['uid'] ==
                  FirebaseAuth.instance.currentUser!.uid;

              if (isMutuallyMain) {
                setState(() {});
              }
            }
          } catch (E) {}
          return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('User')
                  .doc(userModel.uid)
                  .collection('sympathy')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                bool isMutually = false;

                try {
                  for (int i = 0; i < snapshot.data.docs.length; i++) {
                    isMutually =
                        snapshot.data.docs[i]['uid'] == userModelCurrent.uid;
                    if (isMutually) {
                      setState(() {});
                    }
                  }
                } catch (E) {}

                if (isMutuallyMain && !isMutually) {
                  return button('Ожидайте ответа',
                      [Colors.blueAccent, Colors.purpleAccent], () {
                    if (!isMutuallyMain) {
                      createSympathy(userModelCurrent.uid, userModel);
                      setState(() {
                        isMutuallyMain = !isMutuallyMain;
                      });
                    } else {
                      deleteSympathyPartner(
                          userModelCurrent.uid, userModel.uid);
                      setState(() {
                        isMutuallyMain = !isMutuallyMain;
                      });
                    }
                  });
                } else if (!isMutuallyMain && !isMutually) {
                  return button(
                      'Оставить симпатию', [color_black_88, color_black_88],
                      () {
                    if (!isMutuallyMain) {
                      createSympathy(userModelCurrent.uid, userModel);
                      setState(() {
                        isMutuallyMain = !isMutuallyMain;
                      });
                    } else {
                      deleteSympathyPartner(
                          userModelCurrent.uid, userModel.uid);
                      setState(() {
                        isMutuallyMain = !isMutuallyMain;
                      });
                    }
                  });
                } else {
                  return button('Написать', [
                    Colors.blueAccent,
                    Colors.purpleAccent,
                    Colors.orangeAccent
                  ], () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ChatUserScreen(
                              friendId: userModel.uid,
                              friendName: userModel.name,
                              friendImage: userModel.userImageUrl[0],
                              userModelCurrent: userModelCurrent,
                            )));
                  });
                }
              });
        });
  }
}

class buttonProfileMy extends StatelessWidget {
  UserModel userModel;

  buttonProfileMy(this.userModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 20),
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
          border: Border.all(width: 0.7, color: Colors.white30),
          gradient: const LinearGradient(
              colors: [Colors.blueAccent, Colors.purpleAccent]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
                context,
                FadeRouteAnimation(EditProfileScreen(
                  isFirst: false,
                  userModel: userModel,
                )));
          },
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: RichText(
            text: TextSpan(
              text: 'Редактировать',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Colors.white, fontSize: 11, letterSpacing: .1),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class buttonLike extends StatelessWidget {
  bool isLike;
  UserModel userModelCurrent, userModel;

  buttonLike(
      {Key? key,
      required this.isLike,
      required this.userModelCurrent,
      required this.userModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 30),
      child: LikeButton(
        isLiked: isLike,
        size: 32,
        circleColor:
            const CircleColor(start: Colors.pinkAccent, end: Colors.red),
        bubblesColor: const BubblesColor(
          dotPrimaryColor: Colors.pink,
          dotSecondaryColor: Colors.deepPurpleAccent,
        ),
        likeBuilder: (bool isLiked) {
          return Icon(
            isLiked ? Icons.favorite_outlined : Icons.favorite_border_sharp,
            color: isLiked ? Colors.red : Colors.white,
            size: 32,
          );
        },
        onTap: (isLiked) {
          return putLike(
            userModelCurrent,
            userModel,
            true,
          );
        },
      ),
    );
  }
}

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
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
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

InkWell homeAnimationButton(
    double height, double width, onTap, Color colors, IconData icon) {
  return InkWell(
    highlightColor: Colors.transparent,
    splashColor: Colors.transparent,
    onTap: onTap,
    child: SizedBox(
      height: height / 5,
      width: width / 2,
      child: AvatarGlow(
        glowColor: Colors.blueAccent,
        endRadius: 60,
        repeatPauseDuration: const Duration(milliseconds: 1500),
        duration: const Duration(milliseconds: 2000),
        repeat: true,
        showTwoGlows: true,
        curve: Curves.easeOutQuad,
        child: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(99)),
          child: Icon(
            icon,
            color: colors,
            size: 30,
          ),
        ),
      ),
    ),
  );
}
