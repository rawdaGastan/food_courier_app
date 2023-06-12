import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/screens/verification_code.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/api_authentication_button.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/or_divider.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/input_text_field.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class Registration extends StatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  RegistrationState createState() => RegistrationState();
}

class RegistrationState extends State<Registration> {
  bool _isEnabled = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  //TextEditingController _controller = TextEditingController(text: '');

  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
  bool isMobile = false;
  String phoneOrEmail = S().emailOrPhone;
  //'Email/Phone Number';
  String emailOrPhoneValue = '';
  late CountryCode countryCode;

  @override
  void initState() {
    super.initState();
    getMobileNumber();
  }

  getMobileNumber() async {
    final SmsAutoFill autoFill = SmsAutoFill();
    final completePhoneNumber = await autoFill.hint;
    if (completePhoneNumber != null) {
      setState(() {
        isMobile = true;
        _emailController.text = completePhoneNumber.substring(3);
        emailOrPhoneValue = completePhoneNumber;
      });
    }
  }

  displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
        ),
      );

  displayTermsAndConditions(context, title, text) => showDialog(
        context: context,
        builder: (context) => Dialog(
          child: SizedBox(
            height: 75 * SizeConfig.blockSizeVertical!,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 15.0,
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      );

  signUp() async {
    if (emailOrPhoneValue != '' && isMobile == true) {
      String error =
          await Provider.of<AuthenticationProvider>(context, listen: false)
              .mobileVerify(emailOrPhoneValue);
      if (error == '') {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerificationCodeScreen(
              isRegisteredUser: false,
              emailOrPhoneValue: emailOrPhoneValue,
            ),
          ),
        );
      } else {
        displayDialog(context, 'error', error);
      }
    } else {
      var email = _emailController.text;
      var password = _passwordController.text;
      var response =
          await Provider.of<AuthenticationProvider>(context, listen: false)
              .register(email, password, password, 'empty');
      List<String> responseList = [
        'verificationSent',
        'email',
        'password1',
        'phone_number',
        'customer',
        'invitation',
        'non_field_errors'
      ];

      if (response != null) {
        if (response == responseList[0]) {
          Navigator.pushNamed(context, 'login');
        } else {
          List<String> errorDialogContent = [];
          for (int i = 1; i < responseList.length; i++) {
            if (response[responseList[i]] != null) {
              errorDialogContent.add(
                  '${responseList[i]} : ${response[responseList[i]].join('\n')}');
            }
          }
          displayDialog(
              context, 'Invalid registration', errorDialogContent.join('\n'));
        }
      } else {
        displayDialog(context, 'Error', 'An unknown error occurred.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: whiteColor,
      body: Center(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    top: 2 * SizeConfig.blockSizeVertical!,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.arrow_back_ios,
                              color: blackColor,
                              size: 4 * SizeConfig.blockSizeHorizontal!,
                            ),
                            Text(S().back, style: blackSmallText14),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 5 * SizeConfig.blockSizeVertical!,
                  backgroundColor: backgroundImages,
                ),
                SizedBox(
                  height: 2 * SizeConfig.blockSizeVertical!,
                ),
                Text(
                  S().CreateAccount,
                  //'Create account',
                  style: titleText,
                ),
                Text(
                  S().CreateAccountDescription,
                  //'Sign up to Lorem Ipsum is simply dummy',
                  style: subTitleText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 4 * SizeConfig.blockSizeVertical!,
                ),
                ApiButton(
                  leading: Image.asset('assets/icons/facebook.png',
                      width: 8 * SizeConfig.blockSizeHorizontal!),
                  action: () {},
                  label: S().faceBook,
                  //'  Facebook',
                ),
                SizedBox(
                  height: 2 * SizeConfig.blockSizeVertical!,
                ),
                ApiButton(
                  leading: Image.asset('assets/icons/google.png',
                      width: 8 * SizeConfig.blockSizeHorizontal!),
                  action: () {},
                  label: S().google,
                  //'  Google',
                ),
                const OrDivider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.blockSizeHorizontal!),
                  child: InputField(
                    onChanged: (text) {
                      //emailOrPhoneValue = text;
                      //emailOrPhoneValue = '($countryCode) $text';
                      if (numericRegex.hasMatch(text)) {
                        setState(() => isMobile = true);
                        phoneOrEmail = S().phone;
                        //'Phone Number';
                        emailOrPhoneValue = '($countryCode) $text';
                      } else {
                        setState(() => isMobile = false);
                        phoneOrEmail = S().email;
                        //'Email';
                        emailOrPhoneValue = text;
                      }
                      if (text == '') {
                        phoneOrEmail = S().emailOrPhone;
                        setState(() => isMobile = false);
                      }
                    },
                    prefix: isMobile
                        ? SizedBox(
                            height: 3 * SizeConfig.blockSizeVertical!,
                            width: 30 * SizeConfig.blockSizeHorizontal!,
                            child: CountryCodePicker(
                              onInit: (countryCode) {
                                this.countryCode = countryCode!;
                              },
                              onChanged: (countryCode) {},
                              initialSelection: 'EG',
                              favorite: const ['+20', 'EG'],
                              showCountryOnly: false,
                              showOnlyCountryWhenClosed: false,
                              alignLeft: false,
                              textStyle: fillFieldText,
                            ),
                          )
                        : Container(),
                    controller: _emailController,
                    isObscure: false,
                    label: phoneOrEmail,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: S()
                              .errorRequiredMailOrPhone /*'Email or Phone is required'*/),
                      PatternValidator(
                          r'(^([\w-\.]+@([\w-]+\.)+[\w-]{2,4})|([1]{1}?[0-9]{9})$)',
                          errorText: S()
                              .errorInvalidMailOrPhone /*'Invalid Email or Phone Number'*/),
                    ]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.blockSizeHorizontal!),
                  child: InputField(
                    onChanged: (String input) {},
                    controller: _passwordController,
                    label: S().password,
                    //'Password',
                    type: TextInputType.text,
                    isObscure: true,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: S()
                              .errorRequiredPassword /*'password is required'*/),
                      MinLengthValidator(8,
                          errorText: S()
                              .errorMinLengthPassword /*'password must be at least 8 digits'*/),
                      PatternValidator(r'(?=.*?[#?!@$%^&*-_])',
                          errorText: S()
                              .errorSpecialCharacterPassword /*'passwords must have at least one special character'*/),
                    ]),
                  ),
                ),
                MainButton(
                  label: S().signUp,
                  action: _isEnabled
                      ? () async {
                          if (formKey.currentState!.validate()) {
                            signUp();
                          }
                        }
                      : () {},
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Checkbox(
                        value: _isEnabled,
                        checkColor: whiteColor,
                        activeColor: blueTextColor,
                        onChanged: (_) {
                          setState(() {
                            _isEnabled = !_isEnabled;
                          });
                        }),
                    Padding(
                      padding: EdgeInsets.only(
                          right: SizeConfig.blockSizeHorizontal!),
                      child: RichText(
                        //maxLines: 2,
                        overflow: TextOverflow.clip,
                        text: TextSpan(
                          //style: kLabel,
                          children: <TextSpan>[
                            TextSpan(
                                style: agreeOfTermsText,
                                text: S().agreeOf //'I Agree with our '
                                ),
                            TextSpan(
                                text: S().terms, //'Terms',
                                style: blueText,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    displayTermsAndConditions(
                                        context, 'dummy', 'dummy');
                                  }),
                            TextSpan(
                                style: agreeOfTermsText, text: S().and //' and '
                                ),
                            TextSpan(
                                text: S().conditions, //'Conditions',
                                style: blueText,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    displayTermsAndConditions(
                                        context, 'dummy', 'dummy');
                                  }),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: SizeConfig.blockSizeVertical!,
                ),
                RichText(
                  text: TextSpan(
                    style: blackSmallText15,
                    children: <TextSpan>[
                      TextSpan(
                          text: S()
                              .alreadyHaveAccount /*'Already have an account? '*/),
                      TextSpan(
                          text: S().signIn, //'Sign in',
                          style: greenSmallText15,
                          recognizer: TapGestureRecognizer()
                            ..onTap =
                                () => Navigator.pushNamed(context, 'login')),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
