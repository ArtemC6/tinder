// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:tinder/screens/auth/data_input_screen.dart';
import 'package:tinder/screens/auth/signin_screen.dart';
import 'package:tinder/screens/data/firebase_auth.dart';
import 'package:tinder/screens/data/model/user_model.dart';
import 'package:tinder/screens/home_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:tinder/screens/settings/edit_image_profile_screen.dart';
import 'package:tinder/screens/settings/edit_profile_screen.dart';

void main() async {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
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
  bool isEmpty = false, isEmptyData = false, isEmptyImageBck = false;

  @override
  void initState() {
    super.initState();

    if (FirebaseAuth.instance.currentUser?.uid != null) {
      FirebaseFirestore.instance
          .collection('User')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          if (documentSnapshot['myPol'] != null) {
            setState(() {
              isEmpty = true;
            });
          }

          if (List<String>.from(documentSnapshot['listImageUri']).isNotEmpty) {
            setState(() {
              isEmptyData = true;
            });
          }
          if (documentSnapshot['imageBackground'] != '') {
            setState(() {
              isEmptyImageBck = true;
            });
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: LoadingAnimationWidget.dotsTriangle(
                size: 44,
                color: Colors.blueAccent,
              ),
            );
          } else if (snapshot.hasData) {
            if (isEmpty) {
              if (isEmptyData) {
                if (isEmptyImageBck) {
                  return HomeMain(currentIndex: 0,);
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
                      searchRangeEnd: 0),
                );
              }
            } else {
              return const DataInputUser();
            }
          } else {
            return const SignInScreen();
          }
        });
  }
}
