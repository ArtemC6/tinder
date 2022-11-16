import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
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
            errorWidget: (context, url, error) => const Icon(Icons.error),
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
  UserModel userModelCurrent;
  var friend, date;

  itemUser(
      {Key? key,
      required this.friendId,
      this.friend,
      required this.lastMessage,
      this.date,
      required this.userModelCurrent})
      : super(key: key);

  @override
  State<itemUser> createState() =>
      _itemUserState(friendId, friend, lastMessage, date, userModelCurrent);
}

class _itemUserState extends State<itemUser> {
  String friendId, lastMessage;
  UserModel userModelCurrent;
  var friend, date;

  _itemUserState(this.friendId, this.friend, this.lastMessage, this.date,
      this.userModelCurrent);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      onLongPress: () {
        showAlertDialogDeleteChat(context, friendId, friend['name'], false);
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
                Navigator.push(
                    context,
                    FadeRouteAnimation(ChatUserScreen(
                      friendId: friendId,
                      friendName: friend['name'],
                      friendImage: friend['listImageUri'][0],
                      userModelCurrent: userModelCurrent,
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

CustomScrollView cardLoadingWidget(
    Size size, double heightCard, double heightAvatar) {
  return CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(alignment: Alignment.centerLeft, children: [
                      CardLoading(
                        cardLoadingTheme: CardLoadingTheme(
                            colorTwo: color_black_88,
                            colorOne: Colors.white.withOpacity(0.10)),
                        height: size.height * heightCard,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      Positioned(
                        left: 22,
                        child: CardLoading(
                          cardLoadingTheme: CardLoadingTheme(
                              colorTwo: color_black_88,
                              colorOne: Colors.white.withOpacity(0.14)),
                          height: size.height * heightAvatar,
                          width: size.height * heightAvatar,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          margin: const EdgeInsets.only(bottom: 10),
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CardLoading(
                            cardLoadingTheme: CardLoadingTheme(
                                colorTwo: color_black_88,
                                colorOne: Colors.white.withOpacity(0.10)),
                            height: 30,
                            width: 200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 1,
                          child: CardLoading(
                            cardLoadingTheme: CardLoadingTheme(
                                colorTwo: color_black_88,
                                colorOne: Colors.white.withOpacity(0.10)),
                            height: 30,
                            width: 200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: 10,
          ),
        ),
      ),
    ],
  );
}

Widget cardLoading(Size size, double radius) {
  return CardLoading(
    cardLoadingTheme: CardLoadingTheme(
        colorTwo: color_black_88, colorOne: Colors.white.withOpacity(0.12)),
    height: size.height,
    width: size.width,
    borderRadius: BorderRadius.circular(radius),
  );
}

Stack imagePhotoChat(String friendImage, String friendId) {
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
          errorWidget: (context, url, error) => const Icon(Icons.error),
          progressIndicatorBuilder: (context, url, progress) => Center(
            child: SizedBox(
              height: 44,
              width: 44,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 0.8,
                value: progress.progress,
              ),
            ),
          ),
          imageUrl: friendImage,
          imageBuilder: (context, imageProvider) => Container(
            height: 44,
            width: 44,
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
      SizedBox(
        height: 22,
        width: 22,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('User')
              .doc(friendId)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
            return customIconButton(
              padding: 0,
              width: 22,
              height: 22,
              path: 'images/ic_green_dot.png',
              onTap: () {},
            );
          },
        ),
      ),
    ],
  );
}
