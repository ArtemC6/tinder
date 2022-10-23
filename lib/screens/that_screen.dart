import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThatScreen extends StatefulWidget {
  const ThatScreen({Key? key}) : super(key: key);

  @override
  State<ThatScreen> createState() => _ThatScreenState();
}

class _ThatScreenState extends State<ThatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(
      child: Column(
        children: [
          // Image.asset('images/ic_road.jpg'),
        ],
      ),
    ));
  }
}


