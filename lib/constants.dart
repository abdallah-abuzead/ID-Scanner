import 'package:flutter/material.dart';

import 'app_data.dart';

final kTextFieldDecoration = InputDecoration(
  hintText: 'Password',
  hintStyle: TextStyle(color: AppData.placeholderColor),
  contentPadding: EdgeInsets.only(left: 30, right: 10, top: 20, bottom: 20),
  filled: true,
  fillColor: Color(0XFFF2F2F2),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
    borderSide: BorderSide.none,
  ),
);

final kOtherSignInTextStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12);
