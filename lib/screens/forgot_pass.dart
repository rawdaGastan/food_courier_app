import 'package:auto_size_text/auto_size_text.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/input_textField.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/generated/l10n.dart';
//import 'package:google_tag_manager/google_tag_manager.dart' as gtm;

class ForgotPass extends StatefulWidget {
  const ForgotPass({Key? key}) : super(key: key);

  @override
  ForgotPassState createState() => ForgotPassState();
}

class ForgotPassState extends State<ForgotPass> {
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final numericRegex = RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');
  bool isMobile = false;
  String phoneOrEmail = S().emailOrPhone;
  String emailOrPhoneValue = '';
  late CountryCode countryCode;

  displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
        ),
      );

  sendResetPasswordEmail() async {
    if (emailOrPhoneValue == '' && isMobile == true) {
    } else {
      var email = _controller.text;
      var response =
          await Provider.of<AuthenticationProvider>(context, listen: false)
              .sendResetPassEmail(email);
      List<String> responseList = [
        'verificationSent',
        'email',
        'non_field_errors'
      ];

      if (response != null) {
        if (response == responseList[0]) {
          Navigator.pushNamed(context, 'reset pass');
        } else {
          List<String> errorDialogContent = [];
          for (int i = 1; i < responseList.length; i++) {
            if (response[responseList[i]] != null) {
              errorDialogContent.add(
                  '${responseList[i]} : ${response[responseList[i]].join('\n')}');
            }
          }
          displayDialog(
              context, 'Invalid reset', errorDialogContent.join('\n'));
        }
      } else {
        displayDialog(context, 'Error', 'An unknown error occurred.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: formKey,
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
              Padding(
                padding: EdgeInsets.only(
                  top: 3 * SizeConfig.blockSizeVertical!,
                  bottom: 2 * SizeConfig.blockSizeVertical!,
                ),
                child: Center(
                  child: Text(
                    S().forgotPassword,
                    //'Forgot Password',
                    style: titleText,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 5 * SizeConfig.blockSizeHorizontal!),
                child: Center(
                  child: AutoSizeText(
                    S().enterEmailOrPhoneToReset,
                    //'Enter your mail/phone to reset your password',
                    style: subTitleText,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 6 * SizeConfig.blockSizeVertical!,
                    left: 5 * SizeConfig.blockSizeHorizontal!,
                    right: 5 * SizeConfig.blockSizeHorizontal!),
                child: InputField(
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
                  controller: _controller,
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
              MainButton(
                label: S().continueButton,
                action: () async {
                  if (formKey.currentState!.validate()) {
                    sendResetPasswordEmail();
                    //gtm.pushEvent('button1-click');
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => VerificationCodeScreen(
                        isRegisteredUser: true,
                        emailOrPhoneValue: emailOrPhoneValue,
                      ),
                      ),
                    );*/
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
