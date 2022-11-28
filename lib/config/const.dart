import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

const color_blue_90 = Color(0xff192028);
const color_black_88 = Color(0xff212428);

class FadeRouteAnimation extends PageRouteBuilder {
  final Widget page;

  FadeRouteAnimation(this.page)
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: page,
          ),
        );
}

final List<String> interestsList = [
  "Фильмы",
  "Музыка",
  "Книги",
  "Спорт",
  "Путешествие",
  "Киберспорт",
  "Кулинария",
  "Мотоциклы",
  "Искусство",
  "Автомобили",
  "Волонтёрство",
  "Велоспорт",
  "TikTok",
  "Instagram",
  'Танцы',
  'Рукоделие',
  'Астрология',
  'Рыбалка',
  'Поэзия',
];

const List months = [
  'янв.',
  'февр.',
  'марта',
  'апр.',
  'мая',
  'июня',
  'июля',
  'авг.',
  'сент.',
  'окт.',
  'нояб.',
  'декаб.',
];

final items = interestsList
    .map((animal) => MultiSelectItem<String>(animal, animal))
    .toList();

DateTime getDataTime(Timestamp startDate) {
  DateTime dateTimeStart = startDate.toDate();
  return dateTimeStart;
}

String filterDate(lastDateOnline) {
  String time = '';
  try {
    if (DateTime.now().difference(getDataTime(lastDateOnline)).inDays >= 1) {
      time = '${getDataTime(lastDateOnline).day} '
          '${months[getDataTime(lastDateOnline).month - 1]} в ${getDataTime(lastDateOnline).hour}: ${getDataTime(lastDateOnline).minute}';
    } else {
      time =
          '${getDataTime(lastDateOnline).hour}: ${getDataTime(lastDateOnline).minute}';
    }
  } catch (error) {}
  return time;
}

Future<bool> getState(time) async {
  bool isWriteUser = true;
  await Future.delayed(Duration(milliseconds: time), () {
    isWriteUser = false;
  });
  return isWriteUser;
}

const List<IconData> listOfIcons = [
  Icons.home_rounded,
  Icons.favorite_rounded,
  Icons.message,
  Icons.person_rounded,
];
