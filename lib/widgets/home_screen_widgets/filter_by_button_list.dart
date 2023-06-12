import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/type_filter.dart';
import 'package:foodCourier/providers/type_filter_provider.dart';
import 'package:foodCourier/widgets/home_screen_widgets/selection_button.dart';

final List<TypeFilter> filtersList = [
  TypeFilter('Normal', true),
  TypeFilter('Gluten Free', false),
  TypeFilter('High Protein', false),
  TypeFilter('Vegetarian', false),
  TypeFilter('Vegan', false),
];

final List<String> iconNames = [
  'assets/icons/gluten.png',
  'assets/icons/gluten.png',
  'assets/icons/protein.png',
  'assets/icons/vegetarian.png',
  'assets/icons/vegan.png'
];

class FilterByList extends StatefulWidget {
  const FilterByList({Key? key}) : super(key: key);

  @override
  FilterByListState createState() => FilterByListState();
}

class FilterByListState extends State<FilterByList> {
  final ScrollController _controller =
      ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setController();
    });
  }

  setController() {
    Provider.of<TypeFilterProvider>(context, listen: false)
                    .typeOfCurrentFilterApplied ==
                'Vegetarian' ||
            Provider.of<TypeFilterProvider>(context, listen: false)
                    .typeOfCurrentFilterApplied ==
                'Vegan'
        ? _controller.jumpTo(_controller.position.maxScrollExtent)
        : _controller.jumpTo(_controller.position.minScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 18 * SizeConfig.blockSizeVertical!,
      width: double.infinity,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        controller: _controller,
        itemBuilder: (_, index) => Row(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(SizeConfig.blockSizeVertical!),
              child: SelectionButton(
                //typeFilter: filtersList[index],
                typeFilter: TypeFilter(
                    TypeFilterProvider().filterStatus.keys.elementAt(index),
                    TypeFilterProvider().filterStatus.values.elementAt(index)),
                iconName: iconNames[index],
              ),
            ),
          ],
        ),
        itemCount: TypeFilterProvider().filterStatus.length,
        //filtersList.length, // the one will be the more filters button,
      ),
    );
  }
}
