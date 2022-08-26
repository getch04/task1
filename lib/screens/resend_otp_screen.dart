import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:task1/common/common_widgets.dart';
import 'package:task1/constants.dart';
import 'package:task1/controllers/app_controller.dart';
import 'package:task1/screens/auth.dart';
import 'package:timer_count_down/timer_count_down.dart';

class ResendOtpScreen extends StatelessWidget {
  ResendOtpScreen({Key? key}) : super(key: key);
  final appController = Get.put(AppController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: const Padding(
            padding: EdgeInsets.all(30.0),
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
          horizontal: 20.w,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Enter OTP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            SizedBox(
              height: 15.h,
            ),
            Text(
              'A five digit code has been sent to ${appController.phoneController.text}',
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            Row(
              children: [
                const Text('Incorrect Number?'),
                TextButton(
                  onPressed: () {
                    Get.to(() => Auth());
                  },
                  child: const Text(
                    'Change',
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 100.h,
            ),
            Obx(
              () => PinFieldAutoFill(
                textInputAction: TextInputAction.done,
                controller: appController.otpEditingController,
                codeLength: 5,
                currentCode: appController.messageOtpCode.value,
                onCodeSubmitted: (code) {},
                onCodeChanged: (code) {
                  appController.messageOtpCode.value = code!;
                  appController.countdownController.pause();
                  if (code.length == 5) {
                    // To perform some operation
                  }
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            appController.timeCount.value <= 0.1
                ? customButton(
                    onperess: () {
                      appController.countdownController.start();
                      appController.resendCodeClicked.value = true;
                      appController
                          .verifyPhone(appController.phoneController.text);
                    },
                    title: 'Resend OTP')
                : Obx(
                    () => customButton(
                        title: 'Resend OTP', bgrColor: Colors.grey),
                  ),
            const SizedBox(
              height: 15,
            ),
            Center(
              child: Countdown(
                controller: appController.countdownController,
                seconds: 5,
                interval: const Duration(milliseconds: 1000),
                build: (context, currentRemainingTime) {
                  if (currentRemainingTime == 0.0) {
                    appController.timeCount.value = currentRemainingTime;
                    appController.resendCodeClicked.value = false;
                    return const SizedBox();
                  } else {
                    return Text(
                        "Resend OTP in ${currentRemainingTime.toString().length == 4 ? " ${currentRemainingTime.toString().substring(0, 2)}" : " ${currentRemainingTime.toString().substring(0, 1)}"}s",
                        style: const TextStyle(fontSize: 16));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
