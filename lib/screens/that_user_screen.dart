import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/sympathy_model.dart';
import '../widget/component_widget.dart';
import '../widget/message_tem.dart';
import '../widget/message_textfield.dart';

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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
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
                                size: 22,
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
                                    SizedBox(
                                      height: 44,
                                      width: 44,
                                      child: StreamBuilder(
                                        stream: FirebaseFirestore.instance
                                            .collection('User')
                                            .doc(friendId)
                                            .snapshots(),
                                        builder: (BuildContext context,
                                            AsyncSnapshot asyncSnapshot) {
                                          return SizedBox(
                                            height: 44,
                                            width: 44,
                                            child: photoUser(
                                              height: 44,
                                              width: 44,
                                              uri: friendImage,
                                              state:
                                                  asyncSnapshot.data['state'],
                                              padding: 0,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(left: 8),
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
                        PopupMenuButton<int>(onSelected: (value) {
                          if (value == 0) {
                            showAlertDialogDeleteThat(
                                context, friendId, friendName, true);
                          }
                        }, itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem(
                              value: 0,
                              child: RichText(
                                text: TextSpan(
                                  text: 'Удалить чат',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                        letterSpacing: .6),
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuItem(
                                value: 1,
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Изменить цвет',
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                          letterSpacing: .6),
                                    ),
                                  ),
                                )),
                          ];
                        })
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
                                            context, snapshot, index, friendId);
                                      },
                                      child: MessagesItem(
                                          snapshot.data.docs[index]['message'],
                                          isMe,
                                          getDataTimeDate(snapshot
                                              .data.docs[index]['date'])));
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
