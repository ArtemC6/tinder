import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';
import 'data/const.dart';
import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:cached_network_image/cached_network_image.dart';

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
  'https://cdn.fw-daily.com/2012/09/Untitled-2.jpg',
  'https://creativestudio.ru/wp-content/gallery/model_release/model_release_2.jpg',
  'https://img2.goodfon.ru/original/640x960/b/6a/miranda-kerr-miranda-kerr-2566.jpg',
];

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final TCardController _controllerCard = TCardController();
  late CardController controllerCard;
  late AnimationController controllerHeart;
  late CurvedAnimation curveHeart, curveCancel;
  bool isLike = false, isLikeButton = false, isLook = false;

  @override
  void initState() {
    super.initState();

    controllerHeart = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    curveHeart = CurvedAnimation(
        parent: controllerHeart, curve: Curves.fastLinearToSlowEaseIn);
    PaintingBinding.instance.imageCache.clear();
  }

  @override
  void dispose() {
    controllerHeart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> cards = List.generate(
      images.length,
      (int index) {
        return Card(
          shadowColor: Colors.white30,
          color: color_data_input,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white38,
              )),
          elevation: 10,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: CachedNetworkImage(
                useOldImageOnUrlChange: false,
                progressIndicatorBuilder: (context, url, progress) => Center(
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 0.8,
                          value: progress.progress,
                        ),
                      ),
                    ),
                imageUrl: images[index],
                fit: BoxFit.cover,
                height: 166,
                width: MediaQuery.of(context).size.width),
          ),
        );
      },
    );

    return Scaffold(
      backgroundColor: color_data_input,
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  padding: EdgeInsets.only(top: 40),
                  // color: Colors.green,
                  height: MediaQuery.of(context).size.height / 1.4,
                  child: TinderSwapCard(
                    animDuration: 850,
                    swipeUp: false,
                    swipeDown: false,
                    // orientation: AmassOrientation.BOTTOM,
                    totalNum: images.length,
                    stackNum: 3,
                    swipeEdge: 3.0,
                    maxWidth: MediaQuery.of(context).size.width / 1,
                    maxHeight: MediaQuery.of(context).size.width / 1,
                    minWidth: MediaQuery.of(context).size.width / 1.2,
                    minHeight: MediaQuery.of(context).size.width / 1.2,

                    cardBuilder: (context, index) => Container(
                      height: MediaQuery.of(context).size.height / 1,
                      child: Card(
                        shadowColor: Colors.white30,
                        color: color_data_input,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                            side: const BorderSide(
                              width: 0.8,
                              color: Colors.white38,
                            )),
                        elevation: 10,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(22),
                          child: CachedNetworkImage(
                              useOldImageOnUrlChange: false,
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                            strokeWidth: 0.8,
                                            value: progress.progress,
                                          ),
                                        ),
                                      ),
                              imageUrl: images[index],
                              fit: BoxFit.cover,
                              // height: 166,
                              width: MediaQuery.of(context).size.width),
                        ),
                      ),
                    ),
                    cardController: controllerCard = CardController(),
                    swipeUpdateCallback:
                        (DragUpdateDetails details, Alignment align) {
                      /// Get swiping card's alignment
                      if (align.x < 0) {
                        // print('object');
                        //Card is LEFT swiping
                      } else if (align.x > 0) {
                        // print('le');

                        //Card is RIGHT swiping
                      }
                    },
                    swipeCompleteCallback:
                        (CardSwipeOrientation orientation, int index) {
                      if (orientation.toString() ==
                          'CardSwipeOrientation.LEFT') {
                        setState(() {
                          isLike = false;
                          isLook = true;
                        });
                        controllerHeart.forward();
                        Future.delayed(const Duration(milliseconds: 600), () {
                          controllerHeart.reset();
                          setState(() {
                            isLook = false;
                            // isLikeButton = false;
                          });
                        });
                      }

                      if (orientation.toString() ==
                          'CardSwipeOrientation.RIGHT') {
                        setState(() {
                          isLike = true;
                          isLook = true;
                        });
                        controllerHeart.forward();
                        Future.delayed(const Duration(milliseconds: 600), () {
                          controllerHeart.reset();
                          setState(() {
                            isLook = false;
                          });
                        });
                      }

                      /// Get orientation & index of swiped card!
                    },
                  ),
                ),
                if (isLook)
                  if (isLike)
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.9,
                      child: FadeTransition(
                          opacity: controllerHeart,
                          child: Image.asset('images/ic_heart.png',
                              fit: BoxFit.contain)),
                    ),
                if (isLook)
                  if (!isLike)
                    Container(
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 2.9,
                      child: FadeTransition(
                        opacity: curveHeart,
                        child: Image.asset('images/ic_cancel.png',
                            fit: BoxFit.contain),
                      ),
                    ),
              ],
            ),

            // Container(
            //   alignment: Alignment.center,
            //   padding:
            //       EdgeInsets.only(top: MediaQuery.of(context).size.height / 16),
            //   child: Stack(
            //     // fit: StackFit.loose,
            //     alignment: Alignment.center,
            //     children: [
            //       TCard(
            //         size: Size(MediaQuery.of(context).size.width,
            //             MediaQuery.of(context).size.height / 1.5),
            //         cards: cards,
            //         controller: _controllerCard,
            //         onForward: (index, info) {
            //           if (info.direction.toString() == 'SwipDirection.Left') {
            //             setState(() {
            //               isLike = false;
            //               isLook = true;
            //             });
            //             controllerHeart.forward();
            //             Future.delayed(const Duration(milliseconds: 600), () {
            //               controllerHeart.reset();
            //               setState(() {
            //                 isLook = false;
            //                 // isLikeButton = false;
            //               });
            //             });
            //           }
            //
            //           if (info.direction.toString() == 'SwipDirection.Right') {
            //             setState(() {
            //               isLike = true;
            //               isLook = true;
            //             });
            //             controllerHeart.forward();
            //             Future.delayed(const Duration(milliseconds: 600), () {
            //               controllerHeart.reset();
            //               setState(() {
            //                 isLook = false;
            //               });
            //             });
            //           }
            //         },
            //         onBack: (index, info) {
            //           setState(() {});
            //         },
            //         onEnd: () {},
            //         delaySlideFor: 700,
            //       ),
            // if (isLook)
            //   if (isLike)
            //     Container(
            //       alignment: Alignment.center,
            //       width: MediaQuery.of(context).size.width,
            //       height: MediaQuery.of(context).size.height / 2.4,
            //       child: FadeTransition(
            //           opacity: controllerHeart,
            //           child: Image.asset('images/ic_heart.png',
            //               fit: BoxFit.contain)),
            //     ),
            // if (isLook)
            //   if (!isLike)
            //     Container(
            //       alignment: Alignment.center,
            //       width: MediaQuery.of(context).size.width,
            //       height: MediaQuery.of(context).size.height / 2.4,
            //       child: FadeTransition(
            //         opacity: curveHeart,
            //         child: Image.asset('images/ic_cancel.png',
            //             fit: BoxFit.contain),
            //       ),
            //     ),
            // ],
            // ),
            // ),
            // SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    controllerCard.triggerLeft();
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 2,
                    child: AvatarGlow(
                      glowColor: Colors.blueAccent,
                      endRadius: 60,
                      repeatPauseDuration: const Duration(milliseconds: 1500),
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      curve: Curves.easeOutQuad,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99)),
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () {
                    controllerCard.triggerRight();
                  },
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height / 5,
                    width: MediaQuery.of(context).size.width / 2,
                    child: AvatarGlow(
                      glowColor: Colors.blueAccent,
                      endRadius: 60,
                      duration: const Duration(milliseconds: 2000),
                      repeat: true,
                      showTwoGlows: true,
                      curve: Curves.easeOutQuad,
                      child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(99)),
                        child: const Icon(
                          Icons.favorite,
                          color: Colors.red,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
