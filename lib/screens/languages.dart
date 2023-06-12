import 'package:flutter/material.dart';
import 'package:food_courier/controllers/size_config.dart';
import 'package:food_courier/main.dart';
import 'package:food_courier/generated/l10n.dart';
import 'package:food_courier/constants/colors.dart';
import 'package:food_courier/constants/text_styles.dart';

class Languages extends StatelessWidget {
  final Map<String, Locale> languagesSupported = {
    S().arabic: const Locale.fromSubtags(languageCode: 'ar'),
    S().english: const Locale.fromSubtags(languageCode: 'en'),
    S().Deutsch: const Locale.fromSubtags(languageCode: 'de'),
    S().french: const Locale.fromSubtags(languageCode: 'fr'),
  };

  Languages({Key? key}) : super(key: key);

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
            size: 6 * SizeConfig.blockSizeHorizontal!,
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
          separatorBuilder: (context, n) {
            return const Divider(
              color: primaryColor,
            );
          },
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: const Icon(Icons.language, color: primaryColor),
              title: Text(
                languagesSupported.keys.elementAt(index),
                style: titleText,
              ),
              onTap: () {
                FoodCourier.of(context)!
                    .setLocale(languagesSupported.values.elementAt(index));
                Navigator.pop(context);
              },
            );
          }),
    );
  }
}
