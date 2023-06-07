import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/filters_api_provider.dart';
import 'package:foodCourier/models/type_filter.dart';
import 'package:auto_size_text/auto_size_text.dart';

class CuisineFilterButton extends StatefulWidget {
  // because this button will be used both for restriction and cuisine filters
  final TypeFilter typeFilter;
  CuisineFilterButton({
    @required this.typeFilter,
  });
  @override
  _State createState() => _State();
}

class _State extends State<CuisineFilterButton> {
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
