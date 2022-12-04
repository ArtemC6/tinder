import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';

class MessagesItem extends StatelessWidget {
  final String message_text, friendImage;
  final bool isMyMassage;
  final DateTime dataMessage;

  MessagesItem(
      this.message_text, this.isMyMassage, this.dataMessage, this.friendImage,
      {super.key});

  @override
  Widget build(BuildContext context) {
    Container formMessageMy() {
      return Container(
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.01),
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)),
            border: Border.all(color: Colors.white10, width: 0.9)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: message_text.length < 10
                    ? '$message_text              '
                    : message_text,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 13,
                      letterSpacing: .5),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                text: '${dataMessage.hour}: ${dataMessage.minute}',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 10,
                      letterSpacing: .5),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget formMessageFriend() {
      return Container(
        margin: EdgeInsets.only(left: 10),
        decoration: BoxDecoration(
            color: Colors.white.withOpacity(.01),
            borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                topRight: Radius.circular(20)),
            border: Border.all(color: Colors.white10, width: 0.9)),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: message_text.length < 10
                    ? '$message_text              '
                    : message_text,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 13,
                      letterSpacing: .5),
                ),
              ),
            ),
            RichText(
              text: TextSpan(
                text: '${dataMessage.hour}: ${dataMessage.minute}',
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                      color: Colors.white.withOpacity(.9),
                      fontSize: 10,
                      letterSpacing: .5),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            textDirection: isMyMassage ? TextDirection.rtl : TextDirection.ltr,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * .75,
                child: Align(
                  alignment: isMyMassage
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: isMyMassage ? formMessageMy() : formMessageFriend(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
        ],
      ),
    );
  }
}

class MessageTextField extends StatefulWidget {
  final String currentId, friendId, token, friendName;
  final bool notification;

  const MessageTextField(this.currentId, this.friendId, this.token,
      this.friendName, this.notification,
      {super.key});

  @override
  _MessageTextFieldState createState() => _MessageTextFieldState(
      currentId, friendId, token, friendName, notification);
}

class _MessageTextFieldState extends State<MessageTextField> {
  final String currentId, friendId, token, friendName;
  final bool notification;
  final TextEditingController _controllerMessage = TextEditingController();
  bool isWrite = true;

  _MessageTextFieldState(this.currentId, this.friendId, this.token,
      this.friendName, this.notification);

  void startTimer() {
    Timer.periodic(
      const Duration(seconds: 5),
      (Timer timer) {
        setState(() {
          isWrite = true;
        });
        timer.cancel();
      },
    );
  }

  @override
  void initState() {
    _controllerMessage.addListener(() {
      if (_controllerMessage.text.isNotEmpty) {
        if (isWrite) {
          startTimer();
          isWrite = false;
          putUserWrites(currentId, friendId);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 20, left: 14, right: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: MediaQuery.of(context).size.width / 1.3,
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [
                  Colors.pinkAccent,
                  Colors.purpleAccent,
                  Colors.blueAccent,
                ]),
                // ),
                borderRadius: BorderRadius.circular(26),
              ),
              child: Padding(
                padding: const EdgeInsets.all(
                  1.4,
                ),
                child: Container(
                  alignment: Alignment.center,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
                  decoration: BoxDecoration(
                    color: color_black_88,
                    border: Border.all(color: color_black_88),
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: TextFormField(
                    textCapitalization: TextCapitalization.words,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(550),
                    ],
                    controller: _controllerMessage,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                            left: 15, bottom: 5, top: 11, right: 15),
                        counterStyle: const TextStyle(color: Colors.white),
                        hintStyle:
                        TextStyle(color: Colors.white.withOpacity(0.9)),
                        hintText: "Сообщение..."),
                    style: const TextStyle(
                      fontSize: 15.5,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                if (_controllerMessage.text.trim().isNotEmpty) {
                  String messageText = _controllerMessage.text;
                  _controllerMessage.clear();
                  if (notification && token != '') {
                    sendFcmMessage('tinder', '$friendName: $messageText', token,
                        'chat', widget.currentId);
                  }
                  final docMessage = FirebaseFirestore.instance
                      .collection('User')
                      .doc(widget.currentId)
                      .collection('messages')
                      .doc(widget.friendId)
                      .collection('chats')
                      .doc();
                  docMessage
                      .set(({
                    "senderId": widget.currentId,
                    "idDoc": docMessage.id,
                    "receiverId": widget.friendId,
                    "message": messageText,
                    "date": DateTime.now(),
                  }))
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.currentId)
                        .collection('messages')
                        .doc(widget.friendId)
                        .set({
                      'last_msg': messageText,
                      'date': DateTime.now(),
                      'writeLastData': '',
                      'last_date_open_chat': '',
                    });
                  });

                  final docMessageFriend = FirebaseFirestore.instance
                      .collection('User')
                      .doc(widget.friendId)
                      .collection('messages')
                      .doc(widget.currentId)
                      .collection("chats")
                      .doc();

                  docMessageFriend.set({
                    "idDoc": docMessageFriend.id,
                    "senderId": widget.currentId,
                    "receiverId": widget.friendId,
                    "message": messageText,
                    "date": DateTime.now(),
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.friendId)
                        .collection('messages')
                        .doc(widget.currentId)
                        .set({
                      "last_msg": messageText,
                      'date': DateTime.now(),
                      'writeLastData': '',
                      'last_date_open_chat': '',
                    });
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(0),
                child: Image.asset(
                  'images/ic_send.png',
                  height: 34,
                  width: 34,
                ),
              ),
            ),
          ],
        ));
  }
}
