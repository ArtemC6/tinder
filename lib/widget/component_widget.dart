import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/config/firestore_operations.dart';

import '../../config/const.dart';
import '../../model/interests_model.dart';
import '../../model/user_model.dart';
import '../screens/settings/edit_profile_screen.dart';
import 'animation_widget.dart';
import 'button_widget.dart';

class slideInterests extends StatelessWidget {
  List<InterestsModel> listStory = [];

  slideInterests(this.listStory, {super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          height: size.height * .13,
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

class photoProfile extends StatelessWidget {
  List<String> listPhoto = [];

  photoProfile(this.listPhoto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 26, top: 20, bottom: 18),
          child: RichText(
            text: TextSpan(
              text: 'Фото',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
            height: 380,
            child: AnimationLimiter(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 18, right: 18),
                crossAxisCount: 3,
                children: List.generate(
                  listPhoto.length,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 2200),
                      columnCount: 3,
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 2200),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5, left: 5, right: 5, top: 5),
                            child: Card(
                              shadowColor: Colors.white30,
                              color: color_black_88,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    width: 0.6,
                                    color: Colors.white30,
                                  )),
                              elevation: 6,
                              child: CachedNetworkImage(
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    color: color_black_88,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(14)),
                                    image: DecorationImage(
                                      image: imageProvider,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                    ),
                                progressIndicatorBuilder:
                                    (context, url, progress) => Center(
                                  child: SizedBox(
                                    height: 26,
                                    width: 26,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 0.8,
                                      value: progress.progress,
                                    ),
                                  ),
                                ),
                                imageUrl: listPhoto[index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}

class photoProfileSettings extends StatelessWidget {
  UserModel userModel;

  photoProfileSettings(this.userModel, {super.key});

  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 26, top: 20, bottom: 18),
          child: RichText(
            text: TextSpan(
              text: 'Фото',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
            height: 380,
            child: AnimationLimiter(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 18, right: 18, top: 0),
                crossAxisCount: 3,
                children: List.generate(
                  9,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 2200),
                      columnCount: 3,
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 2200),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 5, left: 5, right: 5, top: 5),
                            child: Card(
                              shadowColor: Colors.white30,
                              color: color_black_88,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: const BorderSide(
                                    width: 0.8,
                                    color: Colors.white38,
                                  )),
                              elevation: 6,
                              child: Stack(
                                alignment: Alignment.bottomRight,
                                children: [
                                  if (userModel.userImageUrl.length > index)
                                    CachedNetworkImage(
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(14)),
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover),
                                        ),
                                      ),
                                      progressIndicatorBuilder:
                                          (context, url, progress) => Center(
                                        child: SizedBox(
                                          height: 26,
                                          width: 26,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 0.8,
                                            value: progress.progress,
                                          ),
                                        ),
                                      ),
                                      imageUrl: userModel.userImageUrl[index],
                                    ),
                                  if (0 == index)
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        uploadImage(context, userModel, false);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Image.asset(
                                          'images/edit_icon.png',
                                          height: 22,
                                          width: 22,
                                        ),
                                      ),
                                    ),
                                  if (userModel.userImageUrl.length > index &&
                                      index != 0)
                                    customIconButton(
                                        padding: 2,
                                        width: 25,
                                        height: 25,
                                        path: 'images/ic_remove.png',
                                        onTap: () {
                                          imageRemove(
                                              index, context, userModel);
                                        }),
                                  if (userModel.userImageUrl.length <= index &&
                                      userModel.userImageUrl.isNotEmpty)
                                    customIconButton(
                                        padding: 6,
                                        width: 21,
                                        height: 21,
                                        path: 'images/ic_add.png',
                                        onTap: () {
                                          uploadImageAdd(context, userModel);
                                        }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
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
          Column(
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

class ColorTest extends StatefulWidget {
  double color;

  ColorTest({super.key, required this.color});

  @override
  _ColorTest createState() => _ColorTest(color);
}

class _ColorTest extends State<ColorTest> {
  double color;

  _ColorTest(this.color);

  @override
  Widget build(
    BuildContext context,
  ) {
    print(color);

    return new Container(
      width: 100,
      height: 100,
      color: Colors.red.withOpacity(color), // its red
    );
  }
}
