import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SympathyScreen extends StatefulWidget {
  const SympathyScreen({Key? key}) : super(key: key);

  @override
  State<SympathyScreen> createState() => _SympathyScreenState();
}

class _SympathyScreenState extends State<SympathyScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Text('Sympathy'),);
  }
}
