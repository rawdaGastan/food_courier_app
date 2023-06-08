import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/api_authentication_button.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/or_divider.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/input_text_field.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/providers/authentication_provider.dart';

class LoginScreen extends StatefulWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
  bool isMobile = false;
  String phoneOrEmail = S().emailOrPhone;
  String emailOrPhoneValue = '';
  late CountryCode countryCode;

  @override
  void initState() {
    super.initState();
  }

  displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );

  signIn() async {
    var email = widget._emailController.text;
    var password = widget._passwordController.text;
    var response =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .login(email, password);

    if (response != null) {
      if (response == 'jwt') {
        Navigator.pushNamed(context, 'home');
      } else if (response['email'] != null) {
        displayDialog(context, 'Invalid login', response['email'].join('\n'));
      } else if (response['password'] != null) {
        displayDialog(
            context, 'Invalid login', response['password'].join('\n'));
      } else if (response['non_field_errors'] != null) {
        displayDialog(
            context, 'Invalid login', response['non_field_errors'].join('\n'));
      }
    } else {
      displayDialog(context, 'Error', 'An unknown error occurred.');
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
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
                      TextButton(
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
                  S().welcome,
                  //'Welcome',
                  style: titleText,
                ),
                Text(
                  S().loginDescription,
                  //'Sign in to Lorem Ipsum is simply dummy',
                  style: subTitleText,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 4 * SizeConfig.blockSizeVertical!,
                ),
                ApiButton(
                  leading: Image.asset('assets/icons/facebook.png',
                      width: 8 * SizeConfig.blockSizeHorizontal!),
                  action: () async {
                    await Provider.of<AuthenticationProvider>(context,
                            listen: false)
                        .facebookLogin();
                  },
                  label: S().faceBook,
                  //'  Facebook',
                  //color: Colors.lightBlueAccent,
                ),
                SizedBox(
                  height: 2 * SizeConfig.blockSizeVertical!,
                ),
                ApiButton(
                  leading: Image.asset('assets/icons/google.png',
                      width: 8 * SizeConfig.blockSizeHorizontal!),
                  action: () async {
                    await Provider.of<AuthenticationProvider>(context,
                            listen: false)
                        .googleLogin();
                  },
                  label: S().google,
                  //'  Google',
                  //color: Colors.orange[400],
                ),
                OrDivider(),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: 5 * SizeConfig.blockSizeHorizontal!),
                  child: InputField(
                    controller: widget._emailController,
                    onChanged: (text) {
                      emailOrPhoneValue = text;
                      emailOrPhoneValue = '($countryCode) $text';
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
                        : const SizedBox(),
                    isObscure: false,
                    label: phoneOrEmail,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: S()
                              .errorRequiredMailOrPhone /*'Email or Phone is required'*/),
                      //EmailAndPhoneNumberValidator(errorText: 'Invalid Input'),
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
                    controller: widget._passwordController,
                    onChanged: (String input) {},
                    label: S().password,
                    //'Password',
                    type: TextInputType.text,
                    isObscure: true,
                    validator: MultiValidator([
                      RequiredValidator(
                          errorText: S()
                              .errorRequiredPassword /*'password is required'*/),
                    ]),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(
                      right: 5 * SizeConfig.blockSizeHorizontal!),
                  child: RichText(
                    text: TextSpan(
                      text: S().forgetPassword,
                      //'Forgot Password ?',
                      style: forgotPassText,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.pushNamed(context, 'forgot pass');
                        },
                    ),
                  ),
                ),
                MainButton(
                  label: S().signIn,
                  action: () async {
                    if (formKey.currentState!.validate()) {
                      signIn();
                    }
                  },
                ),
                SizedBox(
                  height: 5 * SizeConfig.blockSizeVertical!,
                ),
                RichText(
                  text: TextSpan(
                    style: blackSmallText15,
                    children: <TextSpan>[
                      TextSpan(
                          text: S()
                              .doNotHaveAccount /*'Don\'t have an account ? '*/),
                      TextSpan(
                        text: S().signUp,
                        //'Sign up',
                        style: greenSmallText15,
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, 'register');
                          },
                      ),
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
