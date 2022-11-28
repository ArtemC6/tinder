import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../config/const.dart';
import '../../config/firestore_operations.dart';
import '../../model/interests_model.dart';
import '../../model/user_model.dart';
import '../../widget/button_widget.dart';
import '../../widget/component_widget.dart';
import '../../widget/photo_widget.dart';
import 'edit_image_profile_screen.dart';

class ProfileSettingScreen extends StatefulWidget {
  final UserModel userModel;
  final List<InterestsModel> listInterests;

  ProfileSettingScreen(
      {Key? key, required this.userModel, required this.listInterests})
      : super(key: key);

  @override
  State<ProfileSettingScreen> createState() =>
      _ProfileSettingScreen(userModel, listInterests);
}

class _ProfileSettingScreen extends State<ProfileSettingScreen> {
  bool isLike = false;
  late UserModel userModel;
  final List<InterestsModel> listInterests;

  _ProfileSettingScreen(this.userModel, this.listInterests);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: color_black_88,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
                child: SizedBox(
                  height: size.height * .28,
                  width: size.width,
                  child: CachedNetworkImage(
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: BoxFit.cover,
                    imageUrl: userModel.imageBackground,
                  ),
                ),
              ),
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
                Positioned(
                  child: Container(
                      padding: const EdgeInsets.only(top: 32, right: 28),
                      alignment: Alignment.centerRight,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(color: Colors.white12)),
                        child: customIconButton(
                          height: 23,
                          width: 23,
                        path: 'images/ic_image.png',
                        padding: 2,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            FadeRouteAnimation(
                              EditImageProfileScreen(
                                bacImage: userModel.imageBackground,
                              ),
                            ),
                          );
                        },
                      ),
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
                            photoProfile(uri: userModel.userImageUrl[0]),
                            customIconButton(
                              path: 'images/edit_icon.png',
                              width: 25,
                              height: 25,
                              onTap: () async {
                                uploadImage(context, userModel, false);
                              },
                              padding: 0,
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
                        buttonProfileMy(userModel),
                        const SizedBox()
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      alignment: Alignment.topLeft,
                      decoration: const BoxDecoration(
                          color: color_black_88,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(22),
                              topRight: Radius.circular(22))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        infoPanelWidget(
                          userModel: userModel,
                        ),
                        slideInterestsSettings(listInterests, userModel),
                        photoProfileSettingsGallery(userModel),
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
}
