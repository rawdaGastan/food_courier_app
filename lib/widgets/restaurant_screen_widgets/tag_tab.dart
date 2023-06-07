import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';

class TagTab extends StatefulWidget {
  final String tag;
  final Function animate;
  final bool isSelected;
  TagTab({this.tag, this.animate, this.isSelected});

  @override
  _TabState createState() => _TabState();
}

class _TabState extends State<TagTab> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.animate,
      child: AutoSizeText(
        widget.tag,
        style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w400,
            color: widget.isSelected ? primaryColor : blackColor),
      ),
    );
  }
}
