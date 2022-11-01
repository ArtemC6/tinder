import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../config/const.dart';
import '../../config/firestore_operations.dart';
import '../../model/interests_model.dart';
import '../../model/user_model.dart';
import '../widget/component_widget.dart';
import 'edit_image_profile_screen.dart';

class ProfileSettingScreen extends StatefulWidget {
  UserModel userModel;

  ProfileSettingScreen({Key? key, required this.userModel}) : super(key: key);

  @override
  State<ProfileSettingScreen> createState() => _ProfileSettingScreen(userModel);
}

class _ProfileSettingScreen extends State<ProfileSettingScreen> {
  bool isLoading = false, isLike = false;
  late UserModel userModel;
  List<InterestsModel> listStory = [];
  _ProfileSettingScreen(this.userModel);

  void readFirebase() async {
    for (var elementMain in userModel.userInterests) {
      for (var element in listStoryMain) {
        if (elementMain == element.name) {
          if (userModel.userInterests.length != listStory.length) {
            listStory.add(element);
          }
        }
      }
    }

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
    var size = MediaQuery.of(context).size;
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_data_input,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Positioned(
                child: SizedBox(
                  height: size.height * .28,
                  width: size.width,
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    imageUrl: userModel.imageBackground,
                  ),
                ),
              ),
              if (isLoading)
                Positioned(
                  child: Container(
                    margin: const EdgeInsets.only(
                      top: 20,
                    ),
                    height: 40,
                    width: 40,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 20),
                      color: Colors.white,
                    ),
                  ),
                ),
              if (isLoading)
                Positioned(
                  child: Container(
                    padding: const EdgeInsets.only(top: 24, right: 24),
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            FadeRouteAnimation(EditImageProfileScreen(
                              bacImage: userModel.imageBackground,
                            )));
                      },
                      icon: Image.asset(
                        'images/ic_image.png',
                        height: 25,
                        width: 25,
                      ),
                      color: Colors.white,
                    ),
                  ),
                ),
              Container(
                margin: EdgeInsets.only(top: size.height * .20),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      alignment: Alignment.centerLeft,
                      color: Colors.transparent,
                      // padding: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Stack(alignment: Alignment.bottomRight, children: [
                            SizedBox(
                              height: 110,
                              width: 110,
                              child: Card(
                                shadowColor: Colors.white38,
                                color: color_data_input,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    side: const BorderSide(
                                      width: 0.8,
                                      color: Colors.white30,
                                    )),
                                elevation: 4,
                                child: CachedNetworkImage(
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
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
                                  imageUrl: userModel.userImageUrl[0],
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    height: 110,
                                    width: 110,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(14)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              splashColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () {
                                uploadImage(context, userModel, false);
                              },
                              child: Image.asset(
                                'images/edit_icon.png',
                                height: 24,
                                width: 24,
                              ),
                            ),
                          ]),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 10, left: 14),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text:
                                      '${userModel.name}, ${userModel.ageInt}',
                                  style: GoogleFonts.lato(
                                    textStyle: TextStyle(
                                        color: Colors.white.withOpacity(1),
                                        fontSize: 16,
                                        letterSpacing: .8),
                                  ),
                                ),
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    RichText(
                                      text: TextSpan(
                                        text: userModel.myCity,
                                        style: GoogleFonts.lato(
                                          textStyle: TextStyle(
                                              color:
                                                  Colors.white.withOpacity(0.8),
                                              fontSize: 11,
                                              letterSpacing: .5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        buttonProfile(userModel: userModel, isProprietor: true),
                        const SizedBox()
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                          color: color_data_input,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          infoPanelWidget(
                            userModel: userModel,
                          ),
                          slideInterestsSettings(listStory, userModel),
                          photoProfileSettings(userModel),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
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
