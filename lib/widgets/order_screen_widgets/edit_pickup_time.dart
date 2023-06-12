import 'package:flutter/material.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/controllers/size_config.dart';

class EditPickUpTime extends StatefulWidget {
  const EditPickUpTime({Key? key}) : super(key: key);

  @override
  EditPickUpTimeState createState() => EditPickUpTimeState();
}

class EditPickUpTimeState extends State<EditPickUpTime> {
  Map<String, String> days = {
    'Tuesday': '5/1',
    'Wednesday': '6/1',
    'Thursday': '7/1',
    'Friday': '8/1',
    'Saturday': '9/1',
    'Sunday': '10/1',
  };

  Map<String, String> times = {
    '6 pm': '00',
    '7 pm': '00',
    '8 pm': '00',
    '9 pm': '00',
    '10 pm': '00',
    '11 pm': '00',
  };

  GlobalKey<ScrollSnapListState> sslKey = GlobalKey();
  int _focusedIndex = 0;
  int _focusedIndexTime = 0;

  @override
  void initState() {
    super.initState();
  }

  void _onItemFocus(int index) {
    setState(() {
      _focusedIndex = index;
    });
  }

  void _onItemFocusTime(int index) {
    setState(() {
      _focusedIndexTime = index;
    });
  }

  Widget _buildListItem(BuildContext context, int index) {
    if (index == days.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_focusedIndex == index) {
      return SizedBox(
        width: 16 * SizeConfig.blockSizeVertical!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              days.keys.elementAt(index),
              style: pickUpDayFocused,
            ),
            Text(
              days.values.elementAt(index),
              style: pickUpDateFocused,
            ),
          ],
        ),
      );
    } else {
      return SizedBox(
        width: 16 * SizeConfig.blockSizeVertical!,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              days.keys.elementAt(index),
              style: pickUpDateFocused,
            ),
            Text(
              days.values.elementAt(index),
              style: pickUpDateFocused,
            ),
          ],
        ),
      );
    }
  }

  Widget _timeBuildListItem(BuildContext context, int index) {
    return SizedBox(
      height: 5 * SizeConfig.blockSizeVertical!,
      child: InkWell(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              width: 20 * SizeConfig.blockSizeHorizontal!,
              height: 5 * SizeConfig.blockSizeVertical!,
              color: _focusedIndexTime == index ? secondaryColor : whiteColor,
              child: Text(times.keys.elementAt(index), style: pickUpTime),
            ),
            const Text(' : ', style: pickUpTime),
            Container(
              alignment: Alignment.center,
              width: 20 * SizeConfig.blockSizeHorizontal!,
              height: 5 * SizeConfig.blockSizeVertical!,
              color: _focusedIndexTime == index ? secondaryColor : whiteColor,
              child: Text(times.values.elementAt(index), style: pickUpTime),
            ),
          ],
        ),
        onTap: () {
          sslKey.currentState!.focusToItem(index);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25 * SizeConfig.blockSizeVertical!,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ScrollSnapList(
              onItemFocus: _onItemFocus,
              itemSize: 16 * SizeConfig.blockSizeVertical!,
              itemBuilder: _buildListItem,
              itemCount: days.length,
              dynamicItemSize: true,
            ),
          ),
          const Divider(),
          Container(
            alignment: Alignment.center,
            height: 15 * SizeConfig.blockSizeVertical!,
            child: ScrollSnapList(
              onItemFocus: _onItemFocusTime,
              itemSize: 5 * SizeConfig.blockSizeVertical!,
              // selectedItemAnchor: SelectedItemAnchor.START, //to change item anchor uncomment this line
              // dynamicItemOpacity: 0.3, //to set unselected item opacity uncomment this line
              itemBuilder: _timeBuildListItem,
              itemCount: times.length,
              key: sslKey,
              scrollDirection: Axis.vertical,
            ),
          ),
        ],
      ),
    );
  }
}
