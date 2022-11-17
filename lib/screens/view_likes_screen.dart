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
  bool isLoading = false;

  Future readFirebase() async {
    await readLikeFirebase(userModelCurrent.uid).then((list) {
      setState(() {
        listLike.addAll(list);
      });
    });

    print(listLike.length);
    await FirebaseFirestore.instance
        .collection('User')
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
            });
          }
        });
      }
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
    Size size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_black_88,
        body: SafeArea(
            child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(children: [
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
                scrollDirection: Axis.vertical,
                itemCount: listLike.length,
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
                        duration: const Duration(milliseconds: 2500),
                        child: itemUserLike(listUser[index], userModelCurrent),
                      ),
                    ),
                  );
                },
              ),
            )
          ]),
        )),
      );
    }

    return Scaffold(
        backgroundColor: color_black_88,
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: cardLoadingWidget(size, .12, .07),
        ));
  }
}
