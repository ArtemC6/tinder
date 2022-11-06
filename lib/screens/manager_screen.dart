import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:tinder/screens/home_screen.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/sympathy_screen.dart';
import 'package:tinder/screens/that_screen.dart';
import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';

class ManagerScreen extends StatefulWidget {
  int currentIndex;

  ManagerScreen({super.key, required this.currentIndex});

  @override
  _ManagerScreen createState() => _ManagerScreen(currentIndex);
}

class _ManagerScreen extends State<ManagerScreen> with WidgetsBindingObserver {
  bool isLoading = false;
  int currentIndex = 0;
  late UserModel userModelCurrent;

  _ManagerScreen(this.currentIndex);

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('User')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .limit(1)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((document) async {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;

        setState(() {
          userModelCurrent = UserModel(
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
              state: data['state']);
        });
      });
    });

    setStateFirebase('online');
    setState(() {
      isLoading = true;
    });
  }

  @override
  void initState() {
    readFirebase();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.addObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.paused:
        setStateFirebase('offline');
        break;
      case AppLifecycleState.resumed:
        setStateFirebase('online');
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Widget childEmployee() {
      var child;
      switch (currentIndex) {
        case 0:
          child = HomeScreen(
            userModelCurrent: userModelCurrent,
          );
          break;
        case 1:
          child = SympathyScreen(
            userModelCurrent: userModelCurrent,
          );
          break;
        case 2:
          child = const ThatScreen();
          break;
        case 3:
          child = ProfileScreen(
            userModel: userModelCurrent,
            isBack: false,
            idUser: '',
            userModelCurrent: userModelCurrent,
          );
          break;
      }
      return child;
    }

    if (isLoading) {
      return Scaffold(
          backgroundColor: color_data_input,
          bottomNavigationBar: SizedBox(
            height: size.width * .150,
            child: ListView.builder(
              itemCount: 4,
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: size.width * .024),
              itemBuilder: (context, index) => InkWell(
                onTap: () {
                  setState(() {
                    currentIndex = index;
                  });
                },
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: size.width * .014),
                    Icon(listOfIcons[index],
                        size: size.width * .076, color: Colors.white),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 1500),
                      curve: Curves.fastLinearToSlowEaseIn,
                      margin: EdgeInsets.only(
                        top: index == currentIndex ? 0 : size.width * .029,
                        right: size.width * .0422,
                        left: size.width * .0422,
                      ),
                      width: size.width * .153,
                      height: index == currentIndex ? size.width * .014 : 0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: SizedBox.expand(child: childEmployee()));
    }
    return Scaffold(
      backgroundColor: color_data_input,
      body: Center(
        child: LoadingAnimationWidget.dotsTriangle(
          size: 44,
          color: Colors.blueAccent,
        ),
      ),
    );
  }
}
