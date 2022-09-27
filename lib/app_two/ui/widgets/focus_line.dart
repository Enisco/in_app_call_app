
import 'package:flutter/material.dart';
import 'package:in_app_call_app/constants.dart';

Widget FocusLne(size, bool colorThis) {
  return Container(
    margin: const EdgeInsets.only(top: 3),
    width: size.width / 4.2,
    height: 2,
    color: colorThis ? kPrimaryColor : Colors.transparent,
  );
}