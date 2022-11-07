import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/config/const.dart';

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
