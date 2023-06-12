import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_courier/controllers/logger.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:food_courier/constants/text_styles.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/generated/l10n.dart';

class VerificationCodeScreen2 extends StatefulWidget {
  final bool isRegisteredUser = false;
  final String emailOrPhoneValue = '';
  const VerificationCodeScreen2({Key? key}) : super(key: key);

  @override
  VerificationCodeScreenState createState() => VerificationCodeScreenState();
}

class VerificationCodeScreenState extends State<VerificationCodeScreen2>
    with CodeAutoFill {
  String _code = '';
  String _signature = '';

  int _start = 180;

  @override
  void codeUpdated() {
    setState(() {
      _code = code as String;
    });
  }

  @override
  void initState() {
    super.initState();
    listenForCode();

    SmsAutoFill().getAppSignature.then((signature) {
      setState(() {
        _signature = signature;
        logger.d(_signature); // feknpwVtmrc
      });
    });

    //startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    cancel();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  convertToMinutes(int seconds) {
    var d = Duration(seconds: seconds);
    List<String> parts = d.toString().split(':');
    return '${parts[1].padLeft(2, '0')}:${parts[2].substring(0, 2)}';
  }

  mobileVerify(String emailOrPhoneValue) async {
    //await Provider.of<AuthenticationProvider>(context,listen: false).mobileLogin(emailOrPhoneValue, _code);
  }

  @override
  Widget build(BuildContext context) {
    String emailOrPhoneValue = widget.emailOrPhoneValue;

    mobileVerify(emailOrPhoneValue);

    SizeConfig().init(context);
    return Scaffold(
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
                  horizontal: 20 * SizeConfig.blockSizeHorizontal!),
              child: PinFieldAutoFill(
                decoration: BoxLooseDecoration(
                  bgColorBuilder: _code != ''
                      ? const FixedColorBuilder(secondaryColor)
                      : const FixedColorBuilder(whiteColor),
                  textStyle: titleText,
                  //strokeColorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
                  strokeColorBuilder: _code == ''
                      ? const FixedColorBuilder(lightTextColor)
                      : const FixedColorBuilder(whiteColor),
                  gapSpace: 10.0,
                ),
                currentCode: _code,
                autoFocus: true,
                onCodeSubmitted: (_) async {
                  if (widget.isRegisteredUser) {
                    // move to reset pass
                    Navigator.pushNamed(context, 'reset pass');
                  } else {
                    // move to complete registration
                    logger.d(_code);
                    //await Provider.of<AuthenticationProvider>(context,listen: false).mobileCodeSent(widget.emailOrPhoneValue, '123456');
                    Navigator.pushNamed(context, 'pInfo reg');
                  }
                },
                onCodeChanged: (_) {},
                codeLength: 6,
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
                      recognizer: TapGestureRecognizer()..onTap = () {}),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
