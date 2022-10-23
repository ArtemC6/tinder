import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import '../data/const.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

import '../data/widget/component_widget.dart';
import '../home_manager.dart';

class DataInputUser extends StatefulWidget {
  const DataInputUser({Key? key}) : super(key: key);

  @override
  State<DataInputUser> createState() => _DataInputUserState();
}

class _DataInputUserState extends State<DataInputUser>
    with TickerProviderStateMixin {

  bool _isVisibleMyPol = true, _isVisiblePol = true, _isVisibleTime = true;
  SfRangeValues _valuesAge = const SfRangeValues(16, 50);
  int _currentStep = 0;
  String myPol = '', searchPol = '';
  DateTime _dateTimeBirthday = DateTime.now();
  var _selectedInterests = [];
  late AnimationController controller1, controller2;
  late Animation<double> animation1, animation2, animation3, animation4;
  List<Alignment> alignmentList = [Alignment.topCenter, Alignment.bottomCenter];
  int index = 0;
  Color bottomColor = const Color(0xff192028);

  @override
  void initState() {
    super.initState();

    controller1 = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );
    animation1 = Tween<double>(begin: .1, end: .15).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller1.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller1.forward();
        }
      });

    animation2 = Tween<double>(begin: .02, end: .04).animate(
      CurvedAnimation(
        parent: controller1,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    controller2 = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 5,
      ),
    );

    animation3 = Tween<double>(begin: .41, end: .38).animate(CurvedAnimation(
      parent: controller2,
      curve: Curves.easeInOut,
    ))
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller2.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller2.forward();
        }
      });
    animation4 = Tween<double>(begin: 170, end: 190).animate(
      CurvedAnimation(
        parent: controller2,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
        setState(() {});
      });

    Timer(const Duration(milliseconds: 1500), () {
      controller1.forward();
    });

    controller2.forward();

  }

  @override
  void dispose() {
    controller1.dispose();
    controller2.dispose();
    super.dispose();
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
          maxTime: DateTime(2008), onChanged: (date) {
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
          _valuesAge.end != 50 &&
          _dateTimeBirthday.year != DateTime.now().year &&
          _selectedInterests.isNotEmpty) {
        final dockUsers = FirebaseFirestore.instance.collection('User');

        final json = {
          'myPol': myPol,
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
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeMain()));
        });
      }
    }

    List<Step> listStep = [
      Step(
        state: StepState.indexed,
        isActive: _currentStep == 0,
        title: myPol == ''
            ? const Text(
                'Ваш пол',
                style: TextStyle(color: Colors.white),
              )
            : Text(
                'Ваш пол $myPol',
                style: const TextStyle(color: Colors.green),
              ),
        content: Container(
          padding: const EdgeInsets.only(
              // top: size.height / 40,
              ),
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
            // collapsedBackgroundColor: Colors.white,

            title: Text(
              myPol == '' ? 'Укажите свой пол' : myPol,
              style: const TextStyle(),
            ),
            children: [
              ListTile(
                title: const Text(
                  'Мужской',
                  style: TextStyle(color: Colors.white),
                ),
                onTap: () {
                  setState(() {
                    // _currentStep = _currentStep + 1;
                    myPol = 'Мужской';
                    _isVisibleMyPol = !_isVisibleMyPol;
                  });
                },
              ),
              ListTile(
                title: const Text('Женский',
                    style: TextStyle(color: Colors.white)),
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
            ? const Text('С кем вы хотите познакомиться',
                style: TextStyle(color: Colors.white))
            : Text('Вы хотите познакомиться ${searchPol.toLowerCase()}',
                style: const TextStyle(color: Colors.green)),
        content: ExpansionTile(
          key: GlobalKey(),
          initiallyExpanded: _isVisiblePol,
          onExpansionChanged: (changed) {
            setState(() {
              _isVisiblePol = changed;
            });
          },
          collapsedIconColor: Colors.white,
          collapsedTextColor: Colors.white,
          title: Text(
            searchPol == ''
                ? 'Укажите с кем вы хотите познакомиться'
                : searchPol,
            style: const TextStyle(),
          ),
          children: [
            ListTile(
              title: const Text(
                'С парнем',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                setState(() {
                  searchPol = 'C парнем';
                  _isVisiblePol = !_isVisiblePol;
                });
              },
            ),
            ListTile(
              title: const Text('С девушкой',
                  style: TextStyle(color: Colors.white)),
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
      Step(

        title: _dateTimeBirthday.year == DateTime.now().year
            ? const Text('Ваш возраст', style: TextStyle(color: Colors.white))
            : Text(
                'Ваш возраст ${DateTime.now().year - _dateTimeBirthday.year} лет',
                style: const TextStyle(color: Colors.green),
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
                    child: const Text(
                      'Указать совой возраст',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    )),
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
                  child: Text(
                      '${_dateTimeBirthday.year} год: ${_dateTimeBirthday.month} месяц: ${_dateTimeBirthday.day}: день',
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
      Step(
        title: _valuesAge.end == 50
            ? const Text('Диапазон поиска',
                style: TextStyle(color: Colors.white))
            : Text(
                'Диапазон поиска с ${_valuesAge.start} до ${_valuesAge.end} лет',
                style: const TextStyle(color: Colors.green)),
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
            ? const Text('Ваши интересы', style: TextStyle(color: Colors.white))
            : const Text('Ваши интересы',
                style: TextStyle(color: Colors.green)),
        content: MultiSelectBottomSheetField(
          // maxChildSize: 6,

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
          // selectedColor: Colors.red,
          // unselectedColor: Colors.purple,
          // barrierColor: Colors.blueAccent,
          // itemsTextStyle: TextStyle(color: Colors.white),
          onSelectionChanged: (value) {
            // print(value);

            // _selectedInterests = value;
            // print(value.toList());
          },
          onConfirm: (values) {

            setState(() {
              if(values.length <= 6) {
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
    ];

    return Scaffold(
      backgroundColor: color_data_input,
      body: ScrollConfiguration(
        behavior: MyBehavior(),
        child: SingleChildScrollView(
            child: SizedBox(
          // height: size.height,
          child: Stack(
            children: [
              Positioned(
                top: size.height * (animation2.value + .58),
                left: size.width * .21,
                child: CustomPaint(
                  painter: MyPainter(50),
                ),
              ),
              Positioned(
                top: size.height * .98,
                left: size.width * .1,
                child: CustomPaint(
                  painter: MyPainter(animation4.value - 30),
                ),
              ),
              Positioned(
                top: size.height * .5,
                left: size.width * (animation2.value + .8),
                child: CustomPaint(
                  painter: MyPainter(30),
                ),
              ),
              Positioned(
                top: size.height * animation3.value,
                left: size.width * (animation1.value + .1),
                child: CustomPaint(
                  painter: MyPainter(60),
                ),
              ),
              Positioned(
                top: size.height * .1,
                left: size.width * .8,
                child: CustomPaint(
                  painter: MyPainter(animation4.value),
                ),
              ),
              Column(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaY: 13,
                      sigmaX: 13,
                    ),
                    child: Stepper(
                      steps: listStep,
                      type: StepperType.vertical,
                      currentStep: _currentStep,
                      controlsBuilder:
                          (BuildContext context, ControlsDetails details) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            TextButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Вернуться'),
                            ),
                            if (_currentStep < 4)
                              TextButton(
                                onPressed: details.onStepContinue,
                                child: const Text('Далее'),
                              ),
                            if (_currentStep >= 4)
                              TextButton(
                                onPressed: () {
                                  createFirebase();
                                },
                                child: const Text('Завершить'),
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
                  ),

                  buttonComponent('Готово', 2, () {
                    createFirebase();
                  }),
                  SizedBox(height: size.height * .05),
                ],
              ),
            ],
          ),
        )),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  final double radius;

  MyPainter(this.radius);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = const LinearGradient(
              colors: [Color(0xffFD5E3D), Color(0xffC43990)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)
          .createShader(Rect.fromCircle(
        center: const Offset(0, 0),
        radius: radius,
      ));

    canvas.drawCircle(Offset.zero, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
