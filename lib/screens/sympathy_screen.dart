import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/that_user_screen.dart';

import 'data/const.dart';
import 'data/model/sympathy_model.dart';
import 'data/model/user_model.dart';
import 'home_manager.dart';

class SympathyScreen extends StatefulWidget {
  const SympathyScreen({Key? key}) : super(key: key);

  @override
  State<SympathyScreen> createState() => _SympathyScreenState();
}

class _SympathyScreenState extends State<SympathyScreen> {
  bool isLike = false, isLikeButton = false, isLook = false, isLoading = false;
  List<SympathyModel> listSympathy = [];

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('Sympathy')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Like')
        .get()
        .then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        Map<String, dynamic> data = result.data();

        setState(() {
          listSympathy.add(SympathyModel(
              name: data['name'],
              uid: data['uid'],
              city: data['city'],
              uri: data['image_uri'],
              age: data['age'],
              time: data['time'],
              id_doc: data['id_doc']));
        });
      }
    });
    setState(() {
      isLoading = true;
    });
  }

  Future<void> deleteSympathy(String id) async {
    final docUser = FirebaseFirestore.instance
        .collection("Sympathy")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('Like');
    docUser.doc(id).delete().then((value) {
      Navigator.pushReplacement(
          context,
          FadeRouteAnimation(
            HomeMain(currentIndex: 1),
          ));
    });
  }

  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget cardSympathy(SympathyModel sympathyModel) {
      double width = MediaQuery.of(context).size.width;
      return Container(
        height: width / 2.3,
        width: width,
        padding: EdgeInsets.only(
            left: width / 20, top: 0, right: width / 20, bottom: width / 20),
        child: Card(
          color: color_data_input,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white10,
              )),
          elevation: 14,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
            ),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(
                    context,
                    FadeRouteAnimation(ProfileScreen(
                      userModel: UserModel(
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
                          ageInt: 0),
                      isBack: true,
                      idUser: sympathyModel.uid,
                    )));
              },
              child: Padding(
                padding: EdgeInsets.all(width / 50),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Card(
                      shadowColor: Colors.white38,
                      color: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: const BorderSide(
                            width: 0.8,
                            color: Colors.white30,
                          )),
                      elevation: 10,
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (context, url, progress) =>
                            Center(
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
                        imageUrl: sympathyModel.uri,
                        imageBuilder: (context, imageProvider) => Container(
                          height: 110,
                          width: 110,
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(14)),
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width / 40),
                    SizedBox(
                      width: width / 2.05,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text:
                                          '${sympathyModel.name}, ${sympathyModel.age}',
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: width / 30,
                                            letterSpacing: .5),
                                      ),
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      text: sympathyModel.city,
                                      style: GoogleFonts.lato(
                                        textStyle: TextStyle(
                                            color: Colors.white.withOpacity(.8),
                                            fontSize: width / 40,
                                            letterSpacing: .5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 38),
                                alignment: Alignment.topRight,
                                child: Row(
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text:
                                            '${getDataTimeDate(sympathyModel.time).day} ${months[getDataTimeDate(sympathyModel.time).month]}',
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(.8),
                                              fontSize: width / 40,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteSympathy(listSympathy[0].id_doc);
                                      },
                                      icon: const Icon(Icons.close, size: 20),
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            // padding: const EdgeInsets.only(bottom: 20),
                            height: 40,
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Colors.blueAccent,
                                  Colors.purpleAccent,
                                  Colors.orangeAccent
                                ]),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (context) => ThatUserScreen(
                                            friendId: sympathyModel.uid,
                                            friendName: sympathyModel.name,
                                            friendImage: sympathyModel.uri,
                                          )));
                                },
                                style: ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                ),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Написать',
                                    style: GoogleFonts.lato(
                                      textStyle: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          letterSpacing: .1),
                                    ),
                                  ),
                                ),
                              ),
                            ),
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

    if (isLoading) {
      return Scaffold(
          backgroundColor: color_data_input,
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: RichText(
                    text: TextSpan(
                      text: 'Симпатии',
                      style: GoogleFonts.lato(
                        textStyle: TextStyle(
                            color: Colors.white.withOpacity(.8),
                            fontSize: 20,
                            letterSpacing: .5),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: AnimationLimiter(
                    child: ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: listSympathy.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return AnimationConfiguration.staggeredList(
                              position: index,
                              delay: const Duration(milliseconds: 600),
                              child: SlideAnimation(
                                  duration: const Duration(milliseconds: 2200),
                                  verticalOffset: 200,
                                  curve: Curves.ease,
                                  child: FadeInAnimation(
                                      curve: Curves.easeOut,
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      child:
                                          cardSympathy(listSympathy[index]))));
                        }),
                  ),
                ),
              ],
            ),
          ));
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
