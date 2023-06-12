import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/providers/type_filter_provider.dart';
import 'package:food_courier/widgets/filters_screen_widgets/restriction_check_box.dart';

class RestrictionsList extends StatelessWidget {
  final Function callbackFun;

  const RestrictionsList(this.callbackFun, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: const ScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        /*childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 6),*/
        childAspectRatio: MediaQuery.of(context).size.width /
            (MediaQuery.of(context).size.height / 3),
      ),
      itemBuilder: (_, index) => RestrictionCheckBox(
        restriction: Provider.of<TypeFilterProvider>(context, listen: false)
            .restrictionsList[index],
        callbackFun: callbackFun,
      ),
      itemCount: Provider.of<TypeFilterProvider>(context, listen: false)
          .restrictionsList
          .length,
      shrinkWrap: true,
    );
  }
}
