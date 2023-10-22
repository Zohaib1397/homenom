import 'package:flutter/material.dart';

final kInputFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(40),
    borderSide: BorderSide.none,
  ),
  errorStyle: TextStyle(
    color: Colors.black
  ),
);

const kAppBackgroundColor = const Color(0xFFB55157);
const kDefaultBorderRadius = 16.0;
const kRatingStarIconSize = 10.0;