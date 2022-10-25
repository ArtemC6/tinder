import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../data/const.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/widget/component_widget.dart';
import '../home_manager.dart';
import '../settings/edit_profile_screen.dart';

class DataInputUser extends StatefulWidget {
  const DataInputUser({Key? key}) : super(key: key);

  @override
  State<DataInputUser> createState() => _DataInputUserState();
}

class _DataInputUserState extends State<DataInputUser>
    with TickerProviderStateMixin {
  bool _isVisibleMyPol = true,
      _isVisiblePol = true,
      _isVisibleTime = true,
      _isVisibleLocation = true,
      _isError = false;

  SfRangeValues _valuesAge = const SfRangeValues(16, 50);
  int _currentStep = 0, index = 0;
  String myPol = '', searchPol = '', myLocation = '';
  DateTime _dateTimeBirthday = DateTime.now();
  var _selectedInterests = [];
  List<Alignment> alignmentList = [Alignment.topCenter, Alignment.bottomCenter];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

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
          _isVisibleTime = false;
          _dateTimeBirthday = date;
        });
      },
          onConfirm: (date) {},
          currentTime: DateTime.now(),
          locale: LocaleType.ru);
    }

    createFirebase() async {
      if (myPol != '' &&
          searchPol != '' &&
          myLocation != '' &&
          _valuesAge.end != 50 &&
          _dateTimeBirthday.year != DateTime.now().year &&
          _selectedInterests.isNotEmpty &&
          _selectedInterests.length <= 6) {
        final dockUsers = FirebaseFirestore.instance.collection('User');

        final json = {
          'myPol': myPol,
          'myCity': myLocation,
          'searchPol': searchPol == 'С парнем' ? 'Парня' : 'Девушку',
          'rangeStart': _valuesAge.start,
          'rangeEnd': _valuesAge.end,
          'myAge': _dateTimeBirthday,
          'listInterests': _selectedInterests,
          'listImagePath': [],
          'listImageUri': [],
        };

        dockUsers
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .update(json)
            .then((value) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => EditProfileScreen(
                    isFirst: false,
                  )));
        });
      } else {
        setState(() {
          _isError = true;
        });
      }
    }

    List<Step> listStep = [
      Step(
        state: StepState.indexed,
        isActive: _currentStep == 0,
        title: myPol == ''
            ? RichText(
                text: TextSpan(
                  text: 'Ваш пол',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  text: 'Ваш пол ${myPol.toLowerCase()}',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.green, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              ),
        content: Card(
          shadowColor: Colors.white30,
          color: color_data_input,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white38,
              )),
          elevation: 16,
          child: ExpansionTile(
            key: GlobalKey(),
            initiallyExpanded: _isVisibleMyPol,
            onExpansionChanged: (changed) {
              setState(() {
                _isVisibleMyPol = changed;
              });
            },
            collapsedIconColor: Colors.white,
            collapsedTextColor: Colors.white,
            title: RichText(
              text: TextSpan(
                text: myPol == '' ? 'Укажите свой пол' : myPol,
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white, fontSize: 12, letterSpacing: .9),
                ),
              ),
            ),
            children: [
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Мужской',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 12, letterSpacing: .9),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    myPol = 'Мужской';
                    _isVisibleMyPol = !_isVisibleMyPol;
                  });
                },
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Женский',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 12, letterSpacing: .9),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    myPol = 'Женский';
                    _isVisibleMyPol = !_isVisibleMyPol;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        isActive: _currentStep == 1,
        state: StepState.indexed,
        title: searchPol == ''
            ? RichText(
                text: TextSpan(
                  text: 'С кем вы хотите познакомиться',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  text: 'Вы хотите познакомиться ${searchPol.toLowerCase()}',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.green, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              ),
        content: Card(
          shadowColor: Colors.white30,
          color: color_data_input,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white30,
              )),
          elevation: 16,
          child: ExpansionTile(
            key: GlobalKey(),
            initiallyExpanded: _isVisiblePol,
            onExpansionChanged: (changed) {
              setState(() {
                _isVisiblePol = changed;
              });
            },
            collapsedIconColor: Colors.white,
            collapsedTextColor: Colors.white,
            title: RichText(
              text: TextSpan(
                text: 'С кем вы хотите познакомиться',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white, fontSize: 12, letterSpacing: .9),
                ),
              ),
            ),
            children: [
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'С парнем',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 12, letterSpacing: .9),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    searchPol = 'C парнем';
                    _isVisiblePol = !_isVisiblePol;
                  });
                },
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'С девушкой',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 12, letterSpacing: .9),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    searchPol = 'C девушкой';
                    _isVisiblePol = !_isVisiblePol;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: _dateTimeBirthday.year == DateTime.now().year
            ? RichText(
                text: TextSpan(
                  text: 'Ваш возраст',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  text:
                      'Ваш возраст ${DateTime.now().year - _dateTimeBirthday.year} лет',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.green, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              ),
        content: Column(
          children: [
            if (_isVisibleTime)
              Container(
                padding: const EdgeInsets.only(
                    // top: size.height / 30,
                    ),
                width: size.width,
                child: TextButton(
                  onPressed: () {
                    showDatePicker();
                  },
                  child: RichText(
                    text: TextSpan(
                      text: 'Указать совой возраст',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            letterSpacing: .9),
                      ),
                    ),
                  ),
                ),
              ),
            if (!_isVisibleTime)
              Container(
                padding: const EdgeInsets.only(
                    // top: size.height / 30,
                    ),
                width: size.width,
                child: TextButton(
                  onPressed: () {
                    showDatePicker();
                  },
                  child: RichText(
                    text: TextSpan(
                      text:
                          '${_dateTimeBirthday.year} год: ${_dateTimeBirthday.month} месяц: ${_dateTimeBirthday.day}',
                      style: GoogleFonts.lato(
                        textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            letterSpacing: .9),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      Step(
        // isActive: _currentStep == 1,
        state: StepState.indexed,
        title: myLocation == ''
            ? RichText(
                text: TextSpan(
                  text: 'Где вы проживаете',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  text: 'Вы проживаете в $myLocation',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.green, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              ),
        content: Card(
          shadowColor: Colors.white30,
          color: color_data_input,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: const BorderSide(
                width: 0.8,
                color: Colors.white30,
              )),
          elevation: 16,
          child: ExpansionTile(
            key: GlobalKey(),
            initiallyExpanded: _isVisibleLocation,
            onExpansionChanged: (changed) {
              setState(() {
                _isVisibleLocation = changed;
              });
            },
            collapsedIconColor: Colors.white,
            collapsedTextColor: Colors.white,
            title: RichText(
              text: TextSpan(
                text: 'Вы проживаете',
                style: GoogleFonts.lato(
                  textStyle: const TextStyle(
                      color: Colors.white, fontSize: 12, letterSpacing: .9),
                ),
              ),
            ),
            children: [
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Бишкек',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 12, letterSpacing: .9),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    myLocation = 'Бишкик';
                    _isVisibleLocation = !_isVisibleLocation;
                  });
                },
              ),
              ListTile(
                title: RichText(
                  text: TextSpan(
                    text: 'Каракол',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.white, fontSize: 12, letterSpacing: .9),
                    ),
                  ),
                ),
                onTap: () {
                  setState(() {
                    myLocation = 'Каракол';
                    _isVisibleLocation = !_isVisibleLocation;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: _valuesAge.end == 50
            ? RichText(
                text: TextSpan(
                  text: 'Диапазон поиска',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  text:
                      'Диапазон поиска с ${_valuesAge.start} до ${_valuesAge.end} лет',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.green, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              ),
        content: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  // top: size.height / 40,
                  ),
              width: size.width,
              child: SfRangeSlider(
                activeColor: Colors.blue,
                min: 16,
                max: 50,
                values: _valuesAge,
                stepSize: 1,
                // enableTooltip: true,
                onChanged: (SfRangeValues values) {
                  setState(() {
                    _valuesAge = values;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      Step(
        title: _selectedInterests.isEmpty
            ? RichText(
                text: TextSpan(
                  text: 'Ваши интересы',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.white, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              )
            : RichText(
                text: TextSpan(
                  text: 'Ваши интересы',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                        color: Colors.green, fontSize: 12, letterSpacing: .9),
                  ),
                ),
              ),
        content: Card(
          shadowColor: Colors.white30,
          color: color_data_input,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
              side: const BorderSide(
                width: 1,
                color: Colors.white30,
              )),
          elevation: 16,
          child: MultiSelectBottomSheetField(
            searchHintStyle: const TextStyle(color: Colors.white),
            buttonText: const Text(
              'Выбрать',
              style: TextStyle(color: Colors.white),
            ),
            buttonIcon: const Icon(
              Icons.search,
              color: Colors.white,
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
      ),
    ];

    return Scaffold(
      backgroundColor: color_data_input,
      body: SingleChildScrollView(
          child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[color_auth, color_data_input]),
        ),
        child: Column(
          children: [
            Stepper(
              physics: const NeverScrollableScrollPhysics(),
              steps: listStep,
              type: StepperType.vertical,
              currentStep: _currentStep,
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: details.onStepCancel,
                      // child: const Text('Вернуться'),
                      child: RichText(
                        text: TextSpan(
                          text: 'Вернуться',
                          style: GoogleFonts.lato(
                            textStyle: const TextStyle(
                                color: Colors.blue,
                                fontSize: 12,
                                letterSpacing: .9),
                          ),
                        ),
                      ),
                    ),
                    if (_currentStep < 5)
                      TextButton(
                        onPressed: details.onStepContinue,
                        child: RichText(
                          text: TextSpan(
                            text: 'Далее',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  letterSpacing: .9),
                            ),
                          ),
                        ),
                      ),
                    if (_currentStep >= 5)
                      TextButton(
                        onPressed: () {
                          createFirebase();
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Завершить',
                            style: GoogleFonts.lato(
                              textStyle: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  letterSpacing: .9),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
              onStepContinue: () {
                setState(() {
                  if (_currentStep < listStep.length - 1) {
                    _currentStep = _currentStep + 1;

                    if (_currentStep == 2) {
                      showDatePicker();
                    }
                  } else {
                    _currentStep = 0;
                  }
                });
              },
              onStepCancel: () {
                setState(() {
                  if (_currentStep > 0) {
                    _currentStep = _currentStep - 1;
                  } else {
                    _currentStep = 0;
                  }
                });
              },
            ),
            if (_isError)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: 'Некаректно введены данные',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                          color: Colors.red, fontSize: 12, letterSpacing: .9),
                    ),
                  ),
                ),
              ),
            Card(
              shadowColor: Colors.white30,
              color: color_auth,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                  side: const BorderSide(
                    width: 0.8,
                    color: Colors.white54,
                  )),
              elevation: 10,
              child: buttonComponent('Готово', 2, () {
                createFirebase();
              }),
            ),
            SizedBox(height: size.height * .05),
          ],
        ),
      )),
    );
  }
}
