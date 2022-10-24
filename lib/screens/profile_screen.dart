import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/settings/edit_profile_screen.dart';
import 'package:tinder/screens/settings/settiongs_profile_screen.dart';

import 'data/const.dart';
import 'data/model/story_model.dart';
import 'data/model/user_model.dart';
import 'data/widget/component_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
  bool isLoading = false;
  late UserModel userModel;
  List<String> images = [
    'https://top10a.ru/wp-content/uploads/2019/09/8-5.png',
    'https://img1.goodfon.ru/wallpaper/nbig/d/6a/miranda-kerr-victoria-s-1712.jpg',
    'https://womanadvice.ru/sites/default/files/ksenia_tr/dautzen_krus_4.jpg',
    'https://w-dog.ru/wallpapers/4/1/356831463055691/miranda-kerr-devushka-model.jpg',
    'https://wallbox.ru/resize/1920x1080/wallpapers/main2/201726/portret-dlinnye-volosy.jpg',
    'https://i.pinimg.com/originals/b5/24/c0/b524c0f01f7bf29c6dca287d9ff49aec.jpg',
    'https://cdn.ruposters.ru/newsbody/7/7bd7dbb6ee98a243c2ad93d9995c6b42.jpg',
    'https://i.pinimg.com/736x/e0/41/4d/e0414dd00f886d98bc0821a7ebc7db8a.jpg',
    'https://img4.goodfon.ru/original/2048x1365/3/1f/devushka-briunetka-model-vzgliad-3.jpg',
  ];

  List<StoryModel> listStory = [];
  List<StoryModel> listStoryMain = [
    StoryModel(
        name: 'Food',
        id: '',
        uri:
            'https://kartinkin.net/uploads/posts/2021-04/1617236778_6-p-fud-semka-krasivo-6.jpg'),
    StoryModel(
        name: 'Travel',
        id: '',
        uri:
            'https://bestvietnam.ru/wp-content/uploads/2019/11/путешествие-фото.jpg'),
    StoryModel(
        name: 'Музыка',
        id: '',
        uri:
            'https://avatars.mds.yandex.net/i?id=43b2652d080a0dfd3b6ccb446bd2c68a-4304126-images-thumbs&n=13'),
    StoryModel(
        name: 'Спорт',
        id: '',
        uri:
            'https://avatars.mds.yandex.net/i?id=23624d1d3df2d3335fda3c789345d982-5875829-images-thumbs&n=13'),
    StoryModel(
        name: 'Чтение',
        id: '',
        uri:
            'https://avatars.dzeninfra.ru/get-zen_doc/3994559/pub_6050de494b89d64ade72bfb2_6050e1401b3d754b771ce38e/scale_1200'),
  ];

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        userModel = UserModel(
            name: data['name'],
            uid: data['uid'],
            age: data['myAge'],
            userPol: data['myPol'],
            searchPol: data['searchPol'],
            searchRangeStart: data['rangeStart'],
            userInterests: List<String>.from(data['listInterests']),
            userImagePath: List<String>.from(data['listImagePath']),
            userImageUrl: List<String>.from(data['listImageUri']),
            searchRangeEnd: data['rangeEnd'],
            myCity: data['myCity']);
      });
    });

    userModel.userInterests.forEach((elementMain) {
      listStoryMain.forEach((element) {
        if (elementMain == element.name) {
          listStory.add(element);
        }
      });
    });

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
    var size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_data_input,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              SizedBox(
                height: 220,
                width: size.width,
                child: Image.asset('images/ic_road.jpg', fit: BoxFit.cover),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10, top: 38),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20, top: 38),
                    child: Positioned(
                      child: IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              FadeRouteAnimation(const ProfileSettingScreen()));
                        },
                        icon: const Icon(
                          Icons.settings_sharp,
                          size: 22,
                        ),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 200),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                          color: color_data_input,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: [
                              Container(
                                transform:
                                    Matrix4.translationValues(26, -42, 0),
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: SizedBox(
                                      height: 24,
                                      width: 24,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 0.8,
                                        value: progress.progress,
                                      ),
                                    ),
                                  ),
                                  imageUrl: userModel.userImageUrl[0],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 90,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 80),
                            transform: Matrix4.translationValues(0, -22, 0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            '${userModel.name}, ${DateTime.now().year - getDataTimeDate(userModel.age).year}',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(1),
                                              fontSize: 16,
                                              letterSpacing: .8),
                                        ),
                                      ),
                                    ),
                                    IntrinsicHeight(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              text: userModel.myCity,
                                              style: GoogleFonts.lato(
                                                textStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.8),
                                                    fontSize: 11.5,
                                                    letterSpacing: .5),
                                              ),
                                            ),
                                          ),
                                          // VerticalDivider(
                                          //   width: 10,
                                          //   indent: 1,
                                          //   color:
                                          //       Colors.white.withOpacity(0.8),
                                          //   thickness: 1,
                                          // ),
                                          // RichText(
                                          //   text: TextSpan(
                                          //     text: 'Программист',
                                          //     style: GoogleFonts.lato(
                                          //       textStyle: TextStyle(
                                          //           color: Colors.white
                                          //               .withOpacity(0.8),
                                          //           fontSize: 11.5,
                                          //           letterSpacing: .5),
                                          //     ),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(colors: [
                                        Colors.blueAccent,
                                        Colors.purpleAccent
                                      ]),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            FadeRouteAnimation(
                                                EditProfileScreen(
                                              isFirst: false,
                                            )));
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Изменить',
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.5,
                                                letterSpacing: .5),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 20, right: 48),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: userModel.userImageUrl.length
                                            .toString(),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 14.5,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Фото',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
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
                                    RichText(
                                      text: TextSpan(
                                        text: 23.toString(),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 14.5,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Лайки',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
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
                                    RichText(
                                      text: TextSpan(
                                        text: 23.toString(),
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.9),
                                              fontSize: 14.5,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: 'Лайки',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.7),
                                              fontSize: 11,
                                              letterSpacing: .1),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          slideStory(listStory),
                          photoProfile(userModel.userImageUrl),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
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
