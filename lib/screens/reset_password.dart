import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:foodCourier/constants/text_styles.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/providers/authentication_provider.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/input_text_field.dart';
import 'package:foodCourier/widgets/authentication_screens_widgets/main_button.dart';
import 'package:foodCourier/generated/l10n.dart';

class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  ResetPasswordState createState() => ResetPasswordState();
}

class ResetPasswordState extends State<ResetPassword> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  displayDialog(context, title, text) => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(text),
        ),
      );

  changePass() async {
    var password = _controller.text;
    var password2 = _controller2.text;
    var response =
        await Provider.of<AuthenticationProvider>(context, listen: false)
            .changePass(password, password2, 'Mw', '5om-458e729ae3512c2851c2');
    List<String> responseList = [
      'passwordChanged',
      'new_password1',
      'new_password2',
      'uid',
      'token',
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
        displayDialog(context, 'Invalid reset', errorDialogContent.join('\n'));
      }
    } else {
      displayDialog(context, 'Error', 'An unknown error occurred.');
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
                  top: 10 * SizeConfig.blockSizeVertical!,
                  bottom: 2 * SizeConfig.blockSizeVertical!,
                ),
                child: Center(
                  child: Text(
                    S().resetPass,
                    //'Reset Password',
                    style: titleText,
                  ),
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 3 * SizeConfig.blockSizeVertical!),
                child: InputField(
                  onChanged: (String input) {},
                  controller: _controller,
                  isObscure: true,
                  label: S().newPassword,
                  //'New Password',
                  validator: MultiValidator([
                    RequiredValidator(
                        errorText: S().errorRequiredField /*'Field required'*/),
                    MinLengthValidator(8,
                        errorText: S()
                            .errorMinLengthPassword /*'password must be at least 8 digits'*/),
                    PatternValidator(r'(?=.*?[#?!@$%^&*-_])',
                        errorText: S()
                            .errorSpecialCharacterPassword /*'passwords must have at least one special character'*/),
                  ]),
                ),
              ),
              InputField(
                onChanged: (String input) {},
                controller: _controller2,
                isObscure: true,
                label: S().verifyPassword,
                //'Verify Password',
                validator: MultiValidator([
                  RequiredValidator(
                      errorText: S().errorRequiredField /*'Field required'*/),
                  MinLengthValidator(8,
                      errorText: S()
                          .errorMinLengthPassword /*'password must be at least 8 digits'*/),
                  PatternValidator(r'(?=.*?[#?!@$%^&*-_])',
                      errorText: S()
                          .errorSpecialCharacterPassword /*'passwords must have at least one special character'*/),
                ]),
              ),
              MainButton(
                label: S().continueButton,
                action: () async {
                  if (_controller.text ==
                      _controller2
                          .text /*&& formKey.currentState.validate()*/) {
                    changePass();
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
