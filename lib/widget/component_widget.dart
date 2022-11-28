import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/const.dart';
import '../../model/interests_model.dart';
import '../../model/user_model.dart';
import '../screens/profile_screen.dart';
import '../screens/settings/edit_profile_screen.dart';
import '../screens/view_likes_screen.dart';
import 'animation_widget.dart';
import 'button_widget.dart';
import 'card_widget.dart';
import 'dialog_widget.dart';

class slideInterests extends StatelessWidget {
  List<InterestsModel> listStory = [];

  slideInterests(this.listStory, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(22),
          child: RichText(
            text: TextSpan(
              text: 'Интересы',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: AnimationLimiter(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 8,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 1500),
                      horizontalOffset: 160,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 2000),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(left: 22, right: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                if (listStory.length > index)
                                  Card(
                                    shadowColor: Colors.white30,
                                    color: color_black_88,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(100),
                                        side: const BorderSide(
                                          width: 0.5,
                                          color: Colors.white30,
                                        )),
                                    elevation: 4,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          height: 68,
                                          width: 68,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(100)),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: SizedBox(
                                            height: 68,
                                            width: 68,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 1,
                                              value: progress.progress,
                                            ),
                                          ),
                                            ),
                                        imageUrl: listStory[index].uri,
                                        fit: BoxFit.cover,
                                        // height: 166,
                                        // width: MediaQuery.of(context).size.width
                                      ),
                                    ),
                                  ),
                                if (listStory.length > index)
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4, top: 3),
                                    child: RichText(
                                      text: TextSpan(
                                        text: listStory[index].name,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                              Colors.white.withOpacity(0.8),
                                              fontSize: 10,
                                              letterSpacing: .9),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class slideInterestsSettings extends StatelessWidget {
  List<InterestsModel> listStory = [];

  late UserModel userModel;

  slideInterestsSettings(this.listStory, this.userModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(22),
          child: RichText(
            text: TextSpan(
              text: 'Интересы',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 11,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 100,
          child: AnimationLimiter(
            child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(right: 20),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    delay: const Duration(milliseconds: 400),
                    child: SlideAnimation(
                      duration: const Duration(milliseconds: 1500),
                      horizontalOffset: 160,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 2000),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () {},
                          child: Container(
                            margin: const EdgeInsets.only(
                              left: 18,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Card(
                                  shadowColor: Colors.white30,
                                  color: color_black_88,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: const BorderSide(
                                        width: 0.8,
                                        color: Colors.white30,
                                      )),
                                  elevation: 4,
                                  child: Stack(
                                    alignment: Alignment.bottomRight,
                                    children: [
                                      if (listStory.length > index)
                                        ClipRRect(
                                          borderRadius:
                                          BorderRadius.circular(100),
                                          child: CachedNetworkImage(
                                            errorWidget:
                                                (context, url, error) =>
                                            const Icon(Icons.error),
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              height: 70,
                                              width: 70,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(100)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    Center(
                                              child: SizedBox(
                                                height: 68,
                                                width: 68,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 1,
                                                  value: progress.progress,
                                                ),
                                              ),
                                            ),
                                            imageUrl: listStory[index].uri,
                                            fit: BoxFit.cover,
                                            // height: 166,
                                            // width: MediaQuery.of(context).size.width
                                          ),
                                        ),
                                      if (0 == index)
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                FadeRouteAnimation(
                                                    EditProfileScreen(
                                                      isFirst: false,
                                                      userModel: userModel,
                                                    )));
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Image.asset(
                                              'images/edit_icon.png',
                                              height: 20,
                                              width: 20,
                                            ),
                                          ),
                                        ),
                                      if (listStory.length > index &&
                                          index != 0)
                                        customIconButton(
                                            padding: 1,
                                            width: 23,
                                            height: 23,
                                            path: 'images/ic_remove.png',
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  FadeRouteAnimation(
                                                      EditProfileScreen(
                                                        isFirst: false,
                                                        userModel: userModel,
                                                      )));
                                            }),
                                      if (listStory.length <= index &&
                                          listStory.isNotEmpty)
                                        customIconButton(
                                            padding: 6,
                                            width: 21,
                                            height: 21,
                                            path: 'images/ic_add.png',
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  FadeRouteAnimation(
                                                      EditProfileScreen(
                                                        isFirst: false,
                                                        userModel: userModel,
                                                      )));
                                            }),
                                    ],
                                  ),
                                ),
                                if (listStory.length > index)
                                  Container(
                                    padding: const EdgeInsets.only(
                                        left: 8, right: 4, top: 3),
                                    child: RichText(
                                      text: TextSpan(
                                        text: listStory[index].name,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                              Colors.white.withOpacity(0.8),
                                              fontSize: 10,
                                              letterSpacing: .9),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ),
      ],
    );
  }
}

class infoPanelWidget extends StatelessWidget {
  UserModel userModel;

