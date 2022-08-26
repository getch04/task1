import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:task1/common/common_widgets.dart';
import 'package:task1/controllers/app_controller.dart';
import 'package:task1/screens/home.dart';
import 'package:task1/screens/otp_screen.dart';
import 'package:timer_count_down/timer_controller.dart';

class OtpController extends GetxController {
  CountdownController countdownController = CountdownController();
  TextEditingController otpEditingController = TextEditingController();
  Rx<double> timeCount = 0.0.obs;
  var messageOtpCode = ''.obs;
  RxString otpPin = ' '.obs;
  // RxString countryDial = '+91'.obs;
  String verID = ' ';

  Rx<bool> resendCodeClicked = false.obs;

  @override
  void onInit() async {
    super.onInit();
    resendCodeClicked.value = false;
  }
}
