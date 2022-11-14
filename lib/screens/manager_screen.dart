import 'package:flutter/material.dart';
import 'package:tinder/screens/home_screen.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/sympathy_screen.dart';
import 'package:tinder/screens/that_screen.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
import '../widget/animation_widget.dart';

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

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    readUserFirebase().then((user) {
      setState(() {
        userModelCurrent = UserModel(
            name: user.name,
            uid: user.uid,
            ageTime: user.ageTime,
            userPol: user.userPol,
            searchPol: user.searchPol,
            searchRangeStart: user.searchRangeStart,
            userInterests: user.userInterests,
            userImagePath: user.userImagePath,
            userImageUrl: user.userImageUrl,
            searchRangeEnd: user.searchRangeEnd,
            myCity: user.myCity,
            imageBackground: user.imageBackground,
            ageInt: user.ageInt,
            state: user.state);
      });
      isLoading = true;
    });
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
    SizedBox bottomNavigationBar(Size size) {
      return SizedBox(
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
      );
    }

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
          child = ChatScreen(
            userModelCurrent: userModelCurrent,
          );
          break;
        case 3:
          child = ProfileScreen(
            userModelPartner: userModelCurrent,
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
          backgroundColor: color_black_88,
          bottomNavigationBar: bottomNavigationBar(size),
          body: SizedBox.expand(child: childEmployee()));
    }

    return const loadingCustom();
  }
}
