import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../config/const.dart';
import '../../config/firestore_operations.dart';
import '../../widget/button_widget.dart';

class EditImageProfileScreen extends StatefulWidget {
  String bacImage;

  EditImageProfileScreen({Key? key, required this.bacImage}) : super(key: key);

  @override
  State<EditImageProfileScreen> createState() =>
      _EditImageProfileScreen(bacImage);
}

class _EditImageProfileScreen extends State<EditImageProfileScreen> {
  bool isLoading = false;
  String bacImage;
  List<String> listImageUri = [];
  int indexImage = 100;

  _EditImageProfileScreen(this.bacImage);

  Future readFirebaseImageProfile() async {
    await FirebaseFirestore.instance
        .collection('ImageProfile')
        .doc('Image')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      setState(() {
        listImageUri = List<String>.from(documentSnapshot['listProfileImage']);
      });
    });

    setState(() {
      if (bacImage != '') {
        indexImage = listImageUri.indexWhere((element) => element == bacImage);
      }
      isLoading = true;
    });
  }

  @override
  void initState() {
    readFirebaseImageProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_black_88,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.only(
                    top: 30, left: 20, right: 20, bottom: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (bacImage != '')
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_rounded,
                            size: 20),
                        color: Colors.white,
                      ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: RichText(
                        text: TextSpan(
                          text: 'Фон',
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.white.withOpacity(1),
                                fontSize: 18,
                                letterSpacing: .9),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 40),
                  ],
                ),
              ),
              SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: AnimationLimiter(
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(left: 18, right: 18),
                      crossAxisCount: 2,
                      children: List.generate(
                        listImageUri.length,
                        (int index) {
                          return AnimationConfiguration.staggeredGrid(
                            position: index,
                            duration: const Duration(milliseconds: 1000),
                            columnCount: 2,
                            child: ScaleAnimation(
                              duration: const Duration(milliseconds: 1000),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () {
                                        uploadImagePhotoProfile(
                                            listImageUri[index], context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Card(
                                          shadowColor: Colors.white30,
                                          color: color_black_88,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                              side: const BorderSide(
                                                width: 0.8,
                                                color: Colors.white38,
                                              )),
                                          elevation: 6,
                                          child: CachedNetworkImage(
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(14)),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            progressIndicatorBuilder:
                                                (context, url, progress) =>
                                                    Center(
                                              child: SizedBox(
                                                height: 26,
                                                width: 26,
                                                child:
                                                    CircularProgressIndicator(
                                                  color: Colors.white,
                                                  strokeWidth: 0.8,
                                                  value: progress.progress,
                                                ),
                                              ),
                                            ),
                                            imageUrl: listImageUri[index],
                                          ),
                                        ),
                                      ),
                                    ),
                                    if (indexImage == index &&
                                        indexImage != 100)
                                      customIconButton(
                                          height: 24,
                                          width: 24,
                                          padding: 4,
                                          path: 'images/ic_save.png',
                                          onTap: () {
                                            uploadImagePhotoProfile(
                                                listImageUri[index], context);
                                          }),
                                    if (indexImage != index)
                                      InkWell(
                                        splashColor: Colors.transparent,
                                        highlightColor: Colors.transparent,
                                        onTap: () {
                                          uploadImagePhotoProfile(
                                              listImageUri[index], context);
                                        },
                                        child: Container(
                                          height: 23,
                                          width: 23,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 0.5,
                                                  color: Colors.white38),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: Colors.white12),
                                          // padding: const EdgeInsets.all(10),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )),
            ],
          ),
        ),
      );
    }
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
