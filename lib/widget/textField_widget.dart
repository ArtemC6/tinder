import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Widget textFieldAuth(String hint, TextEditingController controller,
    IconData icon, Size size, bool isPassword, int length) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(15),
    child: BackdropFilter(
      filter: ImageFilter.blur(
        sigmaY: 15,
        sigmaX: 15,
      ),
      child: Container(
        height: size.width / 8,
        width: size.width / 1.2,
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: size.width / 30),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextField(
          obscureText: isPassword,
          inputFormatters: [
            LengthLimitingTextInputFormatter(length),
          ],
          controller: controller,
          style: TextStyle(color: Colors.white.withOpacity(.8)),
          cursorColor: Colors.white,
          decoration: InputDecoration(
            prefixIcon: Icon(
              icon,
              color: Colors.white.withOpacity(.7),
            ),
            border: InputBorder.none,
            hintMaxLines: 1,
            hintText: hint,
            hintStyle:
                TextStyle(fontSize: 14, color: Colors.white.withOpacity(.5)),
          ),
        ),
      ),
    ),
  );
}

Widget textFieldProfileSettings(TextEditingController nameController,
    bool isLook, String hint, BuildContext context, int length, VoidCallback onTap) {
  return SizedBox(
    height: MediaQuery.of(context).size.height * .11,
    child: Theme(
      data: ThemeData.dark(),
      child: Column(
        children: [
          TextField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(length),
            ],
            enableInteractiveSelection: isLook,
            readOnly: isLook,
            onTap: onTap,
            controller: nameController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.arrow_forward_ios_outlined,
                color: Colors.white,
                size: 18,
              ),
              labelText: hint,
              labelStyle: const TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
