// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values

class S {
  S();

  static S current;

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      S.current = S();

      return S.current;
    });
  }

  static S of(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `foodCourier`
  String get appName {
    return Intl.message(
      'foodCourier',
      name: 'appName',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get CreateAccount {
    return Intl.message(
      'Create account',
      name: 'CreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign up to Lorem Ipsum is simply dummy`
  String get CreateAccountDescription {
    return Intl.message(
      'Sign up to Lorem Ipsum is simply dummy',
      name: 'CreateAccountDescription',
      desc: '',
      args: [],
    );
  }

  /// `  Facebook`
  String get faceBook {
    return Intl.message(
      '  Facebook',
      name: 'faceBook',
      desc: '',
      args: [],
    );
  }

  /// `  Google`
  String get google {
    return Intl.message(
      '  Google',
      name: 'google',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Phone Number`
  String get phone {
    return Intl.message(
      'Phone Number',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email/Phone Number`
  String get emailOrPhone {
    return Intl.message(
      'Email/Phone Number',
      name: 'emailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message(
      'Password',
      name: 'password',
      desc: '',
      args: [],
    );
  }

  /// `Email or Phone is required`
  String get errorRequiredMailOrPhone {
    return Intl.message(
      'Email or Phone is required',
      name: 'errorRequiredMailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `Invalid Email or Phone Number`
  String get errorInvalidMailOrPhone {
    return Intl.message(
      'Invalid Email or Phone Number',
      name: 'errorInvalidMailOrPhone',
      desc: '',
      args: [],
    );
  }

  /// `password is required`
  String get errorRequiredPassword {
    return Intl.message(
      'password is required',
      name: 'errorRequiredPassword',
      desc: '',
      args: [],
    );
  }

  /// `password must be at least 8 digits`
  String get errorMinLengthPassword {
    return Intl.message(
      'password must be at least 8 digits',
      name: 'errorMinLengthPassword',
      desc: '',
      args: [],
    );
  }

  /// `passwords must have at least one special character`
  String get errorSpecialCharacterPassword {
    return Intl.message(
      'passwords must have at least one special character',
      name: 'errorSpecialCharacterPassword',
      desc: '',
      args: [],
    );
  }

  /// `I Agree with our `
  String get agreeOf {
    return Intl.message(
      'I Agree with our ',
      name: 'agreeOf',
      desc: '',
      args: [],
    );
  }

  /// `Terms`
  String get terms {
    return Intl.message(
      'Terms',
      name: 'terms',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(
      ' and ',
      name: 'and',
      desc: '',
      args: [],
    );
  }

  /// `Conditions`
  String get conditions {
    return Intl.message(
      'Conditions',
      name: 'conditions',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account? `
  String get alreadyHaveAccount {
    return Intl.message(
      'Already have an account? ',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get signIn {
    return Intl.message(
      'Sign in',
      name: 'signIn',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get signUp {
    return Intl.message(
      'Sign up',
      name: 'signUp',
      desc: '',
      args: [],
    );
  }

  /// `Welcome`
  String get welcome {
    return Intl.message(
      'Welcome',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to Lorem Ipsum is simply dummy`
  String get loginDescription {
    return Intl.message(
      'Sign in to Lorem Ipsum is simply dummy',
      name: 'loginDescription',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password ?`
  String get forgetPassword {
    return Intl.message(
      'Forgot Password ?',
      name: 'forgetPassword',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account ? `
  String get doNotHaveAccount {
    return Intl.message(
      'Don\'t have an account ? ',
      name: 'doNotHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Enter your mail/phone to reset your password`
  String get enterEmailOrPhoneToReset {
    return Intl.message(
      'Enter your mail/phone to reset your password',
      name: 'enterEmailOrPhoneToReset',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueButton {
    return Intl.message(
      'Continue',
      name: 'continueButton',
      desc: '',
      args: [],
    );
  }

  /// `Forgot Password`
  String get forgotPassword {
    return Intl.message(
      'Forgot Password',
      name: 'forgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Feedback`
  String get feedback {
    return Intl.message(
      'Feedback',
      name: 'feedback',
      desc: '',
      args: [],
    );
  }

  /// `Tuesday  `
  String get dayFeedback {
    return Intl.message(
      'Tuesday  ',
      name: 'dayFeedback',
      desc: '',
      args: [],
    );
  }

  /// `20:21`
  String get timeFeedback {
    return Intl.message(
      '20:21',
      name: 'timeFeedback',
      desc: '',
      args: [],
    );
  }

  /// `How satisfied are you with the service?`
  String get satisfied {
    return Intl.message(
      'How satisfied are you with the service?',
      name: 'satisfied',
      desc: '',
      args: [],
    );
  }

  /// `Type your message here...`
  String get enterMsg {
    return Intl.message(
      'Type your message here...',
      name: 'enterMsg',
      desc: '',
      args: [],
    );
  }

  /// `Read 16:26`
  String get seen {
    return Intl.message(
      'Read 16:26',
      name: 'seen',
      desc: '',
      args: [],
    );
  }

  /// `Delivery`
  String get delivery {
    return Intl.message(
      'Delivery',
      name: 'delivery',
      desc: '',
      args: [],
    );
  }

  /// `Grocery`
  String get grocery {
    return Intl.message(
      'Grocery',
      name: 'grocery',
      desc: '',
      args: [],
    );
  }

  /// `Dine out`
  String get dineOut {
    return Intl.message(
      'Dine out',
      name: 'dineOut',
      desc: '',
      args: [],
    );
  }

  /// `Ve`
  String get Ve {
    return Intl.message(
      'Ve',
      name: 'Ve',
      desc: '',
      args: [],
    );
  }

  /// `Good`
  String get Good {
    return Intl.message(
      'Good',
      name: 'Good',
      desc: '',
      args: [],
    );
  }

  /// `Menu`
  String get menu {
    return Intl.message(
      'Menu',
      name: 'menu',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get myProfile {
    return Intl.message(
      'Profile',
      name: 'myProfile',
      desc: '',
      args: [],
    );
  }

  /// `Wish List`
  String get wishList {
    return Intl.message(
      'Wish List',
      name: 'wishList',
      desc: '',
      args: [],
    );
  }

  /// `Send Feedback`
  String get sendFeedback {
    return Intl.message(
      'Send Feedback',
      name: 'sendFeedback',
      desc: '',
      args: [],
    );
  }

  /// `About Us`
  String get aboutUs {
    return Intl.message(
      'About Us',
      name: 'aboutUs',
      desc: '',
      args: [],
    );
  }

  /// `How it Works`
  String get howItWorks {
    return Intl.message(
      'How it Works',
      name: 'howItWorks',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `select region`
  String get selectRegion {
    return Intl.message(
      'select region',
      name: 'selectRegion',
      desc: '',
      args: [],
    );
  }

  /// `Filter`
  String get filter {
    return Intl.message(
      'Filter',
      name: 'filter',
      desc: '',
      args: [],
    );
  }

  /// `Clear`
  String get clear {
    return Intl.message(
      'Clear',
      name: 'clear',
      desc: '',
      args: [],
    );
  }

  /// `Sort By :`
  String get sortBy {
    return Intl.message(
      'Sort By :',
      name: 'sortBy',
      desc: '',
      args: [],
    );
  }

  /// `Apply`
  String get apply {
    return Intl.message(
      'Apply',
      name: 'apply',
      desc: '',
      args: [],
    );
  }

  /// `Find restaurant, meal...`
  String get search {
    return Intl.message(
      'Find restaurant, meal...',
      name: 'search',
      desc: '',
      args: [],
    );
  }

  /// `{distance} km`
  String distance(Object distance) {
    return Intl.message(
      '$distance km',
      name: 'distance',
      desc: '',
      args: [distance],
    );
  }

  /// `{rating}`
  String rating(Object rating) {
    return Intl.message(
      '$rating',
      name: 'rating',
      desc: '',
      args: [rating],
    );
  }

  /// `{name}`
  String name(Object name) {
    return Intl.message(
      '$name',
      name: 'name',
      desc: '',
      args: [name],
    );
  }

  /// `{city}`
  String city(Object city) {
    return Intl.message(
      '$city',
      name: 'city',
      desc: '',
      args: [city],
    );
  }

  /// `{town}`
  String town(Object town) {
    return Intl.message(
      '$town',
      name: 'town',
      desc: '',
      args: [town],
    );
  }

  /// `{labels}`
  String labels(Object labels) {
    return Intl.message(
      '$labels',
      name: 'labels',
      desc: '',
      args: [labels],
    );
  }

  /// `Arabic`
  String get arabic {
    return Intl.message(
      'Arabic',
      name: 'arabic',
      desc: '',
      args: [],
    );
  }

  /// `English`
  String get english {
    return Intl.message(
      'English',
      name: 'english',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get french {
    return Intl.message(
      'French',
      name: 'french',
      desc: '',
      args: [],
    );
  }

  /// `Deutsch`
  String get Deutsch {
    return Intl.message(
      'Deutsch',
      name: 'Deutsch',
      desc: '',
      args: [],
    );
  }

  /// `skip`
  String get skip {
    return Intl.message(
      'skip',
      name: 'skip',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message(
      'Back',
      name: 'back',
      desc: '',
      args: [],
    );
  }

  /// `Personal Information`
  String get personalInfo {
    return Intl.message(
      'Personal Information',
      name: 'personalInfo',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get userName {
    return Intl.message(
      'Name',
      name: 'userName',
      desc: '',
      args: [],
    );
  }

  /// `Age`
  String get userAge {
    return Intl.message(
      'Age',
      name: 'userAge',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get userAddress {
    return Intl.message(
      'Address',
      name: 'userAddress',
      desc: '',
      args: [],
    );
  }

  /// `Work Address`
  String get userWorkAddress {
    return Intl.message(
      'Work Address',
      name: 'userWorkAddress',
      desc: '',
      args: [],
    );
  }

  /// `Choose specific location`
  String get chooseLocation {
    return Intl.message(
      'Choose specific location',
      name: 'chooseLocation',
      desc: '',
      args: [],
    );
  }

  /// `How long have been following Diet ?`
  String get dietPeriod {
    return Intl.message(
      'How long have been following Diet ?',
      name: 'dietPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Now`
  String get now {
    return Intl.message(
      'Now',
      name: 'now',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Week',
      name: 'week',
      desc: '',
      args: [],
    );
  }

  /// `Month`
  String get month {
    return Intl.message(
      'Month',
      name: 'month',
      desc: '',
      args: [],
    );
  }

  /// `Year`
  String get year {
    return Intl.message(
      'Year',
      name: 'year',
      desc: '',
      args: [],
    );
  }

  /// `Preferences & Restrictions`
  String get preferences {
    return Intl.message(
      'Preferences & Restrictions',
      name: 'preferences',
      desc: '',
      args: [],
    );
  }

  /// `Change profile picture`
  String get changePicture {
    return Intl.message(
      'Change profile picture',
      name: 'changePicture',
      desc: '',
      args: [],
    );
  }

  /// `Reset Password`
  String get resetPass {
    return Intl.message(
      'Reset Password',
      name: 'resetPass',
      desc: '',
      args: [],
    );
  }

  /// `New Password`
  String get newPassword {
    return Intl.message(
      'New Password',
      name: 'newPassword',
      desc: '',
      args: [],
    );
  }

  /// `Verify Password`
  String get verifyPassword {
    return Intl.message(
      'Verify Password',
      name: 'verifyPassword',
      desc: '',
      args: [],
    );
  }

  /// `Field required`
  String get errorRequiredField {
    return Intl.message(
      'Field required',
      name: 'errorRequiredField',
      desc: '',
      args: [],
    );
  }

  /// `Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, `
  String get splashText {
    return Intl.message(
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, ',
      name: 'splashText',
      desc: '',
      args: [],
    );
  }

  /// `Verify Account`
  String get verifyAccount {
    return Intl.message(
      'Verify Account',
      name: 'verifyAccount',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code we sent to your Email/phone number`
  String get enterVerificationCode {
    return Intl.message(
      'Please enter the verification code we sent to your Email/phone number',
      name: 'enterVerificationCode',
      desc: '',
      args: [],
    );
  }

  /// `Verification code will expire in `
  String get codeWillExpireIn {
    return Intl.message(
      'Verification code will expire in ',
      name: 'codeWillExpireIn',
      desc: '',
      args: [],
    );
  }

  /// `Sent to {mobile}`
  String sentToMobile(Object mobile) {
    return Intl.message(
      'Sent to $mobile',
      name: 'sentToMobile',
      desc: '',
      args: [mobile],
    );
  }

  /// `Please enter full code`
  String get enterFullCode {
    return Intl.message(
      'Please enter full code',
      name: 'enterFullCode',
      desc: '',
      args: [],
    );
  }

  /// `Didn't receive a code `
  String get didNotReceiveCode {
    return Intl.message(
      'Didn\'t receive a code ',
      name: 'didNotReceiveCode',
      desc: '',
      args: [],
    );
  }

  /// `Resend`
  String get resend {
    return Intl.message(
      'Resend',
      name: 'resend',
      desc: '',
      args: [],
    );
  }

  /// `Restaurant`
  String get restaurant {
    return Intl.message(
      'Restaurant',
      name: 'restaurant',
      desc: '',
      args: [],
    );
  }

  /// `Meal`
  String get meal {
    return Intl.message(
      'Meal',
      name: 'meal',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviews {
    return Intl.message(
      'Reviews',
      name: 'reviews',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get restaurantInfo {
    return Intl.message(
      'Info',
      name: 'restaurantInfo',
      desc: '',
      args: [],
    );
  }

  /// `save`
  String get save {
    return Intl.message(
      'save',
      name: 'save',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'fr'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    if (locale != null) {
      for (var supportedLocale in supportedLocales) {
        if (supportedLocale.languageCode == locale.languageCode) {
          return true;
        }
      }
    }
    return false;
  }
}
