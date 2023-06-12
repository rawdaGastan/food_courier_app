import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:food_courier/controllers/analytics.dart';
import 'package:food_courier/controllers/facebook_analytics.dart';
import 'package:food_courier/controllers/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_courier/locator.dart';

import '../controllers/logger.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final FacebookAnalyticsService _facebookAnalyticsService =
      locator<FacebookAnalyticsService>();

  final storage = const FlutterSecureStorage();

  late String verificationId;

  mobileLogin(String code) async {
    String loginMobileError = '';

    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      // Sign the user in (or link) with the credential
      UserCredential user =
          await auth.signInWithCredential(phoneAuthCredential);
      logger.d('user $user');
      String idToken = await auth.currentUser!.getIdToken();
      logger.d('idToken $idToken');
    } catch (e) {
      loginMobileError = e.toString();
    }

    return loginMobileError;
  }

  mobileVerify(String mobile) async {
    String loginMobileError = '';

    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobile,
        verificationCompleted: (PhoneAuthCredential credential) {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          //await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          logger.e('$e.message');
          if (e.code == 'invalid-phone-number') {
            logger.e('The provided phone number is not valid.');
            loginMobileError = 'The provided phone number is not valid';
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          //await Future.delayed(const Duration(seconds: 20), (){});
          verificationId = verificationId;
          logger.d('codeSent');
          logger.d('verificationId $verificationId');
          logger.d('resendToken $resendToken');
        },
        timeout: const Duration(seconds: 5),
        codeAutoRetrievalTimeout: (String verificationId) {
          verificationId = verificationId;
          logger.d('verificationId $verificationId');
          // Auto-resolution timed out...
        },
      );
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      loginMobileError = e.toString();
    }
    return loginMobileError;
  }

  Future<void> facebookLogin() async {
    try {
      // by default the login method has the next permissions ['email','public_profile']
      //permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link']
      LoginResult res = await FacebookAuth.instance.login();
      logger.d(res.accessToken);
      // get the user data
      final userData = await FacebookAuth.instance.getUserData();
      _facebookAnalyticsService.logEvent();
      logger.d(userData);
    } catch (e) {
      logger.e(e);
      switch (e) {
        case LoginStatus.operationInProgress:
          logger.e('You have a previous login operation in progress');
          break;
        case LoginStatus.cancelled:
          logger.e('login cancelled');
          break;
        case LoginStatus.failed:
          logger.e('login failed');
          break;
      }
    }
  }

  Future<void> googleLogin() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      await googleSignIn.signOut();
      // by default the login method has the next permissions ['email','public_profile']
      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      logger.e(googleUser);
      GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
      logger.e(googleAuth.idToken);
      logger.e(googleAuth.accessToken);
    } catch (error) {
      logger.e(error);
    }
  }

  Future<dynamic> get jwtOrEmpty async {
    var jwt = await storage.read(key: 'jwt');
    if (jwt == null) return '';
    return jwt;
  }

  login(String email, String password) async {
    Networking net = Networking();
    var res = await net.login(email, password);

    Map<String, dynamic> response = jsonDecode(res);
    var jwt = response['access_token'];
    var refreshToken = response['refresh_token'];
    if (jwt != null && refreshToken != null) {
      storage.write(key: 'jwt', value: jwt);
      storage.write(key: 'refresh', value: refreshToken);
      await _analyticsService.setUserProperties(
        userId: email,
        userRole: 'normal user',
      );
      await _analyticsService.logLogin();
      return 'jwt';
    } else {
      return response;
    }
  }

  Future<String?> refreshToken() async {
    Networking net = Networking();
    var tokenRefresh = await storage.read(key: 'refresh');
    var res = await net.refreshToken(tokenRefresh!);
    Map<String, dynamic> response = jsonDecode(res);
    var accessToken = response['access'];
    if (accessToken != null) {
      storage.write(key: 'jwt', value: accessToken);
      return 'jwt';
    }
    return null;
  }

  isLoggedIn() async {
    dynamic response = await jwtOrEmpty;

    if (response != '') {
      var str = response;
      var jwt = str.split('.');

      if (jwt.length != 3) {
        return 'login';
      } else {
        var payload =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        if (DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000)
            .isAfter(DateTime.now())) {
          return 'home';
        } else {
          String? res = await refreshToken();
          if (res != null) {
            return 'home';
          } else {
            return 'login';
          }
        }
      }
    } else {
      return 'login';
    }
  }

  register(String email, String password1, String password2,
      String invitation) async {
    Networking net = Networking();
    var res = await net.register(email, password1, password2, invitation);

    Map<String, dynamic> response = jsonDecode(res);
    var verificationSent = response['detail'];
    if (verificationSent != null) {
      await _analyticsService.logSignUp();
      return 'verificationSent';
    } else {
      return response;
    }
  }

  Future<String> confirmEmail(String key) async {
    Networking net = Networking();
    var res = await net.confirmEmail(key);

    Map<String, dynamic> response = jsonDecode(res);
    var confirmed = response['detail'];
    if (confirmed != null) {
      return 'confirmed';
    }

    return 'unconfirmed';
  }

  sendResetPassEmail(String email) async {
    Networking net = Networking();
    var res = await net.resetPassWithEmail(email);

    Map<String, dynamic> response = jsonDecode(res);
    var verificationSent = response['detail'];
    if (verificationSent != null) {
      return 'verificationSent';
    } else {
      return response;
    }
  }

  changePass(
      String newPassword, String newPassword2, String uid, String token) async {
    Networking net = Networking();
    var res = await net.changePass(newPassword, newPassword2, uid, token);

    Map<String, dynamic> response = jsonDecode(res);
    var passwordChanged = response['detail'];
    if (passwordChanged != null) {
      return 'passwordChanged';
    } else {
      return response;
    }
  }

  Future<String> get userToken async {
    dynamic response = await jwtOrEmpty;

    var str = response;
    var jwt = str.split('.');
    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
    if (DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000)
        .isAfter(DateTime.now())) {
      return response;
    } else {
      await refreshToken();
      response = await jwtOrEmpty;
      return response;
    }
  }
}
