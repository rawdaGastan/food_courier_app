import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:food_courier/constants/colors.dart';

class TagTab extends StatefulWidget {
  final String tag;
  final void Function()? animate;
  final bool isSelected;

  const TagTab(
      {Key? key, required this.tag, this.animate, required this.isSelected})
      : super(key: key);

  @override
  TabState createState() => TabState();
}

class TabState extends State<TagTab> {
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
