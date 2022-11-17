import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ndialog/ndialog.dart';

import '../config/const.dart';
import '../config/firestore_operations.dart';
import '../model/user_model.dart';
import 'button_widget.dart';

void showDialogZoom({required String uri, required BuildContext context}) {
  ZoomDialog(
    zoomScale: 5,
    child: SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      width: MediaQuery.of(context).size.width * 0.92,
      child: CachedNetworkImage(
        errorWidget: (context, url, error) => const Icon(Icons.error),
        imageBuilder: (context, imageProvider) => Container(
          decoration: BoxDecoration(
            color: color_black_88,
            border: Border.all(color: Colors.white30, width: 0.8),
            borderRadius: const BorderRadius.all(Radius.circular(14)),
            image: DecorationImage(
              image: imageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
        progressIndicatorBuilder: (context, url, progress) => Center(
          child: SizedBox(
            height: 26,
            width: 26,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 0.8,
              value: progress.progress,
            ),
          ),
        ),
        imageUrl: uri,
      ),
    ),
  ).show(context);
}

class photoProfile extends StatelessWidget {
  String uri;

  photoProfile({Key? key, required this.uri}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialogZoom(uri: uri, context: context);
      },
      child: SizedBox(
        height: 110,
        width: 110,
        child: Card(
          shadowColor: Colors.white38,
          color: color_black_88,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white30,
              )),
          elevation: 4,
          child: CachedNetworkImage(
            errorWidget: (context, url, error) => const Icon(Icons.error),
            progressIndicatorBuilder: (context, url, progress) => Center(
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
            imageUrl: uri,
            imageBuilder: (context, imageProvider) => Container(
              height: 110,
              width: 110,
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: const BorderRadius.all(Radius.circular(14)),
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class photoProfileGallery extends StatelessWidget {
  List<String> listPhoto = [];

  photoProfileGallery(this.listPhoto, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 26, top: 20, bottom: 18),
          child: RichText(
            text: TextSpan(
              text: 'Фото',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
            height: 380,
            child: AnimationLimiter(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 18, right: 18),
                crossAxisCount: 3,
                children: List.generate(
                  listPhoto.length,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 2200),
                      columnCount: 3,
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 2200),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () {
                              showDialogZoom(
                                uri: listPhoto[index],
                                context: context,
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 5, right: 5, top: 5),
                              child: Card(
                                shadowColor: Colors.white30,
                                color: color_black_88,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      width: 0.6,
                                      color: Colors.white30,
                                    )),
                                elevation: 6,
                                child: CachedNetworkImage(
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    decoration: BoxDecoration(
                                      color: color_black_88,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  progressIndicatorBuilder:
                                      (context, url, progress) => Center(
                                    child: SizedBox(
                                      height: 26,
                                      width: 26,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 0.8,
                                        value: progress.progress,
                                      ),
                                    ),
                                  ),
                                  imageUrl: listPhoto[index],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}

class photoProfileSettingsGallery extends StatelessWidget {
  UserModel userModel;

  photoProfileSettingsGallery(this.userModel, {super.key});

  List<String> listImageUri = [], listImagePath = [];
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(left: 26, top: 20, bottom: 18),
          child: RichText(
            text: TextSpan(
              text: 'Фото',
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                    letterSpacing: .9),
              ),
            ),
          ),
        ),
        SizedBox(
            height: 380,
            child: AnimationLimiter(
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(left: 18, right: 18, top: 0),
                crossAxisCount: 3,
                children: List.generate(
                  9,
                  (int index) {
                    return AnimationConfiguration.staggeredGrid(
                      position: index,
                      duration: const Duration(milliseconds: 2200),
                      columnCount: 3,
                      child: ScaleAnimation(
                        duration: const Duration(milliseconds: 2200),
                        curve: Curves.fastLinearToSlowEaseIn,
                        child: FadeInAnimation(
                          child: InkWell(
                            onTap: () {
                              if (userModel.userImageUrl.length > index) {
                                showDialogZoom(
                                  uri: userModel.userImageUrl[index],
                                  context: context,
                                );
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 5, left: 5, right: 5, top: 5),
                              child: Card(
                                shadowColor: Colors.white30,
                                color: color_black_88,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: const BorderSide(
                                      width: 0.8,
                                      color: Colors.white38,
                                    )),
                                elevation: 6,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    if (userModel.userImageUrl.length > index)
                                      CachedNetworkImage(
                                        errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                        imageBuilder:
                                            (context, imageProvider) =>
                                                Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(12)),
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        progressIndicatorBuilder:
                                            (context, url, progress) => Center(
                                          child: SizedBox(
                                            height: 26,
                                            width: 26,
                                            child: CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 0.8,
                                              value: progress.progress,
                                            ),
                                          ),
                                        ),
                                        imageUrl: userModel.userImageUrl[index],
                                      ),
                                    if (0 == index)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          uploadImage(
                                              context, userModel, false);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(4),
                                          child: Image.asset(
                                            'images/edit_icon.png',
                                            height: 22,
                                            width: 22,
                                          ),
                                        ),
                                      ),
                                    if (userModel.userImageUrl.length > index &&
                                        index != 0)
                                      customIconButton(
                                          padding: 2,
                                          width: 25,
                                          height: 25,
                                          path: 'images/ic_remove.png',
                                          onTap: () {
                                            imageRemove(
                                                index, context, userModel);
                                          }),
                                    if (userModel.userImageUrl.length <=
                                            index &&
                                        userModel.userImageUrl.isNotEmpty)
                                      customIconButton(
                                          padding: 6,
                                          width: 21,
                                          height: 21,
                                          path: 'images/ic_add.png',
                                          onTap: () {
                                            uploadImageAdd(context, userModel);
                                          }),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )),
      ],
    );
  }
}
