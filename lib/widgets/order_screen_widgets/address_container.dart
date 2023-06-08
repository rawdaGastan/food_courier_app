import 'package:flutter/material.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';

class AddressContainer extends StatefulWidget {
  final String address;
  final TextEditingController controller;

  const AddressContainer(
      {Key? key, required this.address, required this.controller})
      : super(key: key);

  @override
  AddressContainerState createState() => AddressContainerState();
}

class AddressContainerState extends State<AddressContainer> {
  bool editAddress = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6 * SizeConfig.blockSizeVertical!,
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: lightTextColor),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            height: 6 * SizeConfig.blockSizeVertical!,
            padding: EdgeInsets.symmetric(
                horizontal: 3 * SizeConfig.blockSizeHorizontal!),
            width: 75 * SizeConfig.blockSizeHorizontal!,
            child: TextFormField(
              controller: widget.controller,
              enabled: editAddress,
              style: fillFieldText,
              decoration: InputDecoration(
                hintText: widget.address,
                hintStyle: fieldText,
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: lightTextColor)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: primaryColor)),
                contentPadding:
                    const EdgeInsets.fromLTRB(10.0, 10.0, 20.0, 10.0),
              ),
            ),
          ),
          Container(
            width: 12 * SizeConfig.blockSizeHorizontal!,
            height: 6 * SizeConfig.blockSizeVertical!,
            color: primaryColor,
            child: IconButton(
                icon: const Icon(
                  Icons.mode_edit,
                  color: whiteColor,
                ),
                onPressed: () {
                  setState(() {
                    editAddress = !editAddress;
                  });
                }),
          ),
        ],
      ),
    );
  }
}
