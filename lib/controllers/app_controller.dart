// ignore_for_file: invalid_use_of_visible_for_testing_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:task1/common/common_widgets.dart';
import 'package:task1/screens/home.dart';
import 'package:task1/screens/otp_screen.dart';
import 'package:timer_count_down/timer_controller.dart';

class AppController extends GetxController {
  Rx<int> activeTab = 0.obs;
  RxString countryDial = '+251'.obs;
  Rx<double> timeCount = 0.0.obs;
  Rx<String> messageOtpCode = ''.obs;
  RxString otpPin = ' '.obs;
  String verID = ' ';
  Rx<bool> resendCodeClicked = false.obs;
  Rx<bool> isDoneBtnActive = false.obs;
  Rx<bool> isAuthenticating = false.obs;

  TextEditingController phoneController = TextEditingController();
  CountdownController countdownController = CountdownController();
  TextEditingController otpEditingController = TextEditingController();

  @override
  void onInit() async {
    super.onInit();
    resendCodeClicked.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    resendCodeClicked.value = false;
    countdownController.start();
  }

  @override
  void onClose() {
    super.onClose();
    // messageOtpCode.value = '';
    // SmsAutoFill().unregisterListener();
    resendCodeClicked.value = false;
    phoneController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    resendCodeClicked.value = false;
  }

  String cc = '';
  final _auth = FirebaseAuth.instance;

  Future<void> verifyPhone(String number) async {
    isAuthenticating.value = true;
    final controller = Get.put(AppController());
    await _auth.verifyPhoneNumber(
      phoneNumber: "${controller.countryDial.value} $number",
      timeout: const Duration(seconds: 120),
      // autoRetrievedSmsCodeForTesting: '123456',

      verificationCompleted: (PhoneAuthCredential credential) {
        isAuthenticating.value = false;
        Logger().d(credential.smsCode.toString());
        messageOtpCode.value = credential.smsCode.toString();
        otpEditingController.text = credential.smsCode.toString();
        cc = credential.smsCode.toString();
        Logger().d(
            '${credential.smsCode} + ${credential.verificationId}+ ${credential.providerId}');
        showSnackBarText("Auth Completed!");
        Get.to(() => OtpScreen());
      },
      verificationFailed: (FirebaseAuthException e) {
        isAuthenticating.value = false;
        showSnackBarText("Auth Failed! ${e.message}");
      },
      codeSent: (String verificationId, int? resendToken) {
        isAuthenticating.value = false;
        showSnackBarText("OTP Sent!");
        verID = verificationId;
        messageOtpCode.value = cc;
        Logger().d(resendToken);
        Get.to(() => OtpScreen());
      },
      codeAutoRetrievalTimeout: (String msg) {
        isAuthenticating.value = false;
        showSnackBarText('The OTP is taking too long, please try again');
      },
    );
  }

  Future<void> verifyOTP() async {
    try {
      await _auth
          .signInWithCredential(
            PhoneAuthProvider.credential(
              verificationId: verID,
              smsCode: otpPin.value,
            ),
          )
          .then((value) => value.user != null
              ? Get.to(() => const Home())
              : Logger().d(value));
    } on FirebaseAuthException catch (_, e) {
      showSnackBarText(e.toString());
    }
  }
}
