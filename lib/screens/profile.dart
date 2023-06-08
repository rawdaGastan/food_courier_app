import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_place_picker_mb/google_maps_place_picker.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/models/user.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/input_text_field.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'map.dart';
import 'package:foodCourier/providers/user_provider.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  ProfileState createState() => ProfileState();
}

class ProfileState extends State<Profile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController homeAddressController = TextEditingController();
  TextEditingController workAddressController = TextEditingController();
  TextEditingController dietPeriodController = TextEditingController();

  late PickResult addressSelectedPlace;
  late PickResult workSelectedPlace;

  late User user;

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
                      dropdownValue = dietPeriods[index];
                      dietPeriodController.text = dietPeriods[index];
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

  showProfile() async {
    String userToken =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .userToken;
    await Provider.of<UserProvider>(context, listen: false)
        .getProfile(userToken);
    user = Provider.of<UserProvider>(context, listen: false).user;
    emailController.text = user.email;
    mobileController.text = user.phone;
    nameController.text = user.firstName + user.lastName;
    ageController.text = user.dateOfBirth;
    dietPeriodController.text = user.durationOfDiet;
  }

  updateProfile() async {
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
    Future.delayed(const Duration(seconds: 1), () {
      showProfile();
    });
    Future.delayed(const Duration(seconds: 1), () {
      showAuthUserData();
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: whiteColor,
        leading: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: blackColor,
            size: 6 * SizeConfig.blockSizeHorizontal!,
          ),
        ),
        centerTitle: true,
        title: Text(
          S().myProfile,
          style: titleText,
        ),
        actions: [
          TextButton(
            onPressed: () async {
              updateProfile();
            },
            child: Text(
              S().save,
              style: saveText,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 2 * SizeConfig.blockSizeVertical!,
                  ),
                  child: CircleAvatar(
                    radius: 10 * SizeConfig.blockSizeHorizontal!,
                    backgroundColor: backgroundImages,
                    backgroundImage: const AssetImage(
                      'assets/icons/temp.png',
                    ),
                  ),
                ),
              ),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: titleText,
                    children: <TextSpan>[
                      TextSpan(
                        text: S().changePicture,
                        //'Change profile picture',
                        style: blueText,
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    ],
                  ),
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
            ],
          ),
        ),
      ),
    );
  }
}
