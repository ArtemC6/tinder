import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:tinder/screens/auth/signin_screen.dart';

import '../data/const.dart';
import '../data/firebase_auth.dart';
import '../widget/component_widget.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreen createState() => _SignUpScreen();
}

class _SignUpScreen extends State<SignUpScreen> with TickerProviderStateMixin {
  late AnimationController controller1;
  late AnimationController controller2;
  late Animation<double> animation1;
  late Animation<double> animation2;
  late Animation<double> animation3;
  late Animation<double> animation4;

  String _email = "", _password = "", _name = "";
  bool _isHidden = true;

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });

    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );

    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(const Duration(milliseconds: 1500), () {
      controller1.forward();
    });

    controller2.forward();
  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: color_auth,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
          child: SizedBox(
            height: size.height,
            child: Stack(
              children: [
                Positioned(
                  top: size.height * (animation2.value + .58),
                  left: size.width * .21,
                  child: CustomPaint(
                    painter: MyPainter(50),
                  ),
                ),
                Positioned(
                  top: size.height * .98,
                  left: size.width * .1,
                  child: CustomPaint(
                    painter: MyPainter(animation4.value - 30),
                  ),
                ),
                Positioned(
                  top: size.height * .5,
                  left: size.width * (animation2.value + .8),
                  child: CustomPaint(
                    painter: MyPainter(30),
                  ),
                ),
                Positioned(
                  top: size.height * animation3.value,
                  left: size.width * (animation1.value + .1),
                  child: CustomPaint(
                    painter: MyPainter(60),
                  ),
                ),
                Positioned(
                  top: size.height * .1,
                  left: size.width * .8,
                  child: CustomPaint(
                    painter: MyPainter(animation4.value),
                  ),
                ),
                Column(
                  children: [
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: EdgeInsets.only(top: size.height * .1),
                        child: Text(
                          'APP NAME',
                          style: TextStyle(
                            color: Colors.white.withOpacity(.7),
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                            wordSpacing: 4,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaY: 15,
                                sigmaX: 15,
                              ),
                              child: Container(
                                height: size.width / 8,
                                width: size.width / 1.2,
                                alignment: Alignment.center,
                                padding:
                                    EdgeInsets.only(right: size.width / 30),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextField(
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.8)),
                                  cursorColor: Colors.white,
                                  // keyboardType:
                                  // isEmail ? TextInputType.emailAddress : TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.account_circle_sharp,
                                      color: Colors.white.withOpacity(.7),
                                    ),
                                    border: InputBorder.none,
                                    hintMaxLines: 1,
                                    hintText: 'Name...',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(.5)),
                                  ),
                                  onChanged: (changed) {
                                    setState(() {
                                      _name = changed;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaY: 15,
                                sigmaX: 15,
                              ),
                              child: Container(
                                height: size.width / 8,
                                width: size.width / 1.2,
                                alignment: Alignment.center,
                                padding:
                                    EdgeInsets.only(right: size.width / 30),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextField(
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.8)),
                                  cursorColor: Colors.white,
                                  // keyboardType:
                                  // isEmail ? TextInputType.emailAddress : TextInputType.text,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.email_outlined,
                                      color: Colors.white.withOpacity(.7),
                                    ),
                                    border: InputBorder.none,
                                    hintMaxLines: 1,
                                    hintText: 'Email...',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(.5)),
                                  ),
                                  onChanged: (changed) {
                                    setState(() {
                                      _email = changed;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaY: 15,
                                sigmaX: 15,
                              ),
                              child: Container(
                                height: size.width / 8,
                                width: size.width / 1.2,
                                alignment: Alignment.center,
                                padding:
                                    EdgeInsets.only(right: size.width / 30),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.05),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: TextField(
                                  style: TextStyle(
                                      color: Colors.white.withOpacity(.8)),
                                  cursorColor: Colors.white,
                                  obscureText: _isHidden,
                                  decoration: InputDecoration(
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _isHidden = !_isHidden;
                                        });
                                      },
                                      child: _isHidden
                                          ? Icon(
                                              Icons.remove_red_eye_sharp,
                                              color:
                                                  Colors.white.withOpacity(.5),
                                            )
                                          : const Icon(
                                              Icons.remove_red_eye,
                                              color: Colors.blueAccent,
                                            ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.lock_open_outlined,
                                      color: Colors.white.withOpacity(.7),
                                    ),
                                    border: InputBorder.none,
                                    hintMaxLines: 1,
                                    hintText: 'Password...',
                                    hintStyle: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(.5)),
                                  ),
                                  onChanged: (changed) {
                                    setState(() {
                                      _password = changed;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              buttonComponent('Зарегистрироваться', 2, () {
                                if (_name.length > 3) {
                                  context
                                      .read<FirebaseAuthMethods>()
                                      .signUpWithEmail(
                                          email: _email,
                                          password: _password,
                                          name: _name[0].toUpperCase() +
                                              _name.substring(1).toLowerCase(),
                                          context: context);
                                }
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          buttonComponent('Войти в аккаунт', 2, () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignInScreen()));
                          }),
                          SizedBox(height: size.height * .05),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget componentTextField(IconData icon, String hintText, bool isPassword) {
    Size size = MediaQuery.of(context).size;

    if (isPassword) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaY: 15,
            sigmaX: 15,
          ),
          child: Container(
            height: size.width / 8,
            width: size.width / 1.2,
            alignment: Alignment.center,
            padding: EdgeInsets.only(right: size.width / 30),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.05),
              borderRadius: BorderRadius.circular(15),
            ),
            child: TextField(
              style: TextStyle(color: Colors.white.withOpacity(.8)),
              cursorColor: Colors.white,
              obscureText: _isHidden,
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isHidden = !_isHidden;
                    });
                  },
                  child: _isHidden
                      ? Icon(
                          Icons.remove_red_eye_sharp,
                          color: Colors.white.withOpacity(.5),
                        )
                      : const Icon(
                          Icons.remove_red_eye,
                          color: Colors.blueAccent,
                        ),
                ),
                prefixIcon: Icon(
                  icon,
                  color: Colors.white.withOpacity(.7),
                ),
                border: InputBorder.none,
                hintMaxLines: 1,
                hintText: hintText,
                hintStyle: TextStyle(
                    fontSize: 14, color: Colors.white.withOpacity(.5)),
              ),
              onChanged: (changed) {
                setState(() {
                  if (hintText == 'Email...') {
                    _email = changed;
                  }
                  if (hintText == 'Password...') {
                    _password = changed;
                  }
                  if (hintText == 'Name...') {
                    _name = changed;
                  }
                });
              },
            ),
          ),
        ),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaY: 15,
          sigmaX: 15,
        ),
        child: Container(
          height: size.width / 8,
          width: size.width / 1.2,
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: size.width / 30),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.05),
            borderRadius: BorderRadius.circular(15),
          ),
          child: TextField(
            style: TextStyle(color: Colors.white.withOpacity(.8)),
            cursorColor: Colors.white,
            // keyboardType:
            // isEmail ? TextInputType.emailAddress : TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(
                icon,
                color: Colors.white.withOpacity(.7),
              ),
              border: InputBorder.none,
              hintMaxLines: 1,
              hintText: hintText,
              hintStyle:
                  TextStyle(fontSize: 14, color: Colors.white.withOpacity(.5)),
            ),
            onChanged: (changed) {
              setState(() {
                if (hintText == 'Email...') {
                  _email = changed;
                }
                if (hintText == 'Password...') {
                  _password = changed;
                }
                if (hintText == 'Name...') {
                  _name = changed;
                }
              });
            },
          ),
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
              colors: [Color(0xffFD5E3D), Color(0xffC43990)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: const Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
