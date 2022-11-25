import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_loading/card_loading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../config/const.dart';
import '../model/user_model.dart';
import '../screens/profile_screen.dart';
import 'animation_widget.dart';
import 'button_widget.dart';

class photoUser extends StatelessWidget {
  String uri, state;
  double height, width, padding;

  photoUser(
      {Key? key,
      required this.uri,
      required this.height,
      required this.width,
      required this.padding,
      required this.state})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Card(
          shadowColor: Colors.white30,
          color: color_black_88,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
              side: const BorderSide(
                width: 0.5,
                color: Colors.white24,
              )),
          elevation: 6,
          child: CachedNetworkImage(
            errorWidget: (context, url, error) => const Icon(Icons.error),
            progressIndicatorBuilder: (context, url, progress) => Center(
              child: SizedBox(
                height: height,
                width: width,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 0.8,
                  value: progress.progress,
                ),
              ),
            ),
            imageUrl: uri,
            imageBuilder: (context, imageProvider) => Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(50)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        if (state == 'online')
          SlideFadeTransition(
            animationDuration: const Duration(milliseconds: 500),
            child: customIconButton(
                padding: padding,
                width: 27,
                height: 27,
                path: 'images/ic_green_dot.png',
                onTap: () {}),
          ),
      ],
    );
  }
}

class itemUserLike extends StatelessWidget {
  final UserModel userModelLike, userModelCurrent;

  itemUserLike(this.userModelLike, this.userModelCurrent, {super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Container(
        height: width / 3.4,
        width: width,
        padding: EdgeInsets.only(
            left: width / 30, top: 0, right: width / 30, bottom: width / 30),
        child: Card(
          color: color_black_88,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: const BorderSide(
                width: 0.1,
                color: Colors.white10,
              )
          ),
          shadowColor: Colors.white12,
          elevation: 14,
          child: Container(
            padding:
                const EdgeInsets.only(left: 14, top: 8, bottom: 8, right: 10),
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onTap: () {
                Navigator.push(
                    context,
                    FadeRouteAnimation(ProfileScreen(
                      userModelPartner: userModelLike,
                      isBack: true,
                      idUser: '',
                      userModelCurrent: userModelCurrent,
                    )));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      SizedBox(
                        child: photoUser(
                          uri: userModelLike.userImageUrl[0],
                          width: 60,
                          height: 60,
                          state: userModelLike.state,
                          padding: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    width: width / 1.6,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SlideFadeTransition(
                          animationDuration: const Duration(milliseconds: 550),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                      '${userModelLike.name}, ${userModelLike.ageInt}',
                                  style: GoogleFonts.lato(
                                    textStyle: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        letterSpacing: .5),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              RichText(
                                maxLines: 1,
                                text: TextSpan(
                                  text: userModelLike.myCity,
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(.6),
                                        fontSize: 11,
                                        letterSpacing: .5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        customIconButton(
                          onTap: () {
                            Navigator.push(
                                context,
                                FadeRouteAnimation(ProfileScreen(
                                  userModelPartner: userModelLike,
                                  isBack: true,
                                  idUser: '',
                                  userModelCurrent: userModelCurrent,
                                )));
                          },
                          path: 'images/ic_send.png',
                          height: 30,
                          width: 30,
                          padding: 4,
                        )
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
}

CustomScrollView cardLoadingWidget(
    Size size, double heightCard, double heightAvatar) {
  return CustomScrollView(
    slivers: [
      SliverPadding(
        padding: const EdgeInsets.all(20),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(alignment: Alignment.centerLeft, children: [
                      CardLoading(
                        cardLoadingTheme: CardLoadingTheme(
                            colorTwo: color_black_88,
                            colorOne: Colors.white.withOpacity(0.10)),
                        height: size.height * heightCard,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(15)),
                        margin: const EdgeInsets.only(bottom: 10),
                      ),
                      Positioned(
                        left: 22,
                        child: CardLoading(
                          cardLoadingTheme: CardLoadingTheme(
                              colorTwo: color_black_88,
                              colorOne: Colors.white.withOpacity(0.14)),
                          height: size.height * heightAvatar,
                          width: size.height * heightAvatar,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50)),
                          margin: const EdgeInsets.only(bottom: 10),
                        ),
                      ),
                    ]),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CardLoading(
                            cardLoadingTheme: CardLoadingTheme(
                                colorTwo: color_black_88,
                                colorOne: Colors.white.withOpacity(0.10)),
                            height: 30,
                            width: 200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                        ),
                        const Expanded(child: SizedBox()),
                        Expanded(
                          flex: 1,
                          child: CardLoading(
                            cardLoadingTheme: CardLoadingTheme(
                                colorTwo: color_black_88,
                                colorOne: Colors.white.withOpacity(0.10)),
                            height: 30,
                            width: 200,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15)),
                            margin: const EdgeInsets.only(bottom: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            childCount: 10,
          ),
        ),
      ),
    ],
  );
}

Widget cardLoading(Size size, double radius) {
  return CardLoading(
    cardLoadingTheme: CardLoadingTheme(
        colorTwo: color_black_88, colorOne: Colors.white.withOpacity(0.12)),
    height: size.height,
    width: size.width,
    borderRadius: BorderRadius.circular(radius),
  );
}

Widget cardPartner(int index, List<UserModel> userModelPartner, Size size,
    BuildContext context) {
  return Card(
    shadowColor: Colors.white30,
    color: color_black_88,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
        side: const BorderSide(
          width: 0.8,
          color: Colors.white38,
        )),
    elevation: 10,
    child: Stack(
      fit: StackFit.expand,
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: CachedNetworkImage(
              errorWidget: (context, url, error) => const Icon(Icons.error),
              useOldImageOnUrlChange: false,
              progressIndicatorBuilder: (context, url, progress) =>
                  Center(child: cardLoading(size, 22)),
              imageUrl: userModelPartner[index].userImageUrl[0],
              fit: BoxFit.cover,
              // height: 166,
              width: MediaQuery.of(context).size.width),
        ),
        Container(
          alignment: Alignment.bottomLeft,
          padding: const EdgeInsets.only(bottom: 20, left: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  text:
                      '${userModelPartner[index].name}, ${userModelPartner[index].ageInt} \n${userModelPartner[index].myCity}',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 14, letterSpacing: .0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
