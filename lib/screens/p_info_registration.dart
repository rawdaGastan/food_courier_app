import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/models/user.dart';
import 'package:food_courier/providers/authentication_provider.dart';
import 'package:food_courier/widgets/authentication_screens_widgets/input_text_field.dart';
import 'package:food_courier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:food_courier/screens/map.dart';
import 'package:food_courier/generated/l10n.dart';
import 'package:food_courier/providers/user_provider.dart';

class PersonalInfoRegistration extends StatefulWidget {
  const PersonalInfoRegistration({Key? key}) : super(key: key);

  @override
  PersonalInfoRegistrationState createState() =>
      PersonalInfoRegistrationState();
}

class PersonalInfoRegistrationState extends State<PersonalInfoRegistration> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController workAddressController = TextEditingController();
  TextEditingController dietPeriodController = TextEditingController();

  late User user;

  late PickResult addressSelectedPlace;
  late PickResult workSelectedPlace;

  String dropdownValue = S().now;
  List<String> dietPeriods = [S().now, S().week, S().month, S().year];

  displayDialog(context) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(0 * SizeConfig.blockSizeHorizontal!),
          content: SizedBox(
            height: 24 * SizeConfig.blockSizeVertical!,
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
                      border: const Border(
                        bottom: BorderSide(color: primaryColor, width: 1.0),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                        horizontal: 3 * SizeConfig.blockSizeHorizontal!),
                    height: 6 * SizeConfig.blockSizeVertical!,
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
    await Provider.of<UserProvider>(context, listen: false)
        .getUserData(userToken);
    user = Provider.of<UserProvider>(context, listen: false).user;
    emailController.text = user.email;
    mobileController.text = user.phone;
  }

  setProfileInfo() async {
    String firstName = '';
    String lastName = '';
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    if (nameController.text.split(' ').length > 1) {
      firstName = nameController.text.split(' ')[0];
      lastName = nameController.text.split(' ')[1];
    } else {
      firstName = nameController.text.split(' ')[0];
    }
    var response = await Provider.of<UserProvider>(context, listen: false)
        .updateUserData(userToken, firstName, lastName, ageController.text,
            dietPeriodController.text);
    if (response != null) Navigator.pushNamed(context, 'preferences reg');
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
                size: 2.5 * SizeConfig.blockSizeHorizontal!,
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
            activeSize: Size(8 * SizeConfig.blockSizeHorizontal!,
                SizeConfig.blockSizeVertical!),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 3 * SizeConfig.blockSizeVertical!,
                  bottom: 3 * SizeConfig.blockSizeVertical!,
                  left: 5 * SizeConfig.blockSizeHorizontal!,
                  right: 5 * SizeConfig.blockSizeHorizontal!,
                ),
                child: Text(
                  S().personalInfo,
                  //'Personal Information',
                  style: titleText,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5 * SizeConfig.blockSizeHorizontal!,
                    top: 2 * SizeConfig.blockSizeVertical!,
                    right: 5 * SizeConfig.blockSizeHorizontal!),
                child: Text(
                  S().userName,
                  //'Name',
                  style: blackSmallText15,
                ),
              ),
              InputField(
                label: '',
                isObscure: false,
                controller: nameController,
                onChanged: (input) {},
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5 * SizeConfig.blockSizeHorizontal!,
                    top: 2 * SizeConfig.blockSizeVertical!,
                    right: 5 * SizeConfig.blockSizeHorizontal!),
                child: Text(
                  S().userAge,
                  //'Age',
                  style: blackSmallText15,
                ),
              ),
              InputField(
                label: '',
                isObscure: false,
                controller: ageController,
                onChanged: (input) {},
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: 5 * SizeConfig.blockSizeHorizontal!,
                    left: 5 * SizeConfig.blockSizeHorizontal!),
                child: Text(
                  S().phone,
                  style: blackSmallText15,
                ),
              ),
              InputField(
                label: '',
                isObscure: false,
                controller: mobileController,
                onChanged: (input) {},
              ),
              Padding(
                padding: EdgeInsets.only(
                    right: 5 * SizeConfig.blockSizeHorizontal!,
                    left: 5 * SizeConfig.blockSizeHorizontal!),
                child: Text(
                  S().email,
                  style: blackSmallText15,
                ),
              ),
              InputField(
                label: '',
                isObscure: false,
                controller: emailController,
                onChanged: (input) {},
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5 * SizeConfig.blockSizeHorizontal!,
                    top: 2 * SizeConfig.blockSizeVertical!,
                    right: 5 * SizeConfig.blockSizeHorizontal!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S().userAddress,
                      //'Address',
                      style: blackSmallText15,
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location),
                      color: locationIconColor,
                      onPressed: () async {
                        addressSelectedPlace = await openMap(context);
                        setState(() {
                          addressSelectedPlace = addressSelectedPlace;
                          homeAddressController.text =
                              addressSelectedPlace.formattedAddress as String;
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
                isObscure: false,
                controller: homeAddressController,
                onChanged: (input) {},
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5 * SizeConfig.blockSizeHorizontal!,
                    top: 2 * SizeConfig.blockSizeVertical!,
                    right: 5 * SizeConfig.blockSizeHorizontal!),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      S().userWorkAddress,
                      //'Work Address',
                      style: blackSmallText15,
                    ),
                    IconButton(
                      icon: const Icon(Icons.my_location),
                      color: locationIconColor,
                      onPressed: () async {
                        workSelectedPlace = await openMap(context);
                        setState(() {
                          workSelectedPlace = workSelectedPlace;
                          workAddressController.text =
                              addressSelectedPlace.formattedAddress as String;
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
                label: '',
                isObscure: false,
                controller: workAddressController,
                onChanged: (input) {},
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 5 * SizeConfig.blockSizeHorizontal!,
                    top: 2 * SizeConfig.blockSizeVertical!,
                    right: 5 * SizeConfig.blockSizeHorizontal!),
                child: Text(
                  S().dietPeriod,
                  //'How long have been following Diet ?',
                  style: blackSmallText15,
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 5 * SizeConfig.blockSizeHorizontal!),
                height: 9 * SizeConfig.blockSizeVertical!,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
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
                      child: Container(
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: primaryColor, width: 2.0),
                          ),
                        ),
                        //margin: EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Text(
                              dropdownValue,
                              style: blackSmallText14,
                            ),
                            const Icon(
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
    );
  }
}
