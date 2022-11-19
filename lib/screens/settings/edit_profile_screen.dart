import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tinder/screens/auth/signin_screen.dart';
import 'package:tinder/screens/settings/edit_image_profile_screen.dart';

import '../../config/const.dart';
import '../../config/firebase_auth.dart';
import '../../config/firestore_operations.dart';
import '../../model/user_model.dart';
import '../../widget/animation_widget.dart';
import '../../widget/button_widget.dart';
import '../../widget/textField_widget.dart';
import '../manager_screen.dart';

class EditProfileScreen extends StatefulWidget {
  bool isFirst;
  UserModel userModel;

  EditProfileScreen(
      {super.key, required this.isFirst, required this.userModel});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState(isFirst, userModel);
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isFirst;
  late UserModel modelUser;

  _EditProfileScreenState(this.isFirst, this.modelUser);
  bool isLoading = false, isError = false, isPhoto = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _myPolController = TextEditingController();
  final TextEditingController _searchPolController = TextEditingController();
  final TextEditingController _ageRangController = TextEditingController();
  final TextEditingController _localController = TextEditingController();
  var _selectedInterests = [];
  DateTime _dateTimeBirthday = DateTime.now();
  late SfRangeValues _valuesAge;
  int interestsCount = 0;

  void showDatePicker() {
    DatePicker.showDatePicker(context,
        theme: const DatePickerTheme(
            backgroundColor: color_black_88,
            cancelStyle: TextStyle(color: Colors.white),
            itemStyle: TextStyle(color: Colors.white)),
        showTitleActions: true,
        minTime: DateTime(1970),
        maxTime: DateTime(2006), onChanged: (date) {
      setState(() {
        _dateTimeBirthday = date;
        _ageController.text =
            (DateTime.now().year - _dateTimeBirthday.year).toString();
      });
    },
        onConfirm: (date) {},
        currentTime: DateTime.now(),
        locale: LocaleType.ru);
  }