  infoPanelWidget({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 20, right: 48),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideFadeTransition(
                delayStart: const Duration(milliseconds: 50),
                animationDuration: const Duration(milliseconds: 1000),
                child: RichText(
                  text: TextSpan(
                    text: userModel.userImageUrl.length.toString(),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.5,
                          letterSpacing: .5),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Фото',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                        letterSpacing: .1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 24,
            child: VerticalDivider(
              endIndent: 4,
              color: Colors.white.withOpacity(0.7),
              thickness: 1,
            ),
          ),
          InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () {
              Navigator.push(
                  context,
                  FadeRouteAnimation(ViewLikesScreen(
                    userModelCurrent: userModel,
                  )));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('User')
                      .doc(userModel.uid)
                      .collection('likes')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return SlideFadeTransition(
                          delayStart: const Duration(milliseconds: 50),
                          animationDuration: const Duration(milliseconds: 1000),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder: ((child, animation) {
                              return ScaleTransition(
                                  scale: animation, child: child);
                            }),
                            child: RichText(
                              key: ValueKey<int>(snapshot.data!.size),
                              text: TextSpan(
                                text: snapshot.data!.size.toString(),
                                style: GoogleFonts.lato(
                                  textStyle: TextStyle(
                                      color: Colors.white.withOpacity(0.9),
                                      fontSize: 14.5,
                                      letterSpacing: .5),
                                ),
                              ),
                            ),
                          ));
                    }
                    return const SizedBox();
                  },
                ),
                RichText(
                  text: TextSpan(
                    text: 'Лайки',
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 11,
                          letterSpacing: .1),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 24,
            child: VerticalDivider(
              endIndent: 4,
              color: Colors.white.withOpacity(0.7),
              thickness: 1,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SlideFadeTransition(
                delayStart: const Duration(milliseconds: 50),
                animationDuration: const Duration(milliseconds: 1300),
                child: RichText(
                  text: TextSpan(
                    text: userModel.userInterests.length.toString(),
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 14.5,
                          letterSpacing: .5),
                    ),
                  ),
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Интересы',
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.white.withOpacity(0.7),
                        fontSize: 11,
                        letterSpacing: .1),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Padding topPanel(BuildContext context, String text, IconData icon,
    Color color, bool isBack) {
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if (isBack)
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: Colors.white, size: 18),
          ),
        RichText(
          text: TextSpan(
            text: text,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, letterSpacing: .4),
          ),
        ),
        Container(
          height: 25,
          width: 25,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(99)),
          child: Icon(
            icon,
            color: Colors.white,
            size: 17,
          ),
        ),
      ],
    ),
  );
}

class topPanelChat extends StatefulWidget {
  String friendId, friendImage, friendName;
  UserModel userModelCurrent;

  topPanelChat({Key? key,
    required this.friendId,
    required this.friendImage,
    required this.friendName,
    required this.userModelCurrent})
      : super(key: key);

  @override
  State<topPanelChat> createState() =>
      _topPanelChatState(friendId, friendImage, friendName, userModelCurrent);
}

class _topPanelChatState extends State<topPanelChat> {
  String friendId, friendImage, friendName;
  UserModel userModelCurrent;

  _topPanelChatState(this.friendId, this.friendImage, this.friendName, this.userModelCurrent);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('User')
          .doc(friendId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('User')
              .doc(userModelCurrent.uid)
              .collection('messages')
              .doc(friendId)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && asyncSnapshot.hasData) {
              var isWriteUser = false;
              try {
                if (snapshot.data['writeLastData'] != '') {
                  if (DateTime.now()
                          .difference(
                              getDataTime(snapshot.data['writeLastData']))
                          .inSeconds <
                      4) {
                    getState(4500).then((value) {
                      setState(() {
                        isWriteUser = value;
                      });
                    });
                    isWriteUser = true;
                  }
                }
              } catch (error) {}
              return Row(
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
                            left: 22, top: 8, bottom: 0, right: 4),
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
                              Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  photoUser(
                                    uri: friendImage,
                                    width: 43,
                                    height: 43,
                                    state: 'offline',
                                    padding: 0,
                                  ),
                                  if (asyncSnapshot.data['state'] != 'offline')
                                    SlideFadeTransition(
                                      animationDuration:
                                          const Duration(milliseconds: 550),
                                      child: customIconButton(
                                        padding: 0,
                                        width: 22,
                                        height: 22,
                                        path: 'images/ic_green_dot.png',
                                        onTap: () {},
                                      ),
                                    ),
                                ],
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
                                                  fontSize: 13.5,
                                                  letterSpacing: .5),
                                            ),
                                          ),
                                        ),
                                        if (asyncSnapshot.data['state'] ==
                                                'offline' &&
                                            !isWriteUser)
                                          animatedText(
                                              10.0,
                                              'был(а) ${filterDate(asyncSnapshot.data['lastDateOnline'])}',
                                              Colors.white.withOpacity(.5),
                                              550,
                                              1),
                                        if (asyncSnapshot.data['state'] !=
                                                'offline' &&
                                            !isWriteUser)
                                          animatedText(10.5, 'в сети',
                                              Colors.green, 550, 1),
                                        if (isWriteUser) showProgressWrite()
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
                  PopupMenuButton<int>(
                    color: Colors.white.withOpacity(0.07),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(16),
                      ),
                    ),
                    onSelected: (value) {
                      if (value == 0) {
                        showAlertDialogDeleteChat(
                            context, friendId, friendName, true, friendImage);
                      }
                    },
                    itemBuilder: (BuildContext context) {
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
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        );
      },
    );
  }
}

