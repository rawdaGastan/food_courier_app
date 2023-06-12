import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:provider/provider.dart';

class VerificationCodeScreen extends StatefulWidget {
  final bool isRegisteredUser;
  final String emailOrPhoneValue;

  const VerificationCodeScreen(
      {Key? key, this.isRegisteredUser = false, this.emailOrPhoneValue = ''})
      : super(key: key);

  @override
  VerificationCodeScreenState createState() => VerificationCodeScreenState();
}

class VerificationCodeScreenState extends State<VerificationCodeScreen> {
  String _code = '';
  final TextEditingController _controller = TextEditingController();

  final int _start = 180;

  @override
  void initState() {
    super.initState();
  }

  convertToMinutes(int seconds) {
    var d = Duration(seconds: seconds);
    List<String> parts = d.toString().split(':');
    return '${parts[1].padLeft(2, '0')}:${parts[2].substring(0, 2)}';
  }

  displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
        ),
      );

  @override
  Widget build(BuildContext context) {
    String emailOrPhoneValue = widget.emailOrPhoneValue;

    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: whiteColor,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: 15 * SizeConfig.blockSizeVertical!,
              ),
              child: Text(
                S().verifyAccount,
                //'Verify Account',
                style: titleText,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5 * SizeConfig.blockSizeHorizontal!,
                  vertical: 3 * SizeConfig.blockSizeVertical!),
              child: Text(
                S().enterVerificationCode,
                //'Please enter the verification code we sent to your Email/phone number',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: subTitleText,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 5 * SizeConfig.blockSizeHorizontal!,
                  vertical: 1 * SizeConfig.blockSizeVertical!),
              child: Text(
                S().sentToMobile(emailOrPhoneValue),
                //'send to $emailOrPhoneValue',
                textAlign: TextAlign.center,
                overflow: TextOverflow.clip,
                style: fieldText,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: 5 * SizeConfig.blockSizeHorizontal!,
                  right: 5 * SizeConfig.blockSizeHorizontal!,
                  bottom: 3 * SizeConfig.blockSizeVertical!),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S().codeWillExpireIn,
                    //'Verification code will expire in ',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: subTitleText,
                  ),
                  Text(
                    convertToMinutes(_start),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: greenSmallText17,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 10 * SizeConfig.blockSizeHorizontal!),
              child: PinCodeTextField(
                length: 6,
                controller: _controller,
                obscureText: false,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                cursorColor: primaryColor,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  disabledColor: lightTextColor,
                  //fieldHeight: 60,
                  fieldWidth: 5 * SizeConfig.blockSizeVertical!,
                  inactiveColor: lightTextColor,
                  activeColor: secondaryColor,
                  selectedColor: primaryColor,
                  //selectedFillColor: blackColor,
                  activeFillColor: secondaryColor,
                  //inactiveFillColor: blackColor,
                ),
                onChanged: (value) {},
                onCompleted: (value) async {
                  setState(() {
                    _code = value;
                  });
                  if (_code != '') {
                    String error = await Provider.of<AuthenticationProvider>(
                            context,
                            listen: false)
                        .mobileLogin(_code);
                    if (error == '') {
                      displayDialog(
                          context, 'Done', 'Your mobile number is verified');
                      if (widget.isRegisteredUser) {
                        // move to reset pass
                        Navigator.pushNamed(context, 'reset pass');
                      } else {
                        // move to complete registration
                        Navigator.pushNamed(context, 'pInfo reg');
                      }
                    } else {
                      displayDialog(context, 'error', error);
                    }
                  }
                },
                onSubmitted: (value) {
                  if (value.length < 6) {
                    displayDialog(context, 'error', S().enterFullCode);
                  }
                },
                appContext: context,
              ),
            ),
            SizedBox(
              height: 4 * SizeConfig.blockSizeVertical!,
            ),
            RichText(
              text: TextSpan(
                style: subTitleText,
                children: <TextSpan>[
                  TextSpan(
                    text: S().didNotReceiveCode,
                    //'Didn\'t receive a code '
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2 * SizeConfig.blockSizeVertical!,
            ),
            RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                      text: S().resend,
                      //'Resend',
                      style: greenSmallText17,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () async {
                          await Provider.of<AuthenticationProvider>(context,
                                  listen: false)
                              .mobileVerify(emailOrPhoneValue);
                        }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
