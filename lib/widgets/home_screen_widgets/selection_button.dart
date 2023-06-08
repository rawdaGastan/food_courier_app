import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';
import 'package:foodCourier/models/type_filter.dart';
import 'package:foodCourier/providers/type_filter_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class SelectionButton extends StatefulWidget {
  // because this button will be used both for restriction and cuisine filters
  TypeFilter typeFilter;
  String iconName;

  SelectionButton({
    Key? key,
    required this.typeFilter,
    required this.iconName,
  }) : super(key: key);

  @override
  SelectionButtonState createState() => SelectionButtonState();
}

class SelectionButtonState extends State<SelectionButton> {
  onPressed() {
    setState(() {
      if (!Provider.of<TypeFilterProvider>(context, listen: false)
          .filterStatus[widget.typeFilter.type]!) {
        Provider.of<TypeFilterProvider>(context, listen: false)
            .changeFilterState(widget.typeFilter.type);
        if (widget.typeFilter.type == 'Normal') {
          Provider.of<TypeFilterProvider>(context, listen: false).showAll();
          Provider.of<AllFiltersProvider>(context, listen: false).deleteType();
        } else {
          Provider.of<TypeFilterProvider>(context, listen: false)
              .filterBy(widget.typeFilter.type);
          Provider.of<AllFiltersProvider>(context, listen: false)
              .changeType(widget.typeFilter.type);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = Provider.of<TypeFilterProvider>(context)
            .filterStatus[widget.typeFilter.type]!
        ? primaryColor
        : whiteColor;

    Color contentColor = Provider.of<TypeFilterProvider>(context)
            .filterStatus[widget.typeFilter.type]!
        ? whiteColor
        : blackColor;

    SizeConfig();
    double hBlock = SizeConfig.blockSizeHorizontal!,
        vBlock = SizeConfig.blockSizeVertical!;

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 24 * hBlock,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(color: secondaryColor, width: .3),
          boxShadow: const [
            BoxShadow(
              color: secondaryColor,
              offset: Offset(3, 5), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image(
              image: AssetImage(widget.iconName),
              width: 7 * vBlock,
              color: contentColor,
            ),
            /*SvgPicture.asset(
              widget.iconName,
              width: 7 * vBlock,
              color: contentColor,
            ),*/
            AutoSizeText(
              widget.typeFilter.type,
              textAlign: TextAlign.center,
              style: selectionButtonText.copyWith(color: contentColor),
              overflow: TextOverflow.clip,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
