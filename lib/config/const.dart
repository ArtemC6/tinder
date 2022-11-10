import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

import '../model/interests_model.dart';

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
  'Января',
  'Февроля',
  'Марта',
  'Апреля',
  'Мая',
  'Июня',
  'Июля',
  'Августа',
  'Сентября',
  'Октябтя',
  'Ноября',
  'Декабря',
];

final List<InterestsModel> listStoryMain = [
  InterestsModel(
      name: 'Кулинария',
      id: '',
      uri:
          'https://img4.goodfon.ru/original/1920x1200/1/6b/bliny-iagody-klubnika-miata-golubika-zavarnik.jpg'),
  InterestsModel(
      name: 'Поэзия', id: '', uri: 'https://stihi.ru/pics/2018/09/13/7754.jpg'),
  InterestsModel(
      name: 'Рыбалка',
      id: '',
      uri:
          'https://1.bp.blogspot.com/-nBjPYBR36p0/Wm6Vmi190ZI/AAAAAAAAP8I/zhwEYeJVs_0ukeNju1uwPT25W4N_mR0HwCLcBGAs/s400/pexels-photo-69224.jpeg'),
  InterestsModel(
      name: 'Астрология',
      id: '',
      uri: 'https://laverdad.com.mx/wp-content/uploads/2020/08/1.0-24.jpg'),
  InterestsModel(
      name: 'Танцы',
      id: '',
      uri:
          'https://c.wallhere.com/photos/0c/82/hip_hop_women_handstand-93440.jpg!d'),
  InterestsModel(
      name: 'Рукоделие',
      id: '',
      uri:
          'https://i.pinimg.com/originals/6b/bc/bb/6bbcbbaa54e81a0b4ce77331859914e5.jpg'),
  InterestsModel(
      name: 'Музыка',
      id: '',
      uri: 'https://www.5.ua/media/pictures/400x266/223580.jpg?t=1625939573'),
  InterestsModel(
      name: 'Книги',
      id: '',
      uri: 'https://cdn.cadelta.ru/media/covers/8/id8159/cover.jpg'),
  InterestsModel(
      name: 'Фильмы',
      id: '',
      uri: 'https://pbs.twimg.com/media/Ev3SWW4WEAQY29Q.jpg'),
  InterestsModel(
      name: 'Спорт',
      id: '',
      uri: 'https://images.satu.kz/134017387_w640_h640_trenazhery.jpg'),
  InterestsModel(
      name: 'Путешествие',
      id: '',
      uri:
          'https://destinationkarakol.com/wp-content/uploads/2021/03/Alakul-lake-22000-x-1333-300x200.jpg'),
  InterestsModel(
      name: 'Киберспорт',
      id: '',
      uri:
          'https://sportx.kz/wp-content/uploads/2022/07/WhatsApp-Image-2022-07-27-at-15.34.16-scaled.jpeg'),
  InterestsModel(
      name: 'Мотоциклы',
      id: '',
      uri:
          'https://i.pinimg.com/736x/f0/f0/95/f0f09554c77d52330106dfb4c4f03f78.jpg'),
  InterestsModel(
      name: 'Искусство',
      id: '',
      uri:
          'http://2.bp.blogspot.com/-ExUR8Gle6wY/UjC7xPLj-JI/AAAAAAAAAB0/X4dHTbmFxLk/s320/road-to-happiness.jpg'),
  InterestsModel(
      name: 'Автомобили',
      id: '',
      uri:
          'https://i.pinimg.com/736x/da/d9/f6/dad9f66f6d4d4e61355e5f54c32371aa.jpg'),
  InterestsModel(
      name: 'Волонтёрство',
      id: '',
      uri:
          'https://sun1-88.userapi.com/s/v1/ig2/mxScRpUTIpONkIoXf5mwojDx8pYiz7ZH1DAZ-rW14UFfMcHcsoN2vazoqtNrdpqaUmYGsVnrPXiTTTFq5rOhXcN8.jpg?size=200x0&quality=96&crop=265,0,1708,1708&ava=1'),
  InterestsModel(
      name: 'Велоспорт',
      id: '',
      uri:
          'https://sportishka.com/uploads/posts/2022-03/1648589724_6-sportishka-com'
          '-p-velosiped-dlya-triatlona-sport-krasivie-fo-6.jpg'),
  InterestsModel(
      name: 'TikTok',
      id: '',
      uri: 'https://pbs.twimg.com/media/EMK6NtfXsAAZsrS.png:large'),
  InterestsModel(
      name: 'Instagram',
      id: '',
      uri:
          'https://floop.top/ru/wp-content/uploads/sites/3/2021/06/screenshot-at-jun-13-15-34-08-335x220.png'),
];

final items = interestsList
    .map((animal) => MultiSelectItem<String>(animal, animal))
    .toList();

DateTime getDataTimeDate(Timestamp startDate) {
  DateTime dateTimeStart = startDate.toDate();
  return dateTimeStart;
}

const List<IconData> listOfIcons = [
  Icons.home_rounded,
  Icons.favorite_rounded,
  Icons.message,
  Icons.person_rounded,
];

showAlertDialogLoading(BuildContext context) {
  AlertDialog alert = AlertDialog(
    backgroundColor: Colors.transparent,
    shadowColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    actions: [
      Center(
          child: LoadingAnimationWidget.dotsTriangle(
        size: 44,
        color: Colors.blueAccent,
      )),
    ],
  );

  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
