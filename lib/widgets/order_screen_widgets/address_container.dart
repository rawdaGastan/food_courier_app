import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';

class AddressContainer extends StatefulWidget {
  final String address;
  final TextEditingController controller;
  bool editAddress = false;
  AddressContainer({this.address, this.controller});

  @override
  _AddressContainerState createState() => _AddressContainerState();
}

class _AddressContainerState extends State<AddressContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6 * SizeConfig.blockSizeVertical,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: lightTextColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            height: 6 * SizeConfig.blockSizeVertical,
            padding: EdgeInsets.symmetric(
                horizontal: 3 * SizeConfig.blockSizeHorizontal),
            width: 75 * SizeConfig.blockSizeHorizontal,
            child: TextFormField(
              controller: widget.controller,
              enabled: widget.editAddress,
              style: fillFieldText,
              decoration: InputDecoration(
                hintText: widget.address,
                hintStyle: fieldText,
                enabledBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: lightTextColor)),
                focusedBorder: new UnderlineInputBorder(
                    borderSide: new BorderSide(color: primaryColor)),
                contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
              ),
            ),
          ),
          Container(
            width: 12 * SizeConfig.blockSizeHorizontal,
            height: 6 * SizeConfig.blockSizeVertical,
            color: primaryColor,
            child: IconButton(
                icon: Icon(
                  Icons.mode_edit,
                  color: whiteColor,
                ),
                onPressed: () {
                  setState(() {
                    widget.editAddress = !widget.editAddress;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
