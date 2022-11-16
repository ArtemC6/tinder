import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/const.dart';

class MessagesItem extends StatelessWidget {
  final String message;
  final bool isUserMassage;
  DateTime dataMessage;

  MessagesItem(this.message, this.isUserMassage, this.dataMessage, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            textDirection:
                isUserMassage ? TextDirection.rtl : TextDirection.ltr,
            children: <Widget>[
              Column(
                crossAxisAlignment: isUserMassage
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: MediaQuery.of(context).size.width * .75,
                    child: Align(
                      alignment: isUserMassage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        decoration: isUserMassage
                            ? BoxDecoration(
                                color: Colors.deepPurpleAccent.withOpacity(.72),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white10, width: 0.9))
                            : BoxDecoration(
                                color: Colors.white.withOpacity(.02),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.white10, width: 0.9)),
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(
                                text: message.length < 10
                                    ? '$message              '
                                    : message,
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
                                text:
                                    '${dataMessage.hour}: ${dataMessage.minute}',
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
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }
}

class MessageTextField extends StatefulWidget {
  final String currentId;
  final String friendId;

  const MessageTextField(this.currentId, this.friendId, {super.key});

  @override

  _MessageTextFieldState createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
  final TextEditingController _controllerMessage = TextEditingController();

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
                  // Colors.,
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
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(300),
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
                if (_controllerMessage.text.isNotEmpty) {
                  String message = _controllerMessage.text;
                  _controllerMessage.clear();
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
                    "message": message,
                    "type": "text",
                    "date": DateTime.now(),
                  }))
                      .then((value) {
                    FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.currentId)
                        .collection('messages')
                        .doc(widget.friendId)
                        .set({
                      'last_msg': message,
                      'date': DateTime.now(),
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
                    "message": message,
                    "type": "text",
                    "date": DateTime.now(),
                  }).then((value) {
                    FirebaseFirestore.instance
                        .collection('User')
                        .doc(widget.friendId)
                        .collection('messages')
                        .doc(widget.currentId)
                        .set({
                      "last_msg": message,
                      'date': DateTime.now(),
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
