import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/screens/profile_screen.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
import '../widget/card_widget.dart';
import '../widget/message_widget.dart';


class ChatUserScreen extends StatefulWidget {
  final String friendName, friendId, friendImage;
  final UserModel userModelCurrent;

  const ChatUserScreen({
    super.key,
    required this.friendId,
    required this.friendName,
    required this.friendImage,
    required this.userModelCurrent,
  });

  @override
  State<ChatUserScreen> createState() =>
      _ChatUserScreenState(friendId, friendName, friendImage, userModelCurrent);
}

class _ChatUserScreenState extends State<ChatUserScreen> {
  final String friendId, friendName, friendImage;
  final UserModel userModelCurrent;
  final scrollController = ScrollController();
  int limit = 20;

  _ChatUserScreenState(
      this.friendId, this.friendName, this.friendImage, this.userModelCurrent);

  @override
  void initState() {
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent ==
          scrollController.offset) {
        setState(() {
          limit += 12;
        });
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color_black_88,
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  color: color_black_88,
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
                                      idUser: friendId,
                                      userModelCurrent: userModelCurrent,
                                    )));
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  imagePhotoChat(friendImage, friendId),
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
                          showAlertDialogDeleteChat(
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
                      color: color_black_88,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25))),
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("User")
                          .doc(userModelCurrent.uid)
                          .collection('messages')
                          .doc(friendId)
                          .collection('chats')
                          .limit(limit)
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
                              controller: scrollController,
                              itemCount: snapshot.data.docs.length + 1,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                if (index < snapshot.data.docs.length) {
                                  bool isMe = snapshot.data.docs[index]
                                          ['senderId'] ==
                                      userModelCurrent.uid;
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
                                } else {
                                  bool isLimitMax =
                                      snapshot.data.docs.length >= limit;
                                  if (isLimitMax) {
                                    return const Padding(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 20),
                                      child: Center(
                                        child: SizedBox(
                                          height: 24,
                                          width: 24,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 0.8,
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const SizedBox();
                                  }
                                }
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
                MessageTextField(userModelCurrent.uid, friendId),
                const SizedBox(
                  width: .09,
                )
              ],
            ),
          ),
        ));
  }
}
