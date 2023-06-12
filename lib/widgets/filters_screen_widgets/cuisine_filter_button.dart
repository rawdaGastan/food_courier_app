import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/providers/filters_api_provider.dart';
import 'package:food_courier/models/type_filter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CuisineFilterButton extends StatefulWidget {
  // because this button will be used both for restriction and cuisine filters
  final TypeFilter typeFilter;
  const CuisineFilterButton({
    Key? key,
    required this.typeFilter,
  }) : super(key: key);

  @override
  CuisineFilterButtonState createState() => CuisineFilterButtonState();
}

class CuisineFilterButtonState extends State<CuisineFilterButton> {
  bool isPreferred = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig();
    double hBlock = SizeConfig.blockSizeHorizontal!,
        vBlock = SizeConfig.blockSizeVertical!;
    return GestureDetector(
      onTap: () {
        setState(() {
          isPreferred = !isPreferred;
          isPreferred
              ? // add cuisine to all filters provider
              Provider.of<AllFiltersProvider>(context, listen: false)
                  .addCuisine(widget.typeFilter.type)
              //else delete cuisine from provider cuisine list
              : Provider.of<AllFiltersProvider>(context, listen: false)
                  .deleteCuisine(widget.typeFilter.type);
        });
      },
      child: Container(
        width: 42 * hBlock,
        height: 7 * vBlock,
        decoration: BoxDecoration(
          color: isPreferred ? primaryColor : disabledCuisine,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AutoSizeText(
              widget.typeFilter.type,
              textAlign: TextAlign.left,
              style: cuisineButtonText,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }
}
