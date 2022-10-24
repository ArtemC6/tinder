import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

const color_auth = Color(0xff192028);
const color_data_input = Color(0xff212428);
const black_86 = Color(0xFF2D2D2D);

showAlertDialogLoad(BuildContext context) {
  AlertDialog alert = AlertDialog(
      content: Container(
    decoration: const BoxDecoration(
      shape: BoxShape.rectangle,
      color: Color(0xFFFFFF),
      borderRadius: BorderRadius.all(Radius.circular(32.0)),
    ),
    child: Row(
      children: [
        const CircularProgressIndicator(),
        Container(
            margin: const EdgeInsets.only(left: 18),
            child: const Text("Загрузка...")),
      ],
    ),
  ));
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

class Animal {
  final int id;
  final String name;

  Animal({
    required this.id,
    required this.name,
  });
}

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
  "Социальные развлечение",
  "Просмотр сериалов",
  "Вечеринки",
  "Музыка",
  "Чтение",
  "Спорт",
  "Путешествия",
  "Катание на лыжах",
  "Киберспорт",
  "Рисование",
  "Кулинария",
  "Искусство",
  "Волонтёрство",
  "Пеший туризм",
  "Велоспорт",
  "TikTok",
];

final items = interestsList
    .map((animal) => MultiSelectItem<String>(animal, animal))
    .toList();

DateTime getDataTimeDate(Timestamp startDate) {
  DateTime dateTimeStart = startDate.toDate();
  return dateTimeStart;
}