  Future<void> _uploadData() async {
    bool interests =
        _selectedInterests.isNotEmpty && _selectedInterests.length <= 6;
    bool myPol = _myPolController.text.length == 7;
    bool name = _nameController.text.length >= 3;
    bool searchPol = _searchPolController.text.length >= 7;
    bool localUser = _localController.text.length >= 6;
    bool userPhoto = modelUser.userImageUrl.isNotEmpty;
    bool userAge = DateTime.now().year - _dateTimeBirthday.year >= 16;
    bool ageRange = _valuesAge.start >= 16 && _valuesAge.end < 50;

    if (interests &&
        myPol &&
        name &&
        searchPol &&
        localUser &&
        userPhoto &&
        userAge &&
        ageRange) {
      String? token;
      await FirebaseMessaging.instance.getToken().then((value) {
        token = value;
      });

      final docUser = FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid);

      final json = {
        'listInterests': _selectedInterests,
        'myPol': _myPolController.text,
        'name': _nameController.text,
        'searchPol':
            _searchPolController.text == 'С парнем' ? 'Мужской' : 'Женский',
        'ageTime': _dateTimeBirthday,
        'ageInt': DateTime.now().year - _dateTimeBirthday.year,
        'rangeStart': _valuesAge.start,
        'rangeEnd': _valuesAge.end,
        'myCity': _localController.text,
        'token': token,
      };

      docUser.update(json).then((value) {
        if (modelUser.imageBackground != '') {
          Navigator.pushReplacement(
              context,
              FadeRouteAnimation(
                ManagerScreen(currentIndex: 3),
              ));
        } else {
          Navigator.pushReplacement(
              context,
              FadeRouteAnimation(
                  EditImageProfileScreen(bacImage: modelUser.imageBackground)));
        }
      });
    } else {
      setState(() {
        isError = true;
      });
    }
  }

  void settingsValue() {
    _nameController.text = modelUser.name;
    _ageRangController.text = modelUser.searchRangeStart == 0
        ? ' '
        : 'От ${modelUser.searchRangeStart.toInt()} до ${modelUser.searchRangeEnd.toInt()} лет';

    _ageController.text =
        modelUser.ageInt == 0 ? ' ' : modelUser.ageInt.toString();

    _valuesAge = SfRangeValues(
        modelUser.searchRangeStart == 0 ? 16 : modelUser.searchRangeStart,
        modelUser.searchRangeEnd == 0 ? 30 : modelUser.searchRangeEnd);
    _myPolController.text = modelUser.userPol == '' ? ' ' : modelUser.userPol;
    _localController.text = modelUser.myCity == '' ? ' ' : modelUser.myCity;
    if (modelUser.searchPol == '') {
      _searchPolController.text = ' ';
    } else {
      _searchPolController.text =
          modelUser.searchPol == 'Мужской' ? 'С парнем' : 'С девушкой';
    }
    if (modelUser.userImageUrl.isNotEmpty) {
      isPhoto = true;
    }
    _selectedInterests = modelUser.userInterests;
    interestsCount = modelUser.userInterests.length;
    _dateTimeBirthday = getDataTimeDate(modelUser.ageTime);
  }

  Future readFirebase() async {
    if (modelUser.uid == '') {
      await readUserFirebase().then((user) {
        setState(() {
          modelUser = UserModel(
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
          isLoading = true;
        });
      });
    }
    setState(() {
      isLoading = true;
      settingsValue();
    });
  }

  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_black_88,
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: AnimationLimiter(
              child: AnimationConfiguration.staggeredList(
                  position: 1,
                  delay: const Duration(milliseconds: 100),
                  child: SlideAnimation(
                      duration: const Duration(milliseconds: 2200),
                      verticalOffset: height * .40,
                      curve: Curves.ease,
                      child: FadeInAnimation(
                        curve: Curves.easeOut,
                        duration: const Duration(milliseconds: 3400),
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  if (!isFirst)
                                    IconButton(
                                      color: Colors.white,
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(
                                          Icons.arrow_back_ios_new_rounded,
                                          size: 20),
                                    ),
                                  customIconButton(
                                    path: 'images/ic_log_out.png',
                                    width: 30,
                                    height: 30,
                                    onTap: () async {
                                      await context
                                          .read<FirebaseAuthMethods>()
                                          .signOut(context);
                                    },
                                    padding: 0,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 120,
                              width: 120,
                              child: Card(
                                shadowColor: Colors.white30,
                                color: color_black_88,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                    side: const BorderSide(
                                      width: 0.8,
                                      color: Colors.white30,
                                    )),
                                elevation: 6,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    if (modelUser.userImageUrl.isNotEmpty)
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: CachedNetworkImage(
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(100)),
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
                                              height: 120,
                                              width: 120,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 0.8,
                                                value: progress.progress,
                                              ),
                                            ),
                                          ),
                                          imageUrl: modelUser.userImageUrl[0],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    if (modelUser.userImageUrl.isEmpty)
                                      customIconButton(
                                        path: 'images/ic_add.png',
                                        width: 23,
                                        height: 23,
                                        onTap: () async {
                                          uploadFirstImage(
                                              context,
                                              modelUser.userImageUrl,
                                              modelUser.userImagePath);
                                        },
                                        padding: 6,
                                      ),
                                    if (modelUser.userImageUrl.isNotEmpty)
                                      customIconButton(
                                        path: 'images/edit_icon.png',
                                        width: 25,
                                        height: 25,
                                        onTap: () async {
                                          uploadImage(context, modelUser, true);
                                        },
                                        padding: 3,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(
                                  width: 80,
                                ),
                                SizedBox(
                                  height: 40,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.white38,
                                          blurRadius: 5.0,
                                          spreadRadius: 0.0,
                                          offset: Offset(
                                            0.0,
                                            1.0,
                                          ),
                                        )
                                      ],
                                      border: Border.all(
                                          width: 0.7, color: Colors.white30),
                                      gradient: const LinearGradient(colors: [
                                        Colors.blueAccent,
                                        Colors.purpleAccent,
                                        Colors.orangeAccent
                                      ]),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        _uploadData();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                      ),
                                      child: RichText(
                                        text: TextSpan(
                                          text: isFirst
                                              ? 'Завершить'
                                              : 'Сохронить',
                                          style: GoogleFonts.lato(
                                            textStyle: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 11,
                                                letterSpacing: .1),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (isError)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Данные введены некоректно',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            if (!isPhoto)
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Добавьте главное фото',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            textFieldProfileSettings(_nameController, false,
                                'Имя', context, 10, () {}),
                            textFieldProfileSettings(_ageController, true,
                                'Возраст', context, 3, () => showDatePicker()),
                            textFieldProfileSettings(
                                _myPolController, true, 'Ваш пол', context, 10,
                                () {
                              showCupertinoModalBottomSheet(
                                  topRadius: const Radius.circular(30),
                                  duration: const Duration(milliseconds: 700),
                                  backgroundColor: color_black_88,
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Container(
                                        height: 260,
                                        padding: const EdgeInsets.all(28),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Column(
                                          children: [
                                            Card(
                                              shadowColor: Colors.white30,
                                              color: color_black_88,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  side: const BorderSide(
                                                    width: 0.8,
                                                    color: Colors.white38,
                                                  )),
                                              elevation: 16,
                                              child: ExpansionTile(
                                                initiallyExpanded: true,
                                                collapsedIconColor:
                                                    Colors.white,
                                                collapsedTextColor:
                                                    Colors.white,
                                                title: RichText(
                                                  text: TextSpan(
                                                    text: 'Укажите свой пол',
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  .9),
                                                    ),
                                                  ),
                                                ),
                                                children: [
                                                  ListTile(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        text: 'Мужской',
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .9),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        _myPolController.text =
                                                            'Мужской';
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        text: 'Женский',
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .9),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        _myPolController.text =
                                                            'Женский';
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  });
                            }),
                            textFieldProfileSettings(
                                _searchPolController,
                                true,
                                'С кем вы хотите познакомиться',
                                context,
                                10, () {
                              showCupertinoModalBottomSheet(
                                  topRadius: const Radius.circular(30),
                                  duration: const Duration(milliseconds: 700),
                                  backgroundColor: color_black_88,
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Container(
                                        height: 260,
                                        padding: const EdgeInsets.all(28),
                                        width: width,
                                        child: Column(
                                          children: [
                                            Card(
                                              shadowColor: Colors.white30,
                                              color: color_black_88,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  side: const BorderSide(
                                                    width: 0.8,
                                                    color: Colors.white38,
                                                  )),
                                              elevation: 16,
                                              child: ExpansionTile(
                                                initiallyExpanded: true,
                                                collapsedIconColor:
                                                    Colors.white,
                                                collapsedTextColor:
                                                    Colors.white,
                                                title: RichText(
                                                  text: TextSpan(
                                                    text:
                                                        'Укажите с кем вы хотите познакомиться',
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  .9),
                                                    ),
                                                  ),
                                                ),
                                                children: [
                                                  ListTile(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        text: 'С парнем',
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .9),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        _searchPolController
                                                            .text = 'С парнем';
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        text: 'С девушкой',
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .9),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        _searchPolController
                                                                .text =
                                                            'С девушкой';
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  });
                            }),
                            textFieldProfileSettings(_localController, true,
                                'Вы проживаете', context, 10, () {
                              showCupertinoModalBottomSheet(
                                  topRadius: const Radius.circular(30),
                                  duration: const Duration(milliseconds: 700),
                                  backgroundColor: color_black_88,
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return Container(
                                        height: 260,
                                        padding: const EdgeInsets.all(28),
                                        width: width,
                                        child: Column(
                                          children: [
                                            Card(
                                              shadowColor: Colors.white30,
                                              color: color_black_88,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  side: const BorderSide(
                                                    width: 0.8,
                                                    color: Colors.white38,
                                                  )),
                                              elevation: 16,
                                              child: ExpansionTile(
                                                initiallyExpanded: true,
                                                collapsedIconColor:
                                                    Colors.white,
                                                collapsedTextColor:
                                                    Colors.white,
                                                title: RichText(
                                                  text: TextSpan(
                                                    text:
                                                        'Укажите где вы проживаете',
                                                    style: GoogleFonts.lato(
                                                      textStyle:
                                                          const TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontSize: 12,
                                                              letterSpacing:
                                                                  .9),
                                                    ),
                                                  ),
                                                ),
                                                children: [
                                                  ListTile(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        text: 'Бишкек',
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .9),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        _localController.text =
                                                            'Бишкек';
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                  ListTile(
                                                    title: RichText(
                                                      text: TextSpan(
                                                        text: 'Каракол',
                                                        style: GoogleFonts.lato(
                                                          textStyle:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12,
                                                                  letterSpacing:
                                                                      .9),
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        _localController.text =
                                                            'Каракол';
                                                        Navigator.pop(context);
                                                      });
                                                    },
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  });
                            }),
                            textFieldProfileSettings(_ageRangController, true,
                                'Диапазон поиска', context, 14, () {
                              showCupertinoModalBottomSheet(
                                  topRadius: const Radius.circular(30),
                                  duration: const Duration(milliseconds: 700),
                                  backgroundColor: color_black_88,
                                  context: context,
                                  builder: (context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                      return SizedBox(
                                        height: 200,
                                        width: width,
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 20, bottom: 60),
                                              child: RichText(
                                                text: TextSpan(
                                                  text:
                                                      'От ${_valuesAge.start} до ${_valuesAge.end} лет',
                                                  style: GoogleFonts.lato(
                                                    textStyle: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 13,
                                                        letterSpacing: .9),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SfRangeSlider(
                                              activeColor: Colors.blue,
                                              min: 16,
                                              max: 30,
                                              values: _valuesAge,
                                              stepSize: 1,
                                              enableTooltip: true,
                                              onChanged:
                                                  (SfRangeValues values) {
                                                setState(() {
                                                  _valuesAge = values;
                                                  _ageRangController.text =
                                                      'От ${_valuesAge.start} до ${_valuesAge.end} лет';
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                                  });
                            }),
                            Theme(
                              data: ThemeData.light(),
                              child: Card(
                                color: color_black_88,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    side: const BorderSide(
                                      width: 0.8,
                                      color: Colors.white38,
                                    )),
                                elevation: 10,
                                child: Container(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: MultiSelectBottomSheetField(
                                    initialValue: modelUser.userInterests,
                                    searchHintStyle:
                                        const TextStyle(color: Colors.white),
                                    buttonText: Text(
                                      'Выбрать $interestsCount максимум (6)',
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    buttonIcon: const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    backgroundColor: color_black_88,
                                    checkColor: Colors.white,
                                    confirmText: const Text('Выбрать'),
                                    cancelText: const Text('Закрыть'),
                                    searchIcon: const Icon(
                                      Icons.search,
                                      color: Colors.white,
                                    ),
                                    closeSearchIcon: const Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    searchHint: 'Поиск',
                                    searchTextStyle:
                                        const TextStyle(color: Colors.white),
                                    initialChildSize: 0.4,
                                    listType: MultiSelectListType.CHIP,
                                    searchable: true,
                                    title: Text(
                                      "Ваши интересы ${interestsCount.toString()} максимум (6)",
                                      style: const TextStyle(color: Colors.white),
                                    ),
                                    items: items,
                                    onSelectionChanged: (value) {
                                      setState(() {
                                        interestsCount = value.length;
                                      });
                                    },
                                    onConfirm: (values) {
                                      setState(() {
                                        _selectedInterests = values;
                                      });
                                    },
                                    chipDisplay: MultiSelectChipDisplay(
                                      onTap: (value) {
                                        setState(() {
                                          _selectedInterests.remove(value);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: height * .05,
                            ),
                          ],
                        ),
                      ))),
            ),
          ),
        ),
      );
    }

    return const loadingCustom();
  }
}
