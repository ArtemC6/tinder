import 'dart:io';
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
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:tinder/screens/auth/signin_screen.dart';

import '../data/const.dart';
import '../data/firebase_auth.dart';
import '../data/model/user_model.dart';
import '../profile_screen.dart';

class EditProfileScreen extends StatefulWidget {
  bool isFirst;

  EditProfileScreen({Key? key, required this.isFirst}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState(isFirst);
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isFirst = false;

  _EditProfileScreenState(this.isFirst);

  bool isLoading = false, isError = false;
  late UserModel modelUser;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _ageRangController = TextEditingController();
  String _dropDownUserPol = '', _dropDownSearchPol = '', _dropDownLocal = '';
  var _selectedInterests = [];
  FirebaseStorage storage = FirebaseStorage.instance;
  List<String> listImageUri = [], listImagePath = [];
  DateTime _dateTimeBirthday = DateTime.now();
  late SfRangeValues _valuesAge;

  List<String> listProfileImage = [];
  List<String> listProfilePath = [];

  void showDatePicker() {
    DatePicker.showDatePicker(context,
        theme: const DatePickerTheme(
            backgroundColor: color_data_input,
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

        final docUser = FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid);

        final json = {
          'listImageUri': listImageUri,
          'listImagePath': listImagePath
        };

        docUser.update(json).then((value) {
          Navigator.pushReplacement(
              context,
              FadeRouteAnimation(EditProfileScreen(
                isFirst: false,
              )));
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

        await storage.ref(modelUser.userImagePath[0]).delete();

        modelUser.userImageUrl.removeAt(0);
        modelUser.userImagePath.removeAt(0);

        listImagePath.add(fileName);
        listImageUri.add(urlDownload);

        listImagePath.addAll(modelUser.userImagePath);
        listImageUri.addAll(modelUser.userImageUrl);

        final docUser = FirebaseFirestore.instance
            .collection('User')
            .doc(FirebaseAuth.instance.currentUser?.uid);

        final json = {
          'listImageUri': listImageUri,
          'listImagePath': listImagePath
        };

        docUser.update(json).then((value) {
          Navigator.pushReplacement(
              context,
              FadeRouteAnimation(EditProfileScreen(
                isFirst: false,
              )));
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

  // Future<void> _uploadImage() async {
  //   final picker = ImagePicker();
  //   XFile? pickedImage;
  //   try {
  //     pickedImage = await picker.pickImage(
  //         source: ImageSource.gallery);
  //
  //     final String fileName = path.basename(pickedImage!.path);
  //     File imageFile = File(pickedImage.path);
  //
  //     try {
  //       var task = storage.ref(fileName).putFile(imageFile);
  //
  //       if (task == null) return;
  //
  //       final snapshot = await task.whenComplete(() {});
  //       final urlDownload = await snapshot.ref.getDownloadURL();
  //       //
  //       // await storage.ref(modelUser.userImagePath[0]).delete();
  //       //
  //       // modelUser.userImageUrl.removeAt(0);
  //       // modelUser.userImagePath.removeAt(0);
  //       //
  //       // listImagePath.add(fileName);
  //       // listImageUri.add(urlDownload);
  //       //
  //       // listImagePath.addAll(modelUser.userImagePath);
  //       // listImageUri.addAll(modelUser.userImageUrl);
  //
  //
  //
  //       listProfileImage.add(urlDownload.toString());
  //       listProfilePath.add(snapshot.toString());
  //
  //       final docUser = FirebaseFirestore.instance
  //           .collection('ImageProfile')
  //           .doc('Image');
  //
  //       final json = {
  //         'listProfileImage': listProfileImage,
  //         'listProfilePath': listProfilePath
  //       };
  //
  //       docUser.set(json).then((value) {
  //         Navigator.pushReplacement(
  //             context,
  //             FadeRouteAnimation(EditProfileScreen(
  //               isFirst: false,
  //             )));
  //       });
  //
  //       setState(() {});
  //     } on FirebaseException catch (error) {
  //       if (kDebugMode) {
  //         print(error);
  //       }
  //     }
  //   } catch (err) {
  //     if (kDebugMode) {
  //       print(err);
  //     }
  //   }
  // }

  Future<void> _uploadData() async {
    if (_selectedInterests.isNotEmpty &&
        _selectedInterests.length <= 6 &&
        _dropDownUserPol.isNotEmpty &&
        _nameController.text.length >= 3 &&
        _dropDownSearchPol.isNotEmpty &&
        _dropDownLocal.isNotEmpty &&
        modelUser.userImageUrl.isNotEmpty) {
      final docUser = FirebaseFirestore.instance
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
        'myCity': _dropDownLocal,
      };

      docUser.update(json).then((value) {
        Navigator.pushReplacement(
            context, FadeRouteAnimation(const ProfileScreen()));
      });
    } else {
      setState(() {
        isError = true;
      });
    }
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
            searchRangeEnd: data['rangeEnd'],
            myCity: data['myCity'], imageBackground: data['imageBackground']);
      });
    });

    setState(() {
      _nameController.text = modelUser.name;
      _ageRangController.text =
          'От ${modelUser.searchRangeStart.toInt()} до ${modelUser.searchRangeEnd.toInt()} лет';
      _ageController.text =
          (DateTime.now().year - getDataTimeDate(modelUser.age).year)
              .toString();
      _valuesAge =
          SfRangeValues(modelUser.searchRangeStart, modelUser.searchRangeEnd);
      _dropDownUserPol = modelUser.userPol;
      _dropDownLocal = modelUser.myCity;
      _dropDownSearchPol = modelUser.searchPol;
      isLoading = true;
      _selectedInterests = modelUser.userInterests;
      _dateTimeBirthday = getDataTimeDate(modelUser.age);
    });
  }

  @override
  void initState() {
    readFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: color_data_input,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (!isFirst)
                        IconButton(
                          color: Colors.white,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 20),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            // print('object');
                            await context
                                .read<FirebaseAuthMethods>()
                                .signOut(context);

                            await Navigator.push(context,
                                FadeRouteAnimation(const SignInScreen()));
                          },
                          child: Image.asset(
                            'images/ic_log_out.png',
                            height: 30,
                            width: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
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
                    elevation: 6,
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
                              // height: 166,
                              // width: MediaQuery.of(context).size.width
                            ),
                          ),
                        if (modelUser.userImageUrl.isEmpty)
                          InkWell(
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () {
                              _uploadFirstImage();
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
                    const SizedBox(
                      width: 80,
                    ),
                    SizedBox(
                      height: 40,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(width: 0.7, color: Colors.white30),
                          gradient: const LinearGradient(
                              colors: [Colors.blueAccent, Colors.purpleAccent]),
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
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          child: RichText(
                            text: TextSpan(
                              text: isFirst ? 'Завершить' : 'Сохронить',
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
                Container(
                  height: 74,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                              size: 18,
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
                  height: 74,
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                              size: 18,
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
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  height: 86,
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
                        height: 54,
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: color_data_input,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 18,
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
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(color: Colors.blue),
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
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
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
                        height: 54,
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: color_data_input,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 18,
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
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(color: Colors.blue),
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
                  height: 90,
                  padding: const EdgeInsets.only(top: 8, bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Вы проживаете',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12),
                      ),
                      SizedBox(
                        height: 54,
                        child: DropdownButton(
                          focusColor: Colors.white,
                          dropdownColor: color_data_input,
                          icon: const Padding(
                            padding: EdgeInsets.only(right: 14),
                            child: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          hint: _dropDownLocal == ''
                              ? const Text(
                                  '',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                )
                              : Text(
                                  _dropDownLocal,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 15),
                                ),
                          isExpanded: true,
                          iconSize: 30.0,
                          style: const TextStyle(color: Colors.blue),
                          items: ['Каракол', 'Бишкек'].map(
                            (val) {
                              return DropdownMenuItem<String>(
                                value: val,
                                child: Text(val),
                              );
                            },
                          ).toList(),
                          onChanged: (val) {
                            setState(() {
                              _dropDownLocal = val!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.only(top: 2, bottom: 10),
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
                                            max: 50,
                                            values: _valuesAge,
                                            stepSize: 1,
                                            enableTooltip: true,
                                            onChanged: (SfRangeValues values) {
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
                          },
                          controller: _ageRangController,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          decoration: const InputDecoration(
                            suffixIcon: Icon(
                              Icons.arrow_forward_ios_outlined,
                              color: Colors.white,
                              size: 18,
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
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                      size: 18,
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
                    // onSelectionChanged: (value) {
                    //   setState(() {
                    //     // if (value.length <= 6) {
                    //     //   print(value.length);
                    //     _selectedInterests = value;
                    //     // }
                    //   });
                    // },
                    onConfirm: (values) {
                      setState(() {
                        // if (values.length <= 6) {
                        _selectedInterests = values;
                        // }
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
                // const SizedBox(
                //   height: 50,
                // ),
              ],
            ),
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
