import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:tinder/model/user_model.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../widget/card_widget.dart';
import '../widget/component_widget.dart';

class ViewLikesScreen extends StatefulWidget {
  final UserModel userModelCurrent;

  const ViewLikesScreen({Key? key, required this.userModelCurrent})
      : super(key: key);

  @override
  State<ViewLikesScreen> createState() =>
      _ViewLikesScreenState(userModelCurrent);
}

class _ViewLikesScreenState extends State<ViewLikesScreen> {
  final UserModel userModelCurrent;

  _ViewLikesScreenState(this.userModelCurrent);

  List<UserModel> listUser = [];
  List<String> listLike = [];
  bool isLoading = false, isLoadingNewUser = true;
  final scrollController = ScrollController();
  int limit = 0;

  Future readFirebase(int limit, isReadLike) async {
    listUser.clear();
    if (isReadLike) {
      await readLikeFirebase(userModelCurrent.uid).then((list) {
        setState(() {
          listLike.addAll(list);
        });
      });
    }

    FirebaseFirestore.instance
        .collection('User')
        .limit(limit)
        .get()
        .then((QuerySnapshot querySnapshot) {
      for (var document in querySnapshot.docs) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        bool isLike = false;
        Future.forEach(listLike, (idUser) {
          if (idUser == data['uid']) {
            isLike = true;
          }
        }).then((value) async {
          if (isLike) {
            setState(() {
              listUser.add(UserModel(
                  name: data['name'],
                  uid: data['uid'],
                  ageTime: data['ageTime'],
                  userPol: data['myPol'],
                  searchPol: data['searchPol'],
                  searchRangeStart: data['rangeStart'],
                  userInterests: List<String>.from(data['listInterests']),
                  userImagePath: List<String>.from(data['listImagePath']),
                  userImageUrl: List<String>.from(data['listImageUri']),
                  searchRangeEnd: data['rangeEnd'],
                  myCity: data['myCity'],
                  imageBackground: data['imageBackground'],
                  ageInt: data['ageInt'],
                  state: data['state']));
              if (listLike.length == listUser.length) {
                isLoadingNewUser = false;
              }
            });
          }
        });
      }
    }).then((value) {
      setState(() {
        isLoading = true;
      });
    });
  }

  @override
  void initState() {
    readFirebase(limit = 8, true);
    scrollController.addListener(() {
      if (scrollController.position.maxScrollExtent == scrollController.offset) {
        readFirebase(limit + 5, false);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
          backgroundColor: color_black_88,
          body: SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  topPanel(
                    context,
                    'Отметки \'Нравится\'',
                    Icons.favorite_outlined,
                    Colors.red,
                    true,
                  ),
                  AnimationLimiter(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listUser.length + 1,
                      itemBuilder: (context, index) {
                        if (index < listUser.length) {
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            delay: const Duration(milliseconds: 300),
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 1300),
                              verticalOffset: 200,
                              curve: Curves.ease,
                              child: FadeInAnimation(
                                curve: Curves.easeOut,
                                duration: const Duration(milliseconds: 2000),
                                child: itemUserLike(
                                    listUser[index], userModelCurrent),
                              ),
                            ),
                          );
                        } else {
                          if (isLoadingNewUser) {
                            return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 30),
                              child: Center(
                                child: SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 0.8,
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return const SizedBox();
                          }
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ));
    }

    return Scaffold(
        backgroundColor: color_black_88,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardLoadingWidget(size, .12, .07),
        ));
  }
}
