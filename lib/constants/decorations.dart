import 'package:flutter/material.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/generated/l10n.dart';

InputDecoration kMessageTextFieldDecoration = InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: S().enterMsg,
  //'Type your message here...',
  hintStyle: const TextStyle(fontSize: 10.0, color: Color(0xFFB6C8BF)),
  border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Color(0xFFB6C8BF))),
  focusedBorder: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Color(0xFFB6C8BF))),
);

InputDecoration kReviewTextFieldDecoration = const InputDecoration(
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Enter your review here',
  hintStyle: fieldText,
  border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Color(0xFFB6C8BF))),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      borderSide: BorderSide(color: Color(0xFFB6C8BF))),
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(
    bottom: BorderSide(color: Colors.black26, width: 2.0),
  ),
);
