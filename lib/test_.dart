import 'package:flutter/material.dart';

class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(height: 100, width : 50, color:Colors.blueAccent),
              Spacer(flex: 2,),
              Container(height: 50, width : 50, color:Colors.blueAccent),
              Spacer(flex: 2,),
              Container(height: 200, width : 50, color:Colors.blueAccent),
            ],
          ),
        ),
      ),
    );
  }
}
