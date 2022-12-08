import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';

import '../config/const.dart';

class SlideFadeTransition extends StatefulWidget {
  final Widget child;
  final double offset;
  final Curve curve;
  final Direction direction;
  final Duration delayStart;
  final Duration animationDuration;

  const SlideFadeTransition({
    super.key,
    required this.child,
    this.offset = 1.0,
    this.curve = Curves.easeIn,
    this.direction = Direction.vertical,
    this.delayStart = const Duration(seconds: 0),
    this.animationDuration = const Duration(milliseconds: 800),
  });

  @override
  _SlideFadeTransitionState createState() => _SlideFadeTransitionState();
}

enum Direction { vertical, horizontal }

class _SlideFadeTransitionState extends State<SlideFadeTransition>
    with SingleTickerProviderStateMixin {
  late Animation<Offset> _animationSlide;

  late AnimationController _animationController;

  late Animation<double> _animationFade;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    );

    //configure the animation controller as per the direction
    if (widget.direction == Direction.vertical) {
      _animationSlide = Tween<Offset>(
              begin: Offset(0, widget.offset), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    } else {
      _animationSlide = Tween<Offset>(
              begin: Offset(widget.offset, 0), end: const Offset(0, 0))
          .animate(CurvedAnimation(
        curve: widget.curve,
        parent: _animationController,
      ));
    }

    _animationFade =
        Tween<double>(begin: -1.0, end: 1.0).animate(CurvedAnimation(
      curve: widget.curve,
      parent: _animationController,
    ));

    Timer(widget.delayStart, () {
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animationFade,
      child: SlideTransition(
        position: _animationSlide,
        child: widget.child,
      ),
    );
  }
}

class loadingCustom extends StatelessWidget {
  const loadingCustom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: color_black_88,
        body: Center(
          child: LoadingAnimationWidget.dotsTriangle(
            size: 44,
            color: Colors.blueAccent,
          ),
        ));
  }
}

SlideFadeTransition showProgressWrite() {
  return SlideFadeTransition(
    animationDuration: const Duration(milliseconds: 400),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        LoadingAnimationWidget.horizontalRotatingDots(
          size: 20,
          color: Colors.blueAccent,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 2),
          child: RichText(
            text: TextSpan(
              text: 'печатает...',
              style: GoogleFonts.lato(
                textStyle: const TextStyle(
                    color: Colors.blueAccent,
                    fontSize: 10.5,
                    letterSpacing: .7),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

SlideFadeTransition animatedText(double size, text, color, time, line) {
  return SlideFadeTransition(
    animationDuration: Duration(milliseconds: time),
    child: RichText(
      maxLines: line,
      text: TextSpan(
        text: text,
        style: GoogleFonts.lato(
          textStyle: TextStyle(color: color, fontSize: size, letterSpacing: .6),
        ),
      ),
    ),
  );
}

SizedBox showIfNoData(double height, String imagePath, String text,
    AnimationController animationController, double share,) {
  return SizedBox(
    height: height,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Lottie.asset(
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              return const SizedBox();

            }, onLoaded: (composition) {
          animationController
            ..duration = composition.duration
            ..repeat();
        },
            controller: animationController,
            height: height / share,
            fit: BoxFit.contain,
            imagePath),

        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: animatedText(14.5, text, Colors.white, 600, 2),
        ),
        SizedBox(
          height: height / 3.5,
        )
      ],
    ),
  );
}

Column showAnimationGif(double height, String path, AnimationController animationController) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Lottie.asset(alignment: Alignment.center,
          errorBuilder: (context, error, stackTrace) {
            return const SizedBox();
          }, onLoaded: (composition) {
            animationController
              ..duration = composition.duration
              ..repeat();
          },
          controller: animationController,
          height: height * 0.26,
          width: height * 0.34,
          path),
      SizedBox(height: height * 0.08,),
    ],
  );
}
