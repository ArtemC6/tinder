import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/chip_display/multi_select_chip_display.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../data/const.dart';
import '../data/model/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isLoading = false;
  late UserModel modelUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _ageRangController = TextEditingController();
  String _dropDownUserPol = '', _dropDownSearchPol = '';
  var _selectedInterests = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  List<String> listImageUri = [], listImagePath = [];
  DateTime _dateTimeBirthday = DateTime.now();
  SfRangeValues _valuesAge = const SfRangeValues(16, 50);

  void showDatePicker() {
    DatePicker.showDatePicker(context,
        theme: const DatePickerTheme(
            backgroundColor: color_data_input,
            cancelStyle: TextStyle(color: Colors.white),
            itemStyle: TextStyle(color: Colors.white)),
        showTitleActions: true,
        minTime: DateTime(1970),
        maxTime: DateTime(2008), onChanged: (date) {
      setState(() {
        // _isVisibleTime = false;
        _dateTimeBirthday = date;
        _ageController.text =
            (DateTime.now().year - _dateTimeBirthday.year).toString();
      });
    },
        onConfirm: (date) {},
        currentTime: DateTime.now(),
        locale: LocaleType.ru);
  }

  Future<void> _uploadFirstImage() async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 24, maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        var task = storage.ref(fileName).putFile(imageFile);

        if (task == null) return;

        final snapshot = await task.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        listImagePath.add(fileName);
        listImageUri.add(urlDownload);

        final docUser = await FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid);

        final json = {
          'listImageUri': listImageUri,
          'listImagePath': listImagePath
        };

        docUser.update(json).then((value) {
          Navigator.pushReplacement(
              context, FadeRouteAnimation(const EditProfileScreen()));
        });

        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  Future<void> _uploadImage() async {
    final picker = ImagePicker();
    XFile? pickedImage;
    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.gallery, imageQuality: 24, maxWidth: 1920);

      final String fileName = path.basename(pickedImage!.path);
      File imageFile = File(pickedImage.path);

      try {
        var task = storage.ref(fileName).putFile(imageFile);

        if (task == null) return;

        final snapshot = await task.whenComplete(() {});
        final urlDownload = await snapshot.ref.getDownloadURL();

        listImagePath.add(fileName);
        listImageUri.add(urlDownload);

        // listImageUri.addAll(modelUser.userImage.removeLast());

        final docUser = await FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid);

        final json = {
          'listImageUri': listImageUri,
          'listImagePath': listImagePath
        };

        docUser.update(json).then((value) {
          Navigator.pushReplacement(
              context, FadeRouteAnimation(const EditProfileScreen()));
        });

        setState(() {});
      } on FirebaseException catch (error) {
        if (kDebugMode) {
          print(error);
        }
      }
    } catch (err) {
      if (kDebugMode) {
        print(err);
      }
    }
  }

  Future<void> _uploadData() async {
    final docUser = await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid);

    final json = {
      'listInterests': _selectedInterests,
      'myPol': _dropDownUserPol,
      'name': _nameController.text,
      'searchPol': _dropDownSearchPol,
      'myAge': _dateTimeBirthday,
      'rangeStart': _valuesAge.start,
      'rangeEnd': _valuesAge.end,
    };

    docUser.update(json).then((value) {
      Navigator.pushReplacement(
          context, FadeRouteAnimation(const EditProfileScreen()));
    });
  }

  void readFirebase() async {
    await FirebaseFirestore.instance
        .collection('User')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;

      setState(() {
        modelUser = UserModel(
            name: data['name'],
            uid: data['uid'],
            age: data['myAge'],
            userPol: data['myPol'],
            searchPol: data['searchPol'],
            searchRangeStart: data['rangeStart'],
            userInterests: List<String>.from(data['listInterests']),
            userImagePath: List<String>.from(data['listImagePath']),
            userImageUrl: List<String>.from(data['listImageUri']),
            searchRangeEnd: data['rangeEnd']);
      });
    });

    setState(() {
      _nameController.text = modelUser.name;
      _ageRangController.text =
          'От ${modelUser.searchRangeStart.toInt()} до ${modelUser.searchRangeEnd.toInt()} лет';
      _ageController.text =
          (DateTime.now().year - getDataTimeDate(modelUser.age).year)
              .toString();
      _dropDownUserPol = modelUser.userPol;
      _dropDownSearchPol = modelUser.searchPol;
      // _dropDownUserPol = modelUser.userPol;
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
    print(isLoading);

    if (isLoading) {
      return Scaffold(
        backgroundColor: color_data_input,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40, bottom: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Edit profile',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                letterSpacing: .9),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 24,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 120,
                  width: 120,
                  child: Card(
                    shadowColor: Colors.white30,
                    color: color_data_input,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: const BorderSide(
                          width: 0.8,
                          color: Colors.white30,
                        )),
                    elevation: 4,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        if (modelUser.userImageUrl.isNotEmpty)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: CachedNetworkImage(
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(100)),
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              progressIndicatorBuilder:
                                  (context, url, progress) => Center(
                                child: SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 0.8,
                                    value: progress.progress,
                                  ),
                                ),
                              ),
                              imageUrl: modelUser.userImageUrl[0],
                              fit: BoxFit.cover,
                              // height: 166,
                              // width: MediaQuery.of(context).size.width
                            ),
                          ),
                        if (modelUser.userImageUrl.isEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              _uploadImage();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                'images/ic_add.png',
                                height: 23,
                                width: 23,
                              ),
                            ),
                          ),
                        if (modelUser.userImageUrl.isNotEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              _uploadImage();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                'images/edit_icon.png',
                                height: 25,
                                width: 25,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 80,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: RichText(
                        text: TextSpan(
                          text: _nameController.text,
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                letterSpacing: .9),
                          ),
                        ),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaY: 17, sigmaX: 17),
                        child: InkWell(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () {},
                          child: Container(
                            height: 45,
                            width: 90,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(.05),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Text(
                              'Сохронить',
                              style: TextStyle(
                                  color: Colors.white.withOpacity(.8)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Theme(
                    data: ThemeData.dark(), // HERE
                    child: Column(
                      children: [
                        TextField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            labelText: 'Имя',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Theme(
                    data: ThemeData.dark(), // HERE
                    child: Column(
                      children: [
                        TextField(
                          enableInteractiveSelection: false,
                          readOnly: true,
                          onTap: () {
                            showDatePicker();
                          },
                          controller: _ageController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            labelText: 'Возраст',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  height: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ваш пол',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 58,
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: color_data_input,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          hint: _dropDownUserPol == ''
                              ? const Text(
                                  'Ваш пол ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              : Text(
                                  _dropDownUserPol,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: TextStyle(color: Colors.blue),
                          items: ['Мужской', 'Женский'].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(() {
                              _dropDownUserPol = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 90,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Вы ищите',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 58,
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: color_data_input,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          hint: _dropDownSearchPol == ''
                              ? const Text(
                                  'Вы ищите',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              : Text(
                                  _dropDownSearchPol,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: TextStyle(color: Colors.blue),
                          items: ['Мужчину', 'Девушку'].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(() {
                              _dropDownSearchPol = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Theme(
                    data: ThemeData.dark(), // HERE
                    child: Column(
                      children: [
                        TextField(
                          enableInteractiveSelection: false,
                          readOnly: true,
                          onTap: () {
                            showCupertinoModalBottomSheet(
                                topRadius: const Radius.circular(30),
                                duration: const Duration(milliseconds: 700),
                                backgroundColor: color_data_input,
                                context: context,
                                builder: (context) {
                                  return StatefulBuilder(
                                      builder: (context, setState) {
                                    return Container(
                                      height: 200,
                                      padding: const EdgeInsets.only(
                                          // top: size.height / 40,
                                          ),
                                      width: MediaQuery.of(context).size.width,
                                      child: SfRangeSlider(
                                        activeColor: Colors.blue,
                                        min: 16,
                                        max: 50,
                                        values: _valuesAge,
                                        stepSize: 1,
                                        enableTooltip: true,
                                        onChanged: (SfRangeValues values) {
                                          setState(() {
                                            _valuesAge = values;
                                          });
                                        },
                                      ),
                                    );
                                  });
                                });
                          },
                          controller: _ageRangController,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            labelText: 'Диапазон поиска',
                            labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  // height: 80,

                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: MultiSelectBottomSheetField(
                    initialValue: modelUser.userInterests,
                    searchHintStyle: const TextStyle(color: Colors.white),
                    buttonText: const Text(
                      'Выбрать',
                      style: TextStyle(color: Colors.white),
                    ),
                    buttonIcon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    backgroundColor: color_data_input,
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
                    searchTextStyle: const TextStyle(color: Colors.white),
                    initialChildSize: 0.4,
                    listType: MultiSelectListType.CHIP,
                    searchable: true,
                    title: const Text(
                      "Ваши интересы максимум (6)",
                      style: TextStyle(color: Colors.white),
                    ),
                    items: items,
                    onSelectionChanged: (value) {
                      setState(() {
                        if (value.length <= 6) {
                          print(value.length);
                          _selectedInterests = value;
                        }
                      });
                    },
                    onConfirm: (values) {
                      setState(() {
                        if (values.length <= 6) {
                          _selectedInterests = values;
                        }
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
                const SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
        backgroundColor: color_data_input,
        body: Center(
          child: LoadingAnimationWidget.fourRotatingDots(
            size: 44,
            color: Colors.blueAccent,
          ),
        ));
  }
}
