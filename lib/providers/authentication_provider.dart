import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:foodCourier/controllers/analytics.dart';
import 'package:foodCourier/controllers/facebook_analytics.dart';
import 'package:foodCourier/controllers/networking.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:foodCourier/locator.dart';

class AuthenticationProvider extends ChangeNotifier {
  final AnalyticsService _analyticsService = locator<AnalyticsService>();
  final FacebookAnalyticsService _facebookAnalyticsService =
      locator<FacebookAnalyticsService>();

  final storage = FlutterSecureStorage();

  String verificationId;

  mobileLogin(String code) async {
    String loginMobileError;

    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: code);
      // Sign the user in (or link) with the credential
      UserCredential user =
          await auth.signInWithCredential(phoneAuthCredential);
      print('user $user');
      String idToken = await auth.currentUser.getIdToken();
      print('idToken $idToken');
    } catch (e) {
      switch (e.code) {
        case 'invalid-verification-code':
          loginMobileError = 'Invalid Code';
          break;
        default:
          loginMobileError = e.message;
          break;
      }
    }
    return loginMobileError;
  }

  mobileVerify(String mobile) async {
    String loginMobileError;

    await Firebase.initializeApp();
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: mobile,
        verificationCompleted: (PhoneAuthCredential credential) {
          // ANDROID ONLY!

          // Sign the user in (or link) with the auto-generated credential
          //await auth.signInWithCredential(credential);
          print('done');
        },
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            loginMobileError = 'The provided phone number is not valid';
          }
          return loginMobileError;
        },
        codeSent: (String verificationId, int resendToken) async {
          //await Future.delayed(const Duration(seconds: 20), (){});
          this.verificationId = verificationId;
          print('codeSent');
          print('verificationId $verificationId');
          print('resendToken $resendToken');
        },
        timeout: const Duration(seconds: 5),
        codeAutoRetrievalTimeout: (String verificationId) {
          this.verificationId = verificationId;
          print('verificationId $verificationId');
          // Auto-resolution timed out...
        },
      );
      await new Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      loginMobileError = e.message;
      print(loginMobileError);
    }
    return loginMobileError;
  }

  Future<void> facebookLogin() async {
    try {
      // by default the login method has the next permissions ['email','public_profile']
      //permissions: ['email', 'public_profile', 'user_birthday', 'user_friends', 'user_gender', 'user_link']
      LoginResult res = await FacebookAuth.instance.login();
      print(res.accessToken);
      // get the user data
      final userData = await FacebookAuth.instance.getUserData();
      _facebookAnalyticsService.logEvent();
      print(userData);
    } catch (e) {
      switch (e.errorCode) {
        case LoginStatus.operationInProgress:
          print("You have a previous login operation in progress");
          break;
        case LoginStatus.cancelled:
          print("login cancelled");
          break;
        case LoginStatus.failed:
          print("login failed");
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
      GoogleSignInAccount googleUser = await googleSignIn.signIn();
      print(googleUser);
      GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      print(googleAuth.idToken);
      print(googleAuth.accessToken);
    } catch (error) {
      print(error);
    }
  }

  Future<dynamic> get jwtOrEmpty async {
    var jwt = await storage.read(key: "jwt");
    if (jwt == null) return "";
    return jwt;
  }

  login(String email, String password) async {
    Networking net = new Networking();
    var res = await net.login(email, password);

    if (res != null) {
      Map<String, dynamic> response = jsonDecode(res);
      var jwt = response['access_token'];
      var refreshToken = response['refresh_token'];
      if (jwt != null && refreshToken != null) {
        storage.write(key: "jwt", value: jwt);
        storage.write(key: "refresh", value: refreshToken);
        await _analyticsService.setUserProperties(
          userId: email,
          userRole: 'normal user',
        );
        await _analyticsService.logLogin();
        return 'jwt';
      } else if (response != null) {
        return response;
      }
    } else
      return null;
  }

  refreshToken() async {
    Networking net = new Networking();
    var tokenRefresh = await storage.read(key: "refresh");
    var res = await net.refreshToken(tokenRefresh);
    if (res != null) {
      Map<String, dynamic> response = jsonDecode(res);
      var accessToken = response['access'];
      if (accessToken != null) {
        storage.write(key: "jwt", value: accessToken);
        return 'jwt';
      }
    } else
      return null;
  }

  isLoggedIn() async {
    dynamic response = await jwtOrEmpty;

    if (response != "") {
      var str = response;
      var jwt = str.split(".");

      if (jwt.length != 3) {
        print(1);
        return 'login';
      } else {
        var payload =
            json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
        print(payload);
        if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
            .isAfter(DateTime.now())) {
          print(2);
          return 'home';
        } else {
          print(3);
          var res = await refreshToken();
          if (res != null) {
            return 'home';
          } else {
            return 'login';
          }
        }
      }
    } else {
      print(4);
      return 'login';
    }
  }

  register(String email, String password1, String password2,
      String invitation) async {
    Networking net = new Networking();
    var res = await net.register(email, password1, password2, invitation);

    if (res != null) {
      Map<String, dynamic> response = jsonDecode(res);
      var verificationSent = response['detail'];
      if (verificationSent != null) {
        await _analyticsService.logSignUp();
        return 'verificationSent';
      } else if (response != null) {
        return response;
      }
    } else
      return null;
  }

  confirmEmail(String key) async {
    Networking net = new Networking();
    var res = await net.confirmEmail(key);

    if (res != null) {
      Map<String, dynamic> response = jsonDecode(res);
      var confirmed = response['detail'];
      if (confirmed != null) {
        return 'confirmed';
      }
    } else
      return null;
  }

  sendResetPassEmail(String email) async {
    Networking net = new Networking();
    var res = await net.resetPassWithEmail(email);

    if (res != null) {
      Map<String, dynamic> response = jsonDecode(res);
      var verificationSent = response['detail'];
      if (verificationSent != null) {
        return 'verificationSent';
      } else if (response != null) {
        return response;
      }
    } else
      return null;
  }

  changePass(
      String newPassword, String newPassword2, String uid, String token) async {
    Networking net = new Networking();
    var res = await net.changePass(newPassword, newPassword2, uid, token);

    if (res != null) {
      Map<String, dynamic> response = jsonDecode(res);
      var passwordChanged = response['detail'];
      if (passwordChanged != null) {
        return 'passwordChanged';
      } else if (response != null) {
        return response;
      }
    } else
      return null;
  }

  Future<String> get userToken async {
    dynamic response = await jwtOrEmpty;

    var str = response;
    var jwt = str.split(".");
    var payload =
        json.decode(ascii.decode(base64.decode(base64.normalize(jwt[1]))));
    if (DateTime.fromMillisecondsSinceEpoch(payload["exp"] * 1000)
        .isAfter(DateTime.now())) {
      print(1);
      return response;
    } else {
      print(2);
      var res = await refreshToken();
      if (res != null) {
        response = await jwtOrEmpty;
        return response;
      } else
        return null;
    }
  }
}
