import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/widget/message_tem.dart';
import 'package:tinder/screens/widget/message_textfield.dart';
import '../config/const.dart';
import '../model/sympathy_model.dart';

class ThatUserScreen extends StatefulWidget {
  final String friendId;
  final String friendName;
  final String friendImage;

  const ThatUserScreen({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
  });

  @override
  State<ThatUserScreen> createState() =>
      _ThatUserScreenState(friendId, friendName, friendImage);
}

class _ThatUserScreenState extends State<ThatUserScreen> {
  final String friendId;
  final String friendName;
  final String friendImage;
  bool isLike = false, isLikeButton = false, isLook = false, isLoading = false;
  List<SympathyModel> listSympathy = [];

  _ThatUserScreenState(this.friendId, this.friendName, this.friendImage);

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
    showAlertDialogDeleteMessage(
        BuildContext context, AsyncSnapshot snapshot, int index) {
      // set up the buttons
      Widget cancelButton = TextButton(

        child: const Text("Отмена"),
        onPressed: () {
          print(snapshot.data.docs[index]['idDoc']);

          Navigator.pop(context);
        },
      );
      Widget continueButton = TextButton(
        child: const Text("Удалить"),
        onPressed: () {
          Navigator.pop(context);
          FirebaseFirestore.instance
              .collection('User')
              .doc(FirebaseAuth.instance.currentUser?.uid)
              .collection('messages')
              .doc(friendId)
              .collection('chats')
              .doc(snapshot.data.docs[index]['idDoc'])
              .delete()
              .then((value) {
            FirebaseFirestore.instance
                .collection('users')
                .doc(friendId)
                .collection('messages')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .collection('chats')
                .doc(snapshot.data.docs[index]['idDoc'])
                .delete();
          });
        },
      );

      // set up the AlertDialog
      AlertDialog alert = AlertDialog(
        backgroundColor: color_data_input,
        title: RichText(
          text: TextSpan(
            text: 'Удалить сообщение',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                  color: Colors.white, fontSize: 17, letterSpacing: .4),
            ),
          ),
        ),
        // content: Text("Would you like to continue learning how to use Flutter alerts?"),
        actions: [
          cancelButton,
          continueButton,
        ],
      );

      // show the dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alert;
        },
      );
    }

    if (isLoading) {
      return Scaffold(
          backgroundColor: color_data_input,
          body: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    color: color_data_input,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 30,
                        top: 20,
                        right: MediaQuery.of(context).size.width / 30,
                        bottom: 4),
                    child: Row(
                      children: [
                        InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 14, top: 8, bottom: 0, right: 4),
                          child: InkWell(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onTap: () {},
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
                                            borderRadius:
                                                BorderRadius.circular(50),
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
                                              height: 40,
                                              width: 40,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 0.8,
                                                value: progress.progress,
                                              ),
                                            ),
                                          ),
                                          imageUrl: friendImage,
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  const BorderRadius.all(
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
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                // SizedBox(width: MediaQuery.of(context).size.width / 40),
                                Container(
                                  padding: const EdgeInsets.only(left: 8),
                                  width:
                                      MediaQuery.of(context).size.width / 1.5,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: friendName,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(.9),
                                                    fontSize: 13,
                                                    letterSpacing: .5),
                                              ),
                                            ),
                                          ),
                                          RichText(
                                            text: TextSpan(
                                              text: 'был(а) 18:00',
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(.5),
                                                    fontSize: 10,
                                                    letterSpacing: .5),
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
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: color_data_input,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25))),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("User")
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection('messages')
                            .doc(friendId)
                            .collection('chats')
                            .orderBy("date", descending: true)
                            .snapshots(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data.docs.length < 1) {
                              return const Center(
                                child: Text(""),
                              );
                            }
                            return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                reverse: true,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  bool isMe = snapshot.data.docs[index]
                                          ['senderId'] ==
                                      FirebaseAuth.instance.currentUser?.uid;
                                  return InkWell(
                                      onTap: () {
                                        showAlertDialogDeleteMessage(
                                            context, snapshot, index);
                                      },
                                      child: MessagesItem(
                                          snapshot.data.docs[index]['message'],
                                          isMe,
                                          getDataTimeDate(snapshot
                                              .data.docs[index]['date'])));
                                  // child: SingleMessage(
                                  //     message: snapshot.data.docs[index]['message'],
                                  //     isMe: isMe));
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
                  MessageTextField(
                      FirebaseAuth.instance.currentUser!.uid, friendId),
                  const SizedBox(
                    width: .09,
                  )
                ],
              ),
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
