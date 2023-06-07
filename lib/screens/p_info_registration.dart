import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/user.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/input_textField.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/screens/map.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/providers/user_provider.dart';

class PersonalInfoRegistration extends StatefulWidget {
  @override
  _PersonalInfoRegistrationState createState() =>
      _PersonalInfoRegistrationState();
}

class _PersonalInfoRegistrationState extends State<PersonalInfoRegistration> {
  TextEditingController nameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController homeAddressController = new TextEditingController();
  TextEditingController workAddressController = new TextEditingController();
  TextEditingController dietPeriodController = new TextEditingController();

  User user;

  PickResult addressSelectedPlace;
  PickResult workSelectedPlace;

  String dropdownValue = S().now;
  List<String> dietPeriods = [S().now, S().week, S().month, S().year];

  displayDialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0 * SizeConfig.blockSizeHorizontal),
          content: Container(
            height: 24 * SizeConfig.blockSizeVertical,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: dietPeriods.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      dietPeriodController.text = dietPeriods[index];
                      dropdownValue = dietPeriods[index];
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: dropdownValue == dietPeriods[index]
                          ? primaryColor
                          : secondaryColor,
                      border: Border(
                        bottom: BorderSide(color: primaryColor, width: 1.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 3 * SizeConfig.blockSizeHorizontal),
                    height: 6 * SizeConfig.blockSizeVertical,
                    child: Text(
                      dietPeriods[index],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      );

  showAuthUserData() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (userToken != null) {
      await Provider.of<UserProvider>(context, listen: false)
          .getUserData(userToken);
      user = Provider.of<UserProvider>(context, listen: false).user;
      emailController.text = user.email;
      mobileController.text = user.phone;
    }
  }

  setProfileInfo() async {
    String firstName = '';
    String lastName = '';
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (userToken != null) {
      print(nameController.text.split(" "));
      if (nameController.text.split(" ").length > 1) {
        firstName = nameController.text.split(" ")[0];
        lastName = nameController.text.split(" ")[1];
      } else {
        firstName = nameController.text.split(" ")[0];
      }
      var response = await Provider.of<UserProvider>(context, listen: false)
          .updateUserData(userToken, firstName, lastName, ageController.text,
              dietPeriodController.text);
      if (response != null) Navigator.pushNamed(context, 'preferences reg');
    }
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      showAuthUserData();
    });
    return Scaffold(
      backgroundColor: whiteColor,
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: blackColor,
                size: 2.5 * SizeConfig.blockSizeHorizontal,
              ),
              Text(S().back, style: blackSmallText14),
            ],
          ),
        ),
        centerTitle: true,
        title: DotsIndicator(
          dotsCount: 2,
          position: 0,
          decorator: DotsDecorator(
            color: primaryColor, // Inactive color
            activeColor: primaryColor,
            activeSize: Size(8 * SizeConfig.blockSizeHorizontal,
                SizeConfig.blockSizeVertical),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              S().skip,
              style: greenSmallText17,
            ),
            onPressed: () => Navigator.pushNamed(context, 'preferences reg'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 3 * SizeConfig.blockSizeVertical,
                    bottom: 3 * SizeConfig.blockSizeVertical,
                    left: 5 * SizeConfig.blockSizeHorizontal,
                    right: 5 * SizeConfig.blockSizeHorizontal,
                  ),
                  child: Text(
                    S().personalInfo,
                    //'Personal Information',
                    style: titleText,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 5 * SizeConfig.blockSizeHorizontal,
                      top: 2 * SizeConfig.blockSizeVertical,
                      right: 5 * SizeConfig.blockSizeHorizontal),
                  child: Text(
                    S().userName,
                    //'Name',
                    style: blackSmallText15,
                  ),
                ),
                InputField(
                  label: '',
                  prefix: null,
                  isObscure: false,
                  controller: nameController,
                  onChanged: (input) {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 5 * SizeConfig.blockSizeHorizontal,
                      top: 2 * SizeConfig.blockSizeVertical,
                      right: 5 * SizeConfig.blockSizeHorizontal),
                  child: Text(
                    S().userAge,
                    //'Age',
                    style: blackSmallText15,
                  ),
                ),
                InputField(
                  label: '',
                  prefix: null,
                  isObscure: false,
                  controller: ageController,
                  onChanged: (input) {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: 5 * SizeConfig.blockSizeHorizontal,
                      left: 5 * SizeConfig.blockSizeHorizontal),
                  child: Text(
                    S().phone,
                    style: blackSmallText15,
                  ),
                ),
                InputField(
                  label: '',
                  prefix: null,
                  isObscure: false,
                  controller: mobileController,
                  onChanged: (input) {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                      right: 5 * SizeConfig.blockSizeHorizontal,
                      left: 5 * SizeConfig.blockSizeHorizontal),
                  child: Text(
                    S().email,
                    style: blackSmallText15,
                  ),
                ),
                InputField(
                  label: '',
                  prefix: null,
                  isObscure: false,
                  controller: emailController,
                  onChanged: (input) {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 5 * SizeConfig.blockSizeHorizontal,
                      top: 2 * SizeConfig.blockSizeVertical,
                      right: 5 * SizeConfig.blockSizeHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        S().userAddress,
                        //'Address',
                        style: blackSmallText15,
                      ),
                      IconButton(
                        icon: new Icon(Icons.my_location),
                        color: locationIconColor,
                        onPressed: () async {
                          addressSelectedPlace = await openMap(context);
                          setState(() {
                            addressSelectedPlace = addressSelectedPlace;
                            homeAddressController.text =
                                addressSelectedPlace.formattedAddress;
                          });
                        },
                      ),
                      /*RichText(
                        text: TextSpan(
                            style: openLocationText,
                            text: S().chooseLocation,
                            //'Choose specific location',
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                addressSelectedPlace = await openMap(context);
                                setState(() {
                                  addressSelectedPlace = addressSelectedPlace;
                                });
                              }),
                      ),*/
                    ],
                  ),
                ),
                InputField(
                  label: '',
                  prefix: null,
                  isObscure: false,
                  controller: homeAddressController,
                  onChanged: (input) {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 5 * SizeConfig.blockSizeHorizontal,
                      top: 2 * SizeConfig.blockSizeVertical,
                      right: 5 * SizeConfig.blockSizeHorizontal),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        S().userWorkAddress,
                        //'Work Address',
                        style: blackSmallText15,
                      ),
                      IconButton(
                        icon: new Icon(Icons.my_location),
                        color: locationIconColor,
                        onPressed: () async {
                          workSelectedPlace = await openMap(context);
                          setState(() {
                            workSelectedPlace = workSelectedPlace;
                            workAddressController.text =
                                addressSelectedPlace.formattedAddress;
                          });
                        },
                      ),
                      /*RichText(
                        text: TextSpan(
                            text:  S().chooseLocation,
                            //'choose specific location',
                            style: openLocationText,
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                  workSelectedPlace = await openMap(context);
                                  setState(() {
                                    workSelectedPlace = workSelectedPlace;
                                  });
                              }),
                      ),*/
                    ],
                  ),
                ),
                InputField(
                  label: "",
                  prefix: null,
                  isObscure: false,
                  controller: workAddressController,
                  onChanged: (input) {},
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: 5 * SizeConfig.blockSizeHorizontal,
                      top: 2 * SizeConfig.blockSizeVertical,
                      right: 5 * SizeConfig.blockSizeHorizontal),
                  child: Text(
                    S().dietPeriod,
                    //'How long have been following Diet ?',
                    style: blackSmallText15,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: 5 * SizeConfig.blockSizeHorizontal),
                  height: 9 * SizeConfig.blockSizeVertical,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      new Expanded(
                        child: InputField(
                          label: '',
                          isObscure: false,
                          controller: dietPeriodController,
                          onChanged: (input) {},
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          displayDialog(context);
                        },
                        child: new Container(
                          decoration: BoxDecoration(
                            border: Border(
                              bottom:
                                  BorderSide(color: primaryColor, width: 2.0),
                            ),
                          ),
                          //margin: new EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Text(
                                dropdownValue,
                                style: blackSmallText14,
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                size: 24,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                MainButton(
                  label: S().continueButton,
                  action: () async {
                    setProfileInfo();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
