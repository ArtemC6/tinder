import 'package:flutter/material.dart';
import 'package:tinder/screens/home_screen.dart';
import 'package:tinder/screens/profile_screen.dart';
import 'package:tinder/screens/sympathy_screen.dart';
import 'package:tinder/screens/that_screen.dart';
import 'data/const.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({Key? key}) : super(key: key);

  @override
  _HomeMain createState() => _HomeMain();
}

class _HomeMain extends State<HomeMain> {
  var currentIndex = 0;

  Widget childEmployee() {
    var child;
    switch (currentIndex) {
      case 0:
        child =  HomeScreen();
        break;
      case 1:
        child = const SympathyScreen();
        break;
      case 2:
        child = const ThatScreen();
        break;
      case 3:
        child = ProfileScreen();
        break;
    }
    return child;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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

  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.messenger_outline,
    Icons.person_rounded,
  ];

}
