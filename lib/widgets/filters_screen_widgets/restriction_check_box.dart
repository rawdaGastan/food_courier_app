import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';
import 'package:foodCourier/models/restriction.dart';
import 'package:foodCourier/providers/type_filter_provider.dart';
import 'package:auto_size_text/auto_size_text.dart';

class RestrictionCheckBox extends StatefulWidget {
  final Restriction restriction;
  final Function? callbackFun;

  const RestrictionCheckBox(
      {Key? key, required this.restriction, this.callbackFun})
      : super(key: key);

  @override
  RestrictionCheckBoxState createState() => RestrictionCheckBoxState();
}

class RestrictionCheckBoxState extends State<RestrictionCheckBox> {
  bool clicked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(3.0),
      decoration: BoxDecoration(
        color: Provider.of<TypeFilterProvider>(context)
                .getRestrictionState(widget.restriction.name)
            ? orangeColor
            : secondaryColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Visibility(
        visible: //this will be triggered when a filter type is applied
            !Provider.of<TypeFilterProvider>(context)
                .getRestrictionState(widget.restriction.name),
        replacement: GestureDetector(
          onTap: () {
            setState(() {
              widget.restriction.toggle();
              Provider.of<TypeFilterProvider>(context, listen: false)
                  .filterByRestrict();
              widget.callbackFun!();
            });
          },
          child: ListTile(
            title: AutoSizeText(
              widget.restriction.name,
              textAlign: TextAlign.center,
              style: restrictionBoxText.copyWith(
                decoration: TextDecoration.lineThrough,
                height: 0.5,
              ),
            ),
          ),
        ),
        child: ListTile(
          title: AutoSizeText(
            widget.restriction.name,
            textScaleFactor: 1.0,
            style: restrictionBoxText,
            maxLines: 1,
            textAlign: TextAlign.center,
          ),
          onTap: () {
            setState(() {
              widget.restriction.toggle();
              widget.restriction.restriction
                  ? // add restriction to filters provider
                  Provider.of<AllFiltersProvider>(context, listen: false)
                      .addRestriction(widget.restriction.name)
                  // else delete the restriction from filters provider
                  : Provider.of<AllFiltersProvider>(context, listen: false)
                      .deleteRestriction(widget.restriction.name);

              Provider.of<TypeFilterProvider>(context, listen: false)
                  .filterByRestrict();
              widget.callbackFun!();
            });
          },
          dense: true,
        ),
      ),
    );
  }
}
