import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../screens/that_user_screen.dart';
import 'button_widget.dart';

class photoUser extends StatelessWidget {
  String uri, state;
  double height, width, padding;

  photoUser(
      {Key? key,
      required this.uri,
      required this.height,
      required this.width,
      required this.padding,
      required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Card(
          shadowColor: Colors.white30,
          color: color_black_88,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white30,
              )),
          elevation: 6,
          child: CachedNetworkImage(
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: SizedBox(
                height: height,
                width: width,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 0.8,
                  value: progress.progress,
                ),
              ),
            ),
            imageUrl: uri,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (state == 'online')
          customIconButton(
              padding: padding,
              width: 27,
              height: 27,
              path: 'images/ic_green_dot.png',
              onTap: () {}),
      ],
    );
  }
}


class itemUser extends StatefulWidget {
  String friendId, lastMessage;
  var friend, date;
  itemUser({Key? key, required this.friendId, this.friend, required this.lastMessage, this.date}) : super(key: key);

  @override
  State<itemUser> createState() => _itemUserState(friendId, friend, lastMessage, date);
}

class _itemUserState extends State<itemUser> {
  String friendId, lastMessage;
  var friend, date;

  _itemUserState(this.friendId, this.friend, this.lastMessage, this.date);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      onLongPress: () {
        showAlertDialogDeleteThat(context, friendId, friend['name'], false);
      },
      child: Container(
        height: width / 3.7,
        width: width,
        padding: EdgeInsets.only(
            left: width / 30, top: 0, right: width / 30, bottom: width / 30),
        child: Card(
          color: color_black_88,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 14,
          child: Container(
            padding:
            const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 10),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ThatUserScreen(
                      friendId: friendId,
                      friendName: friend['name'],
                      friendImage: friend['listImageUri'][0],
                    )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      SizedBox(
                        child: photoUser(
                          uri: friend['listImageUri'][0],
                          width: 58,
                          height: 58,
                          state: friend['state'],
                          padding: 0,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: width / 40),
                  SizedBox(
                    width: width / 1.6,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: friend['name'],
                                style: GoogleFonts.lato(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                            RichText(
                              text: TextSpan(
                                text:
                                '${getDataTimeDate(date).hour}: ${getDataTimeDate(date).minute}',
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white.withOpacity(.4),
                                      fontSize: 10.5,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: width / 1.9,
                              child: RichText(
                                maxLines: 2,
                                text: TextSpan(
                                  text: lastMessage,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(.4),
                                        fontSize: 11,
                                        letterSpacing: .5),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: 16,
                              height: 16,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.deepPurpleAccent),
                              child: RichText(
                                text: TextSpan(
                                  text: '1',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        letterSpacing: .0),
                                  ),
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
        ),
      ),
    );
  }
}
//
// Widget itemUser(friend, friendId, lastMessage, date) {
//   return
// }
