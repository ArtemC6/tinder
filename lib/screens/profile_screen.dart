import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinder/screens/settings/edit_profile_screen.dart';
import 'package:tinder/screens/settings/settiongs_profile_screen.dart';

import 'data/const.dart';
import 'data/model/story_model.dart';
import 'data/widget/component_widget.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileScreen> {
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

  List<StoryModel> listStory = [
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
        name: 'Music',
        id: '',
        uri:
            'https://avatars.mds.yandex.net/i?id=43b2652d080a0dfd3b6ccb446bd2c68a-4304126-images-thumbs&n=13'),
    StoryModel(
        name: 'Sport',
        id: '',
        uri:
            'https://avatars.mds.yandex.net/i?id=23624d1d3df2d3335fda3c789345d982-5875829-images-thumbs&n=13'),
    StoryModel(
        name: 'Books',
        id: '',
        uri:
            'https://avatars.dzeninfra.ru/get-zen_doc/3994559/pub_6050de494b89d64ade72bfb2_6050e1401b3d754b771ce38e/scale_1200'),
  ];

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
                    icon:
                        const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
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
                                imageUrl:
                                    'https://img1.goodfon.ru/wallpaper/nbig/d/6a/miranda-kerr-victoria-s-1712.jpg',
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
                                      text: 'Артем, 18',
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
                                            text: 'Каракол',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 11.5,
                                                  letterSpacing: .5),
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          width: 10,
                                          indent: 1,
                                          color:
                                              Colors.white.withOpacity(0.8),
                                          thickness: 1,
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            text: 'Программист',
                                            style: GoogleFonts.lato(
                                              textStyle: TextStyle(
                                                  color: Colors.white
                                                      .withOpacity(0.8),
                                                  fontSize: 11.5,
                                                  letterSpacing: .5),
                                            ),
                                          ),
                                        ),
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
                                      Navigator.push(context,
                                          FadeRouteAnimation(const EditProfileScreen()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.transparent,
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    child: Text('Изменить'),
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
                                  Text(
                                    '3',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.7),
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
                                  Text(
                                    '43',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Like',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.7),
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
                                  Text(
                                    '3',
                                    style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Photo',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        slideStory(listStory),
                        photoProfile(images),
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
}

// return Scaffold(
// backgroundColor: color_data_input,
// body: Stack(
// children: [
// SizedBox(
// height: 220,
// width: size.width,
// child: Image.asset('images/ic_road.jpg', fit: BoxFit.cover),
// ),
// RefreshIndicator(
// backgroundColor: color_data_input,
// color: Colors.blueAccent,
// onRefresh: () async {
// // Navigator.pushReplacement(context,
// //     MaterialPageRoute(builder: (context) => ProfileScreen()));
// },
// child: SingleChildScrollView(
// physics: const BouncingScrollPhysics(),
// padding: const EdgeInsets.only(top: 200),
// child: Column(
// children: [
// Container(
// alignment: Alignment.topLeft,
// decoration: const BoxDecoration(
// color: color_data_input,
// borderRadius: BorderRadius.only(
// topLeft: Radius.circular(22),
// topRight: Radius.circular(22))),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Row(
// children: [
// Container(
// transform: Matrix4.translationValues(26, -42, 0),
// child: CachedNetworkImage(
// progressIndicatorBuilder:
// (context, url, progress) => Center(
// child: SizedBox(
// height: 24,
// width: 24,
// child: CircularProgressIndicator(
// color: Colors.white,
// strokeWidth: 0.8,
// value: progress.progress,
// ),
// ),
// ),
// imageUrl:
// 'https://img1.goodfon.ru/wallpaper/nbig/d/6a/miranda-kerr-victoria-s-1712.jpg',
// imageBuilder: (context, imageProvider) =>
// Container(
// height: 90,
// width: 90,
// decoration: BoxDecoration(
// borderRadius: const BorderRadius.all(
// Radius.circular(14)),
// image: DecorationImage(
// image: imageProvider,
// fit: BoxFit.cover,
// ),
// ),
// ),
// ),
// ),
// Container(
// transform: Matrix4.translationValues(230, -34, 0),
//
// height: 40,
// width: 40,
// margin: const EdgeInsets.only(right: 20, top: 38),
// // alignment: Alignment.centerRight,
// child: Positioned(
// child: IconButton(
// onPressed: () {
// Navigator.push(
// context,
// FadeRouteAnimation(
// ProfileSettingScreen()));
// },
// icon: Icon(Icons.settings),
// color: Colors.white,
// ),
// ),
// ),
// ],
// ),
// Container(
// padding: const EdgeInsets.only(left: 20, right: 80),
// transform: Matrix4.translationValues(0, -22, 0),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.center,
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// RichText(
// text: TextSpan(
// text: 'Артем, 18',
// style: GoogleFonts.lato(
// textStyle: TextStyle(
// color: Colors.white.withOpacity(1),
// fontSize: 16,
// letterSpacing: .8),
// ),
// ),
// ),
// IntrinsicHeight(
// child: Row(
// crossAxisAlignment:
// CrossAxisAlignment.center,
// children: [
// RichText(
// text: TextSpan(
// text: 'Каракол',
// style: GoogleFonts.lato(
// textStyle: TextStyle(
// color: Colors.white
//     .withOpacity(0.8),
// fontSize: 11.5,
// letterSpacing: .5),
// ),
// ),
// ),
// VerticalDivider(
// width: 10,
// indent: 1,
// color: Colors.white.withOpacity(0.8),
// thickness: 1,
// ),
// RichText(
// text: TextSpan(
// text: 'Программист',
// style: GoogleFonts.lato(
// textStyle: TextStyle(
// color: Colors.white
//     .withOpacity(0.8),
// fontSize: 11.5,
// letterSpacing: .5),
// ),
// ),
// ),
// ],
// ),
// ),
// ],
// ),
// SizedBox(
// height: 40,
// child: DecoratedBox(
// decoration: BoxDecoration(
// gradient: const LinearGradient(colors: [
// Colors.blueAccent,
// Colors.purpleAccent
// ]),
// borderRadius: BorderRadius.circular(20),
// ),
// child: ElevatedButton(
// onPressed: () {},
// style: ElevatedButton.styleFrom(
// shadowColor: Colors.transparent,
// backgroundColor: Colors.transparent,
// shape: RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(20)),
// ),
// child: Text('Написать'),
// ),
// ),
// ),
// ],
// ),
// ),
// Container(
// padding: const EdgeInsets.only(left: 20, right: 48),
// child: Row(
// crossAxisAlignment: CrossAxisAlignment.center,
// mainAxisAlignment: MainAxisAlignment.spaceBetween,
// children: [
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// '3',
// style: TextStyle(
// fontSize: 18,
// color: Colors.white.withOpacity(0.9),
// fontWeight: FontWeight.bold),
// ),
// Text(
// 'Photo',
// style: TextStyle(
// fontSize: 13,
// color: Colors.white.withOpacity(0.7),
// ),
// ),
// ],
// ),
// SizedBox(
// height: 24,
// child: VerticalDivider(
// endIndent: 4,
// color: Colors.white.withOpacity(0.7),
// thickness: 1,
// ),
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// '43',
// style: TextStyle(
// fontSize: 18,
// color: Colors.white.withOpacity(0.9),
// fontWeight: FontWeight.bold),
// ),
// Text(
// 'Like',
// style: TextStyle(
// fontSize: 13,
// color: Colors.white.withOpacity(0.7),
// ),
// ),
// ],
// ),
// SizedBox(
// height: 24,
// child: VerticalDivider(
// endIndent: 4,
// color: Colors.white.withOpacity(0.7),
// thickness: 1,
// ),
// ),
// Column(
// crossAxisAlignment: CrossAxisAlignment.center,
// children: [
// Text(
// '3',
// style: TextStyle(
// fontSize: 18,
// color: Colors.white.withOpacity(0.9),
// fontWeight: FontWeight.bold),
// ),
// Text(
// 'Photo',
// style: TextStyle(
// fontSize: 13,
// color: Colors.white.withOpacity(0.7),
// ),
// ),
// ],
// ),
// ],
// ),
// ),
// slideStory(listStory),
// photoProfile(images),
// ],
// ),
// ),
// ],
// ),
// ),
// )
// ],
// ),
// );
// }
