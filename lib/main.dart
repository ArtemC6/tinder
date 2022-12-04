// @dart=2.9
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tinder/config/firebase_auth.dart';
import 'package:tinder/screens/auth/signin_screen.dart';
import 'package:tinder/screens/manager_screen.dart';
import 'package:tinder/screens/settings/edit_image_profile_screen.dart';
import 'package:tinder/screens/settings/edit_profile_screen.dart';
import 'package:tinder/screens/settings/warning_screen.dart';

import 'config/firestore_operations.dart';
import 'model/user_model.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Noo');
  print(message.data['uri']);
  print(message.data['uid']);
  print(message.data['type']);

}

void main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);


  runApp(const MyApp());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authState,
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(),
        darkTheme: ThemeData.dark(),
        home: const Manager(),
      ),
    );
  }
}

class Manager extends StatefulWidget {
  const Manager({Key key}) : super(key: key);

  @override
  State<Manager> createState() => _Manager();
}

class _Manager extends State<Manager> {
  bool isEmptyImageBackground = false,
      isEmptyDataUser = false,
      isStart = false,
      isLoading = false;

  @override
  void initState() {
    super.initState();
    readFirebaseIsAccountFull().then((result) {
      setState(() {
        isEmptyImageBackground = result.isEmptyImageBackground;
        isEmptyDataUser = result.isEmptyDataUser;
        isStart = result.isStart;
        isLoading = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return StreamBuilder(
          stream: FirebaseAuth.instance.userChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: LoadingAnimationWidget.dotsTriangle(
                  size: 44,
                  color: Colors.blueAccent,
                ),
              );
            } else if (snapshot.hasData) {
              if (isStart) {
                if (isEmptyDataUser) {
                  if (isEmptyImageBackground) {
                    return ManagerScreen(
                      currentIndex: 0,
                    );
                  } else {
                    return EditImageProfileScreen(
                      bacImage: '',
                    );
                  }
                } else {
                  return EditProfileScreen(
                    isFirst: true,
                    userModel: UserModel(
                        name: '',
                        uid: '',
                        myCity: '',
                        ageTime: Timestamp.now(),
                        ageInt: 0,
                        userPol: '',
                        searchPol: '',
                        searchRangeStart: 0,
                        userImageUrl: [],
                        userImagePath: [],
                        imageBackground: '',
                        userInterests: [],
                        searchRangeEnd: 0,
                        state: '',
                        token: '',
                        notification: true),
                  );
                }
              } else {
                return const WarningScreen();
              }
            } else {
              return const SignInScreen();
            }
          });
    }
    return Center(
      child: LoadingAnimationWidget.dotsTriangle(
        size: 44,
        color: Colors.blueAccent,
      ),
    );
  }
}
