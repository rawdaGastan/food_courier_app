import 'package:flutter/material.dart';
import 'package:foodCourier/controllers/size_config.dart';
import 'package:foodCourier/main.dart';
import 'package:foodCourier/generated/l10n.dart';
import 'package:foodCourier/constants/colors.dart';
import 'package:foodCourier/constants/text_styles.dart';

class Languages extends StatelessWidget {
  Map<String, Locale> languagesSupported = {
    S().arabic: Locale.fromSubtags(languageCode: 'ar'),
    S().english: Locale.fromSubtags(languageCode: 'en'),
    S().Deutsch: Locale.fromSubtags(languageCode: 'de'),
    S().french: Locale.fromSubtags(languageCode: 'fr'),
  };

  @override
  Widget build(BuildContext context) {
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
            size: 6 * SizeConfig.blockSizeHorizontal,
          ),
        ),
        centerTitle: true,
        title: Text(
          S().language,
          style: titleText,
        ),
      ),
      body: ListView.separated(
          itemCount: languagesSupported.length,
          separatorBuilder: (context, int) {
            return Divider(
              color: primaryColor,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: Icon(Icons.language, color: primaryColor),
              title: Text(
                languagesSupported.keys.elementAt(index),
                style: titleText,
              ),
              onTap: () {
                foodCourier
                    .of(context)
                    .setLocale(languagesSupported.values.elementAt(index));
                Navigator.pop(context);
              },
            );
          }),
    );
  }
}
